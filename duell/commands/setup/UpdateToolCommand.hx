/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.commands.setup;

import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;

import duell.objects.Haxelib;
import duell.objects.DuellConfigJSON;

import haxe.CallStack;

import duell.commands.IGDCommand;
class UpdateToolCommand implements IGDCommand
{	
	private static var haxeURL = "http://haxe.org/";
    private static var defaultRepoListURL : String = "ssh://git@phabricator.office.gameduell.de:2222/diffusion/HAXMISCHAXEREPOLIST/haxe-repo-list.git";

    public static var helpString : String = '   \x1b[1mself_update\x1b[0m\n' +
                                            '\n' +
                                            'Update the tool itself. \n';

    public function new()
    {

    }

    public function execute(cmd : String, args : Array<String>) : String
    {
    	try
    	{
	    	LogHelper.info("");
	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("Update Tool");
	    	LogHelper.info("------\x1b[0m");
	    	LogHelper.info("");

	    	checkIfToolIsInstalled();

	    	LogHelper.println("");

	    	updateTheTool();

	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("end");
	    	LogHelper.info("------\x1b[0m");
    	} 
    	catch(error : Dynamic)
    	{
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.error("An error occurred, do you need admin permissions to run the script? Check if you have permissions to write on the paths you specify. Error:" + error);
    	}
	    
	    return "success";
    }

	private function checkIfToolIsInstalled()
	{
		///install command into the settings dir, etc
		LogHelper.println("Checking if the duell command is properly installed in haxelib...");

    	var duell = Haxelib.getHaxelib("duell");

		if(!duell.exists())
		{
			LogHelper.error("Duell command is not properly installed, please run the \"setup\" command.");
		}

		LogHelper.println("installed!");
	}

	private function updateTheTool()
	{
		var duellLibList = DuellLibListHelper.getDuellLibReferenceList();

		var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

		if(!duellLibList.exists("duell"))
		{
			LogHelper.error("The duell tool is not defined in " + duellConfigJSON.repoListURLs.join(", "));
		}

		var duell = duellLibList.get("duell");
		LogHelper.println("updating " + duellConfigJSON.localLibraryPath + "/" + duell.destinationPath);
		duell.update();
	}
}
