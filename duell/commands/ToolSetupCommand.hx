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

package duell.commands;

import duell.helpers.PlatformHelper;
import duell.helpers.AskHelper;
import duell.helpers.PathHelper;
import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.HXCPPConfigXMLHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.DuellLibHelper;

import duell.objects.HXCPPConfigXML;
import duell.objects.Haxelib;
import duell.objects.DuellConfigJSON;
import duell.objects.DuellProcess;

import haxe.CallStack;
import sys.io.File;
import sys.FileSystem;

import duell.commands.IGDCommand;

class ToolSetupCommand implements IGDCommand
{
	private static var haxeURL = "http://haxe.org/";
    private static var defaultRepoListURL:String = "git@github.com:gameduell/duell-repository-list.git";

    public function new()
    {

    }

    public function execute() : String
    {
    	LogHelper.info("");
    	LogHelper.info("\x1b[2m------");
    	LogHelper.info("Base Setup");
    	LogHelper.info("------\x1b[0m");
    	LogHelper.info("");

    	setupHaxe();

    	LogHelper.println("");

    	setupHaxelib();

    	LogHelper.println("");

    	setupDuellSettingsDirectory();

    	LogHelper.println("");

    	installDuell();

    	LogHelper.println("");

    	setupHXCPP();

    	LogHelper.println("");

    	writeHXCPPDefinitions();

    	LogHelper.println("");

    	savingSetupDone();

    	LogHelper.println("");

    	installCommandLine();

    	LogHelper.info("\x1b[2m------");
    	LogHelper.info("end");
    	LogHelper.info("------\x1b[0m");

	    return "success";
    }

	private function setupHaxe()
	{
    	LogHelper.println("Checking haxe installation... ");

    	/// we test with haxelib because haxe returns null for some reason.
    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var output : String = new DuellProcess(haxePath, "haxelib", [], {block: true, systemCommand: systemCommand, mute:true, errorMessage: "checking haxe installation"}).getCompleteStdout().toString();
		if(output.indexOf("Haxe Library Manager") == -1)
		{
			LogHelper.println("not found.");
			LogHelper.println("It seems haxe is not installed or not accessible in the command line.");

			var answer = AskHelper.askYesOrNo("Do you want to visit the haxe website to install it?");

			if(answer)
			{
				CommandHelper.openURL(haxeURL);
			}

			LogHelper.println("Rerun the script with haxe installed.");

			Sys.exit(0);
		}
		else
		{
    		LogHelper.println("Installed!");
		}
	}

	private function setupHaxelib()
	{
		LogHelper.println("Checking haxelib setup... ");

    	/// we test with haxelib because haxe returns null for some reason.
    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var output : String = new DuellProcess(haxePath, "haxelib", ["config"], {block: true, systemCommand: systemCommand, mute:true, errorMessage: "checking haxelib setup"}).getCompleteStdout().toString();

		if(output == null || output.indexOf("This is the first time") != -1)
		{
			var repoPath = AskHelper.askString("It seems haxelib has not been setup. Where do you want the setup folder?", DuellConfigHelper.getDuellConfigFolderLocation() + "/haxelib");
			repoPath = PathHelper.unescape(repoPath);
			PathHelper.mkdir(repoPath);

			repoPath = FileSystem.fullPath(repoPath);

			CommandHelper.runHaxelib("", ["setup", repoPath], {errorMessage: "setting up haxelib. Rerun the script with 'haxelib setup' executed successfully."});
		}
		else
		{
    		LogHelper.println("Installed!");
		}
	}

	private function setupDuellSettingsDirectory()
	{
    	LogHelper.println("Checking duell settings... ");

		if (!DuellConfigHelper.checkIfDuellConfigExists())
		{
			LogHelper.println("Duell config folder not found.");
			LogHelper.println("Creating it in " + DuellConfigHelper.getDuellConfigFolderLocation());
			PathHelper.mkdir(DuellConfigHelper.getDuellConfigFolderLocation());
		}

		if (!FileSystem.exists(DuellConfigHelper.getDuellConfigFileLocation()))
		{
			var fileContent : String = "{}";

			var output = File.write(DuellConfigHelper.getDuellConfigFileLocation(), false);
			output.writeString(fileContent);
			output.close();
		}

		if (!FileSystem.exists(DuellConfigHelper.getDuellUserFileLocation()))
		{
			var fileContent: String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<user xmlns=\"duell\">\n</user>\n";

			var output = File.write(DuellConfigHelper.getDuellUserFileLocation(), false);
			output.writeString(fileContent);
			output.close();
		}

		var repoPath = AskHelper.askString("Path to store repos from libraries?", DuellConfigHelper.getDuellConfigFolderLocation() + "/lib");

		var repoListURL = AskHelper.askString("URL to repo list?", defaultRepoListURL);

		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

		duellConfig.localLibraryPath = PathHelper.unescape(repoPath);
		PathHelper.mkdir(duellConfig.localLibraryPath);

		duellConfig.localLibraryPath = FileSystem.fullPath(duellConfig.localLibraryPath);

		if(duellConfig.repoListURLs.indexOf(repoListURL) == -1)
		{
			if(duellConfig.repoListURLs.length > 0)
			{
				LogHelper.println("There are already a repo list urls configured (" + duellConfig.repoListURLs.join(",") + ")");
				var answer = AskHelper.askYesOrNo("Do you want to add the new url (answer yes), or override the current ones (answer no)?");
				if(!answer)
				{
					duellConfig.repoListURLs = [];
				}
			}

			duellConfig.repoListURLs.push(repoListURL);
		}

		duellConfig.writeToConfig();

		LogHelper.println("You can review this in " + DuellConfigHelper.getDuellConfigFileLocation());
	}

