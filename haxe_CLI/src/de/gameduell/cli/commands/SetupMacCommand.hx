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
import neko.Lib;

class SetupMacCommand implements IGDCommand
{	
	private static var appleXcodeURL = "http://developer.apple.com/xcode/";
	
    
    public function new()
    {

    }

    public function execute(cmd : String) : String
    {
    	try
    	{

    		if(PlatformHelper.hostPlatform != Platform.MAC) 
    		{
    			LogHelper.error("Wrong platform!");
    		}

	    	LogHelper.println("");
	    	LogHelper.println("\x1b[2m------");
	    	LogHelper.println("Mac Setup");
	    	LogHelper.println("------\x1b[0m");
	    	LogHelper.println("");

	    	downloadXCode();

	    	LogHelper.println("");

	    	downloadCommandLineTools();

	    	LogHelper.println("");
	    	LogHelper.println("\x1b[2m------");
	    	LogHelper.println("end");
	    	LogHelper.println("------\x1b[0m");

    	} catch(error : Dynamic)
    	{
    		LogHelper.error("An error occurred, do you need admin permissions to run the script? Check if you have permissions to write on the paths you specify. Error:" + error);
    	}
	    
	    return "success";
    }

    private function downloadXCode()
    {
    	LogHelper.println("Checking xcode installation...");

		var output : String = ProcessHelper.runProcess("", "xcode-select", ["-v"], true, true, true, false);

		if(output.indexOf("xcode-select version") == -1)
		{
			LogHelper.println("It seems xcode is not installed.");
			LogHelper.println("You must purchase Xcode from the Mac App Store or download using a paid");
			LogHelper.println("member account with Apple.");

			var answer = AskHelper.askYesOrNo("Do you want to visit the apple website to install it?");

			if(answer == Yes)
			{
				ProcessHelper.openURL(appleXcodeURL);
			}

			LogHelper.println("Rerun the script with xcode installed.");


			Sys.exit(0);
		}
		else
		{
			LogHelper.println("Installed!");
		}
    }

    private function downloadCommandLineTools()
    {
    	LogHelper.println("Checking xcode command line tools installation...");

		var output : String = ProcessHelper.runProcess("", "pkgutil", ["--pkg-info=com.apple.pkg.CLTools_Executables"], true, true, true, false);

		if(output.indexOf("package-id:") == -1)
		{
			LogHelper.println("It seems the xcode command line tools are not installed.");

			var answer = AskHelper.askYesOrNo("Do you want to install them?");

			var output : String = ProcessHelper.runProcess("", "xcode-select", ["--install"], true, true, true, false);

			LogHelper.println("Rerun the script with the command line tools installed.");
		}
		else
		{
			LogHelper.println("Installed!");
		}
    }
}
