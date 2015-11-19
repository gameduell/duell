package duell.commands;

import duell.commands.IGDCommand;
import duell.objects.DuellConfigJSON;
import duell.objects.Arguments;
import duell.objects.dependencies.DependencyLibraryObject;
import duell.objects.dependencies.DependencyConfigFile;
import duell.objects.dependencies.DotFileContentCreator;
import duell.objects.DuellLib;
import duell.helpers.LogHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.DuellLibHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.defines.DuellDefines;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

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

	private function createOuputFile(rootNode : DependencyLibraryObject)
	{
		var creator = new DotFileContentCreator();
		rootNode.generateOuptutFile(creator);

		LogHelper.info("OUTPUT: " + creator.getContent());
	}

	private function parseLibrayDependencies()
	{
		var libraryName : String = Arguments.get("-library");

		logAction("Updating dependencies for library '" + libraryName + "'");

	}

	private function parseProjectDependencies()
	{
		logAction("Checking library dependencies for current project");
		var file = new DependencyConfigFile(Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME);
		var rootNode = new DependencyLibraryObject(file, file.get_applicationName());
		if(file.get_duellLibs().length > 0)
		{
			CommandHelper.runHaxelib(Sys.getCwd(), ["run", "duell_duell", "update", "-yestoall"]);	
		}
		else
		{
			LogHelper.info("No dependencies defined.");
			Sys.exit(0);
		}

		logAction("Parsing libraries..");
		
		parseLibraries(rootNode);

		createOuputFile(rootNode);
		
		logAction("DONE");

		LogHelper.info(rootNode.toString());
	}

	//TODO: avoid looping through libraries!! Have tmp container where library-name, version and parsed flag are stored
	private function parseLibraries(rootNode : DependencyLibraryObject)
	{
		var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
		var libs = rootNode.get_configFile().get_duellLibs();
		for (l in libs)
		{
			var libPath = Path.join([duellConfigJSON.localLibraryPath, l.name]);
			var libConfig = DuellDefines.LIB_CONFIG_FILENAME;
			var config = new DependencyConfigFile(libPath, libConfig);
			var subNode = new DependencyLibraryObject(config, l.name);
			rootNode.addDependency(subNode);

			parseLibraries(subNode);
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