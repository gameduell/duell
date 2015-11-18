package duell.commands;

import duell.commands.IGDCommand;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;
import duell.helpers.LogHelper;
import duell.helpers.DuellLibListHelper;
import duell.objects.Arguments;
import duell.defines.DuellDefines;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

class DependencyCommand implements IGDCommand
{
	public function new()
	{
	}

	public function execute():String
	{
		checkRequirements();
		
		if(Arguments.isSet("-library"))
		{
			parseLibrayDependencies();
		} 
		else if (Arguments.isSet("-project"))
		{
			parseProjectDependencies();
		}

		var duellConfig = DuellConfigHelper.getDuellConfigFileLocation();
		var dotPath = haxe.io.Path.join([haxe.io.Path.directory(duellConfig), 'lib', 'duell', 'bin', 'graphviz', 'dot']);

		CommandHelper.runCommand("", "chmod", ["+x", dotPath], {errorMessage: "setting permissions on the 'dot' executable."});
		
		var dotFolder = haxe.io.Path.directory(dotPath);
		var args = ["-Tpng", haxe.io.Path.join([dotFolder, "dotFile.dot"]), "-o", haxe.io.Path.join([dotFolder, "firstFile.png"])];
		CommandHelper.runCommand(dotFolder, "dot", args, {systemCommand: false, errorMessage: "running the simulator"});

		return "success";
	}

	private function createOuputFile()
	{

	}

	private function parseLibrayDependencies()
	{
		var libraryName : String = Arguments.get("-library");

		logAction("Checking dependencies for library '" + libraryName + "'");

		//check if library in correct version exist

		//check out library / update to correct version

		//check for 'duell_libraray.xml'

		//parse duelllib's => loop process
	}

	private function parseProjectDependencies()
	{
		logAction("Checking library dependencies for current project");
		
		var fileContent:String = File.getContent(DuellDefines.PROJECT_CONFIG_FILENAME);
		try
		{
			var fileXmlContent : Xml = Xml.parse(fileContent);
			var content : Fast = new Fast(fileXmlContent.firstElement());

			for (element in content.elements)
			{
				LogHelper.info("name: " + element.name);
				switch(element.name){
					case "duelllib":
						 LogHelper.info("found duelllib: " + element.x.toString());

					case "haxelib":
						 LogHelper.info("found haxelib: " + element.x.toString());
				}
			}

		}
		catch(error : Dynamic)
		{
			LogHelper.exitWithFormattedError("Error parsing proejct xml.");
		}
	}

	private function logAction(action : String)
	{
		var line : String = "";
		for ( i in 0...action.length )
		{
			line += "-";
		}

		LogHelper.info(" ");
        LogHelper.info("\x1b[2m" + line);
        LogHelper.info(action);
        LogHelper.info(line + "\x1b[0m");
        LogHelper.info(" ");
	}

	private function checkRequirements()
	{
		//check repolist
		logAction("Checking requirements");

        var duellConfig : DuellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
        if(duellConfig.repoListURLs.length == 0){
        	LogHelper.exitWithFormattedError("No repository urls defined!.");
        }

        //if '-library' is used, check valid library name
        if(Arguments.isSet("-library"))
        {
        	var libraryName = Arguments.get("-library");
        	if(libraryName == null)
        	{
        		LogHelper.exitWithFormattedError("You need to add valid library name, like '-library YOUR_LIBRARY_NAME'");
        	}
        	else
        	{
        		if(!validateLibraryName(libraryName))
        		{
        			LogHelper.exitWithFormattedError("Name '" + libraryName + "' couldn't be found in the configured repository lists.");
        		}
        	}
        }

        //if -project is used, check if its valid project folder / duell_project.xml is available
        if(Arguments.isSet("-project"))
        {
        	checkIfItIsAProjectFolder();
        }
	}

	private function validateLibraryName(name : String) : Bool
	{
		return DuellLibListHelper.libraryExists(name);
	}

	private function checkIfItIsAProjectFolder()
    {
        if (!FileSystem.exists(DuellDefines.PROJECT_CONFIG_FILENAME))
        {
        	LogHelper.exitWithFormattedError("It's not a valid project folder! " + DuellDefines.PROJECT_CONFIG_FILENAME + " is missing.");
        }
    }
}