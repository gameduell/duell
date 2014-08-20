/**
 * @autor rcam
 * @date 05.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.main;

import duell.build.objects.Configuration;
import haxe.CallStack;
import duell.build.plugin.platform.PlatformBuild;

import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;

class BuildMain 
{
    public static function main()
    {
		try 
		{
	 		var build = new PlatformBuild();
            var pluginHelper : LibraryPluginHelper = new LibraryPluginHelper();

	 		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

	 		for (requiredSetup in build.requiredSetups)
	 		{
		        if (duellConfig.setupsCompleted.indexOf(requiredSetup) == -1)
		        {
		        	LogHelper.error('You are missing a setup. Please run duell setup $requiredSetup');
		        }
	 		}

            build.parse();
            pluginHelper.resolveLibraryPlugins();
            pluginHelper.postParse();

            build.prepareBuild();

            pluginHelper.preBuild();
            build.build();
            pluginHelper.postBuild();

	 		if (Sys.args().indexOf("-run") != -1)
	 		{
	 			build.run();
	 		}
		}
    	catch(error : Dynamic)
    	{
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.error("An error occurred. Error: " + error);
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
}