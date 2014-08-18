/**
 * @autor rcam
 * @date 05.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.main;

import duell.build.plugin.platform.PlatformBuild;

import duell.helpers.LogHelper;

class BuildMain 
{
    public static function main()
    {
 		var args = Sys.args();

 		var run : Bool = false;

 		for (arg in Sys.args())
 		{
 			if (arg == "-nocolor")
 			{
 				duell.helpers.LogHelper.enableColor = false;
 			}
 			else if (arg == "-verbose")
 			{
 				duell.helpers.LogHelper.verbose = true;
 			} 
 			else if (arg == "-run")
 			{
 				run = true;
 			}
 		}

		try 
		{
	 		var build = new PlatformBuild();

	 		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

	 		for (requiredSetup in build.getRequiredSetups())
	 		{
		        if (duellConfig.setupsCompleted.indexOf(requiredSetup) == -1)
		        {
		        	LogHelper.error('You are missing a setup. Please run duell setup $requiredSetup');
		        }
	 		}

	 		build.build(args);

	 		if (run)
	 		{
	 			build.run(args);
	 		}
		}
    	catch(error : Dynamic)
    	{
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.error("An error occurred. Error: " + error);
    	}
    }
}
