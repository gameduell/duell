/**
 * @autor rcam
 * @date 05.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.main;

import duell.build.plugin.platform.PlatformBuild;

import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;

class BuildMain 
{
    public static function main()
    {
 		var args = Sys.args();

		try 
		{
	 		var build = new PlatformBuild();

	 		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

	 		for (requiredSetup in build.requiredSetups)
	 		{
		        if (duellConfig.setupsCompleted.indexOf(requiredSetup) == -1)
		        {
		        	LogHelper.error('You are missing a setup. Please run duell setup $requiredSetup');
		        }
	 		}

	 		build.build(args);

	 		if (Sys.args().indexOf("-run") != -1)
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
