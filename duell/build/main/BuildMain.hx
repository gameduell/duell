/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.build.main;

import duell.build.objects.Configuration;
import duell.helpers.PathHelper;
import haxe.CallStack;

import duell.build.objects.Configuration;
import duell.build.plugin.platform.PlatformBuild;

import duell.helpers.LogHelper;
import duell.helpers.PlatformHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibHelper;

import duell.objects.Arguments;
import duell.objects.DuellConfigJSON;

import sys.io.File;
import sys.FileSystem;

import haxe.io.Path;

import duell.helpers.LogHelper;

class BuildMain
{
    private static inline var SERIALIZED_CACHES_FILENAME = 'serialized_duelllib_caches.cache';
    public static function main()
    {
        Arguments.validateArguments();

        var build: PlatformBuild = null;

        for (define in Arguments.defines.keys())
        {
            Configuration.addParsingDefine(define);
        }
		try
        {
	 	    build = new PlatformBuild();
            var pluginHelper : LibraryPluginHelper = new LibraryPluginHelper();

	 		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

            if (build.supportedHostPlatforms.indexOf(PlatformHelper.hostPlatform) == -1)
            {
                throw "The current host platform '" + PlatformHelper.hostPlatform + "' is not supported for this build.";
            }

	 		for (requiredSetup in build.requiredSetups)
	 		{
                var requiredSetupString = requiredSetup.name + ":" + requiredSetup.version;
		        if (duellConfig.setupsCompleted.indexOf(requiredSetupString) == -1)
		        {
                    /// Temporary workaround for previous unversioned version
                    if (duellConfig.setupsCompleted.indexOf(requiredSetup.name) != -1)
                    {
                        duellConfig.setupsCompleted.remove(requiredSetup.name);
                        duellConfig.setupsCompleted.push(requiredSetupString);
                        duellConfig.writeToConfig();
                    }
                    else
                    {
                        throw 'You are missing a setup. Please run duell setup ${requiredSetup.name} -v ${requiredSetup.version}';
                    }
		        }
	 		}

            if (Arguments.isSet("-testport"))
            {
                Configuration.getData().TEST_PORT = Arguments.get("-testport");
            }

            if (Arguments.isSet("-publish"))
            {
                Configuration.addParsingDefine("publish");
            }

            if (Arguments.isSet("-fast"))
            {
                deserializeCaches();
                build.parse();
                pluginHelper.resolveLibraryPlugins();
                pluginHelper.fast();

                build.fast();
                return;
            }

            build.parse();

            pluginHelper.resolveLibraryPlugins();

            if (Arguments.isSet("-clean"))
            {
                pluginHelper.clean();
                build.clean();
                return;
            }

            pluginHelper.postParse();

            pluginHelper.postPostParse();

            if (!Arguments.isSet("-noprebuild"))
            {
                build.prepareBuild();
                pluginHelper.preBuild();
            }

            if (!Arguments.isSet("-nobuild"))
            {
                build.build();
                pluginHelper.postBuild();
            }

            serializeCaches();

            if (Arguments.isSet("-publish"))
            {
                createPublishFolderIfNotExists();

                build.publish();
                pluginHelper.postPublish();
            }
            else if (Arguments.isSet("-test"))
            {
                build.test();
            }
            else if (!Arguments.isSet("-norun"))
	 		{
	 			build.run();
	 		}
		}
    	catch(error : Dynamic)
    	{
            if (build != null)
            {
                build.handleError();
            }
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.exitWithFormattedError(Std.string(error));
    	}
    }

    private static function serializeCaches()
    {
        var tmpFolder = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
        var serializedCachesFile = Path.join([tmpFolder, SERIALIZED_CACHES_FILENAME]);

        var fileOutput = File.write(serializedCachesFile, true);
        fileOutput.writeString(DuellLibHelper.serializeCaches());
        fileOutput.close();
    }

    private static function deserializeCaches()
    {
        var tmpFolder = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
        var serializedCachesFile = Path.join([tmpFolder, SERIALIZED_CACHES_FILENAME]);

        var s = File.getBytes(serializedCachesFile).toString();

        DuellLibHelper.deserializeCaches(s);
    }

    private static function createPublishFolderIfNotExists()
    {
        var publishFolder: String = Configuration.getData().PUBLISH;

        if (!FileSystem.exists(publishFolder))
        {
            PathHelper.mkdir(publishFolder);
        }
    }
}

class LibraryPluginHelper
{
    private var pluginArray : Array<Dynamic>;

    public function new ()
    {
        pluginArray = new Array();
    }

    public function resolveLibraryPlugins()
    {
        for (duellLibDef in Configuration.getData().DEPENDENCIES.DUELLLIBS)
        {
            var name : String = duellLibDef.name;

            var parserClass = Type.resolveClass('duell.build.plugin.library.$name.LibraryBuild');

            if (parserClass != null)
            {
                var libraryPlugin : Dynamic = Type.createInstance(parserClass, []);
                pluginArray.push(libraryPlugin);
            }
        }
    }

    public function postParse()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "postParse");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function postPostParse()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "postPostParse");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function preBuild()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "preBuild");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function postBuild()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "postBuild");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function postPublish()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "postPublish");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function fast()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "fast");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }

    public function clean()
    {
        for (element in pluginArray)
        {
            var parseFunction : Dynamic = Reflect.field(element, "clean");
            if (parseFunction != null)
            {
                Reflect.callMethod(element, parseFunction, []);
            }
        }
    }
}