	private function installDuell()
	{
		///install command into the settings dir, etc
		LogHelper.println("Installing the duell command in haxelib...");

		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
		LogHelper.println("Will install the duell tool from " + duellConfig.repoListURLs.join(", "));

		var libMap = DuellLibListHelper.getDuellLibReferenceList();

		if(!libMap.exists("duell"))
		{
			throw "Could not find \"duell\" in " + duellConfig.repoListURLs.join(", ");
		}

		libMap.get("duell").install();

		LogHelper.println("installed!");
	}

	private function installCommandLine()
	{
    	LogHelper.println("Checking duell command line installation... ");

		var haxePath = Sys.getEnv("HAXEPATH");

		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {

			if (haxePath == null || haxePath == "")
			{
				haxePath = "C:\\HaxeToolkit\\haxe\\";
			}

			File.copy(Haxelib.getHaxelib("duell_duell").getPath() + "\\bin\\duell.bat", haxePath + "\\duell.bat");
			File.copy(Haxelib.getHaxelib("duell_duell").getPath() + "\\bin\\duell.sh", haxePath + "\\duell");
		}
		else
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "/usr/lib/haxe";
			}

			var installedCommand = false;
			var answer = null;
			var destinationPath: String;

			answer = AskHelper.askYesOrNo("Do you want to install the \"duell\" command?");

			// El Capitan security measures
			if (PlatformHelper.hostPlatform == Platform.MAC && PlatformHelper.macVersion.minor >= 11)
			{
				destinationPath = "/usr/local/bin/duell";
			}
			else
			{
				destinationPath = "/usr/bin/duell";
			}

			if (answer)
			{
				CommandHelper.runCommand("", "sudo", ["cp", "-f", DuellLibHelper.getPath("duell") + "/bin/duell.sh", destinationPath], {errorMessage: "copying duell executable to the path"});
				CommandHelper.runCommand("", "sudo", ["chmod", "755", destinationPath], {errorMessage: "setting permissions on the duell executable"});
				installedCommand = true;
			}

			if (!installedCommand)
			{
				LogHelper.println("");
				LogHelper.println("To finish setup, we recommend you either...");
				LogHelper.println("");
				LogHelper.println(" a) Manually add an alias called \"duell\" to run \"haxelib run duell\"");
				LogHelper.println(" b) Run the following commands:");
				LogHelper.println("");
				LogHelper.println("sudo cp \"" + Haxelib.getHaxelib("duell_duell").getPath() + '/bin/duell.sh\" $destinationPath');
				LogHelper.println('sudo chmod 755 $destinationPath');
				LogHelper.println("");
			}
		}
	}

	private function setupHXCPP()
	{
    	LogHelper.println("Checking hxcpp installation... ");

    	var hxcppHaxelib = Haxelib.getHaxelib("hxcpp");

		if(!hxcppHaxelib.exists())
		{
			LogHelper.println("not found");
			LogHelper.println("Installing hxcpp...");
			CommandHelper.runHaxelib("", ["install", "hxcpp"], {errorMessage: "installing hxcpp"});

    		LogHelper.println("Rechecking hxcpp installation... ");

			if(hxcppHaxelib.exists())
			{
				LogHelper.println("Installed!");
			}
			else
			{
				throw "Still not installed, unknown error occurred...";
			}
		}
		else
		{
			LogHelper.println("Installed!");
		}


		LogHelper.println("Running once to make sure it is initialized...");
		CommandHelper.runHaxelib("", ["run", "hxcpp"], {errorMessage: "double checking if hxcpp was installed correctly."});
		LogHelper.println("Finished running hxcpp.");
	}

	private function writeHXCPPDefinitions()
	{
		if (PlatformHelper.hostPlatform == Platform.MAC)
		{
	    	var hxcppConfigPath = HXCPPConfigXMLHelper.getProbableHXCPPConfigLocation();

	    	if(hxcppConfigPath == null)
	    	{
				throw "Could not find the home folder, no HOME variable is set. Can't find hxcpp_config.xml";
	    	}

			var hxcppXML = HXCPPConfigXML.getConfig(hxcppConfigPath);


			var existingDefines : Map<String, String> = hxcppXML.getDefines();

			var newDefines = new Map<String, String>();
			newDefines.set("MAC_USE_CURRENT_SDK", "1");

			LogHelper.println("\x1b[1mWriting new definitions to hxcpp config file:\x1b[0m");

			for(def in newDefines.keys())
			{
				LogHelper.println("\x1b[1m" + def + "\x1b[0m:" + newDefines.get(def));
			}

			for(def in existingDefines.keys())
			{
				if(!newDefines.exists(def))
				{
					newDefines.set(def, existingDefines.get(def));
				}
			}

			hxcppXML.writeDefines(newDefines);
		}
	}

	public function savingSetupDone()
	{
    	LogHelper.println("Saving Setup Done Marker... ");
		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

		if (duellConfig.setupsCompleted.indexOf("self") == -1)
		{
			duellConfig.setupsCompleted.push("self");
			duellConfig.writeToConfig();
		}
	}
}
