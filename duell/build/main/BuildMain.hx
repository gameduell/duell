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
