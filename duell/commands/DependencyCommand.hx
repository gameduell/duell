package duell.commands;

import duell.commands.IGDCommand;
import duell.objects.DuellConfigJSON;
import duell.objects.Arguments;
import duell.objects.dependencies.DependencyLibraryObject;
import duell.objects.dependencies.DependencyConfigFile;
import duell.objects.dependencies.DotFileContentCreator;
import duell.objects.dependencies.IFileContentCreator;
import duell.objects.DuellLib;
import duell.helpers.LogHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.DuellLibHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.PlatformHelper;
import duell.defines.DuellDefines;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

import haxe.xml.Fast;

class DependencyCommand implements IGDCommand
{
	private var libraryCache = new Map<String, Map<String, Bool>>();//new Map<LibraryName, Map<Version, parsed>>

	public function new()
	{
	}

	public function execute():String
	{
		checkRequirements();
		
		if (Arguments.isSet("-project"))
		{
			parseProjectDependencies();
		}

		return "success";
	}

	private function buildVisualization(creator : IFileContentCreator)
	{
		var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
		var executablePath = Path.join([duellConfigJSON.localLibraryPath, 'duell', 'bin', 'graphviz']);
		
		var executableFile = PlatformHelper.hostPlatform == Platform.WINDOWS ? 'dot.exe' : 'dot';

		var path = Path.join([executablePath, executableFile]);
		CommandHelper.runCommand("", "chmod", ["+x", path], {errorMessage: "setting permissions on the '" + executableFile + "' executable."});
		
		var targetFolder = Path.join([Sys.getCwd(), "dependencies"]);
		if(!FileSystem.exists(targetFolder))
		{
			FileSystem.createDirectory(targetFolder);
		}

		var dotFile = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp", creator.getFilename()]);
		var args = ["-Tpng", dotFile, "-o", Path.join([Sys.getCwd(), "dependencies", "visualization.png"])];
		CommandHelper.runCommand(executablePath, executableFile, args, {systemCommand: false, errorMessage: "running dot command"});

		FileSystem.deleteFile(dotFile);
	}

	private function openVisualization()
	{
		CommandHelper.runCommand("", "open", [Path.join([Sys.getCwd(), "dependencies", "visualization.png"])]);
	}

	private function createVisualizationConfigFile(rootNode : DependencyLibraryObject) : IFileContentCreator
	{
		var creator = new DotFileContentCreator();
		creator.parseDuellLibs(rootNode);
		creator.parseHaxeLibs(rootNode);

		var configFolder = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
		var outputFile = Path.join([configFolder, creator.getFilename()]);
		var fileOutput = File.write(outputFile, false);
		fileOutput.writeString(creator.getContent());
		fileOutput.close();

		return creator;
	}

	private function parseProjectDependencies()
	{
		logAction("Checking library dependencies for current project");
		var file = new DependencyConfigFile(Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME);
		var rootNode = new DependencyLibraryObject(file, file.applicationName);
		if(file.duellLibs.length > 0 || file.haxeLibs.length > 0)
		{
			CommandHelper.runHaxelib(Sys.getCwd(), ["run", "duell_duell", "update", "-yestoall"]);	
		}
		else
		{
			LogHelper.info("No dependencies defined.");
			Sys.exit(0);
		}

		logAction("Parsing libraries..");
		
		parseDuellLibraries(rootNode);

		var creator = createVisualizationConfigFile(rootNode);

		buildVisualization(creator);

		openVisualization();
		
		logAction("DONE");
	}

	private function parseDuellLibraries(rootNode : DependencyLibraryObject)
	{
		var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
		var libs = rootNode.configFile.duellLibs;
		for (l in libs)
		{
			var libPath = Path.join([duellConfigJSON.localLibraryPath, l.name]);
			var libConfig = DuellDefines.LIB_CONFIG_FILENAME;
			var config = new DependencyConfigFile(libPath, libConfig);
			var subNode = new DependencyLibraryObject(config, l.name, l.version);
			rootNode.addDependency(subNode);

			if(canBeProcessed(subNode.lib)){
				addParsingLib(subNode.lib);

				parseDuellLibraries(subNode);

				setParsedLib(subNode.lib);
			}
		}
	}

	private function canBeProcessed(lib : DuellLib) : Bool
	{
		if(libraryCache.exists(lib.name))
		{
			var versions = libraryCache.get(lib.name);

			return versions.exists(lib.version);
		}

		return true;
	}

	private function addParsingLib(lib : DuellLib)
	{
		if(!libraryCache.exists(lib.name))
		{
			libraryCache.set(lib.name, new Map<String, Bool>());
		}
		
		var versions = libraryCache.get(lib.name);
		versions.set(lib.version, false);
	}

	private function setParsedLib(lib : DuellLib)
	{
		var versions = libraryCache.get(lib.name);
		versions.set(lib.version, true);	
	}

	private function logAction(action : String)
	{
		LogHelper.wrapInfo(LogHelper.DARK_GREEN + action, null, LogHelper.DARK_GREEN);
	}

	private function checkRequirements()
	{
		logAction("Checking requirements");

		//if -project is used, check if its valid project folder / duell_project.xml is available
        if(Arguments.isSet("-project"))
        {
        	checkIfItIsAProjectFolder();
        }
        else 
        {
        	LogHelper.exitWithFormattedError("Use duell dependencies -help for valid commands.");
        }

		//check repolist
        var duellConfig : DuellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
        if(duellConfig.repoListURLs.length == 0){
        	LogHelper.exitWithFormattedError("No repository urls defined!.");
        }
	}

	private function checkIfItIsAProjectFolder()
    {
        if (!FileSystem.exists(DuellDefines.PROJECT_CONFIG_FILENAME))
        {
        	LogHelper.exitWithFormattedError("It's not a valid project folder! " + DuellDefines.PROJECT_CONFIG_FILENAME + " is missing.");
        }
    }
}