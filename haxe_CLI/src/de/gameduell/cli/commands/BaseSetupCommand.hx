/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package de.gameduell.cli.commands;

import de.gameduell.cli.helpers.PlatformHelper;
import de.gameduell.cli.helpers.AskHelper;
import de.gameduell.cli.helpers.DownloadHelper;
import de.gameduell.cli.helpers.ExtractionHelper;
import de.gameduell.cli.helpers.PathHelper;
import de.gameduell.cli.helpers.LogHelper;
import de.gameduell.cli.helpers.StringHelper;
import de.gameduell.cli.commands.impl.IGDCommand;
import de.gameduell.cli.helpers.ProcessHelper;
import de.gameduell.cli.helpers.HXCPPConfigXMLHelper;

import haxe.Http;
import haxe.io.Eof;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import arguable.ArgParser;
import neko.Lib;

class BaseSetupCommand implements IGDCommand
{	
	private static var haxeURL = "http://haxe.org/";
	
	/// RESULTING VARIABLES
    
    public function new()
    {

    }

    public function execute(cmd : String) : String
    {
    	try
    	{
	    	LogHelper.println("");
	    	LogHelper.println("\x1b[2m------");
	    	LogHelper.println("Base Setup");
	    	LogHelper.println("------\x1b[0m");
	    	LogHelper.println("");

	    	setupHaxe();

	    	LogHelper.println("");

	    	setupHXCPP();

	    	LogHelper.println("");
	    	LogHelper.println("To install Android development run \"\x1b[1mgdtool setup_android\x1b[0m\"");
	    	LogHelper.println("To install Flash development run \"\x1b[1mgdtool setup_flash\x1b[0m\"");
	    	LogHelper.println("To setup an environment for a project, run \"\x1b[1mgdtool install <project file>\x1b[0m.");

	    	LogHelper.println("\x1b[2m------");
	    	LogHelper.println("end");
	    	LogHelper.println("------\x1b[0m");

    	} catch(error : Dynamic)
    	{
    		LogHelper.error("An error occurred, do you need admin permissions to run the script? Check if you have permissions to write on the paths you specify. Error:" + error);
    	}
	    
	    return "success";
    }

	private function setupHaxe()
	{
    	LogHelper.println("Checking haxe installation... ");

    	/// we test with haxelib because haxe returns null for some reason.
		var output : String = ProcessHelper.runProcess("", "haxelib", [], true, true, true, false);
		if(output.indexOf("Haxe Library Manager") == -1)
		{
			LogHelper.println("not found.");
			LogHelper.println("It seems haxe is not installed or not accessible in the command line.");

			var answer = AskHelper.askYesOrNo("Do you want to visit the haxe website to install it?");

			if(answer == Yes)
			{
				ProcessHelper.openURL(haxeURL);
			}

			LogHelper.println("Rerun the script with haxe installed.");

			Sys.exit(0);
		}
		else
		{
    		LogHelper.println("Installed!");
		}
	}

	private function setupHXCPP()
	{
    	LogHelper.println("Checking hxcpp installation... ");
		var output : String = ProcessHelper.runProcess("", "haxelib", ["run", "hxcpp"], true, true);
		if(output.indexOf("Library hxcpp not installed") != -1)
		{
			LogHelper.println("not found");
			LogHelper.println("Installing hxcpp...");
			ProcessHelper.runProcess("", "haxelib", ["run", "hxcpp"], true, true);

    		LogHelper.println("Rechecking hxcpp installation... ");

			output = ProcessHelper.runProcess("", "haxelib", ["run", "hxcpp"], true, true);
			if(output.indexOf("Library hxcpp not installed") != -1)
			{
				LogHelper.println("Installed!");
			}
			else
			{
				LogHelper.error("Still not installed, unknown error occurred...");
			}

		}
		else
		{
			LogHelper.println("Installed!");
		}
	}
}
