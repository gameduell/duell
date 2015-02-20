/**
 * @autor rcam
 * @date 05.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.main;

import haxe.CallStack;

import duell.build.objects.Configuration;
import duell.build.plugin.platform.PlatformBuild;

import duell.helpers.LogHelper;
import duell.helpers.PlatformHelper;
import duell.helpers.DuellConfigHelper;

import duell.objects.Arguments;
import duell.objects.DuellConfigJSON;

class BuildMain 
{
    public static function main()
    {
        Arguments.validateArguments();

        for (define in Arguments.defines.keys())
        {
            Configuration.addParsingDefine(define);
        }
		try 
        {
	 		var build = new PlatformBuild();
            var pluginHelper : LibraryPluginHelper = new LibraryPluginHelper();

	 		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

            if (build.supportedHostPlatforms.indexOf(PlatformHelper.hostPlatform) == -1)
            {
                LogHelper.error("The current host platform '" + PlatformHelper.hostPlatform + "' is not supported for this build.");
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
                        LogHelper.error('You are missing a setup. Please run duell setup ${requiredSetup.name} -v ${requiredSetup.version}');
                    }
		        }
	 		}

            if (Arguments.isSet("-fast"))
            {
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
            }

            if (!Arguments.isSet("-nobuild"))
            {
                pluginHelper.preBuild();
                build.build();
                pluginHelper.postBuild();
            }

            if (Arguments.isSet("-publish"))
            {
                build.publish();
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
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.error(error);
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