/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.commands;

import duell.helpers.DuellConfigHelper;
import duell.helpers.CommandHelper;
import haxe.CallStack;
import Sys;

import duell.defines.DuellDefines;

import duell.objects.DuellLib;
import duell.objects.Haxelib;

import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.helpers.PathHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellLibHelper;

import duell.versioning.GitVers;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

import haxe.io.Path;

import duell.commands.IGDCommand;

import duell.objects.Arguments;

import haxe.Serializer;
import haxe.Unserializer;

import duell.objects.DuellConfigJSON;


typedef DuellLibAndParsed = {lib: DuellLib, parsed: Bool}
typedef DuellLibList = Array<DuellLibAndParsed>

class BuildCommand implements IGDCommand
{
	var libList : DuellLibList = [];

	var buildLib : DuellLib = null;
	var buildGitVers: GitVers = null;
	var platformName : String;

	var duellConfig: DuellConfigJSON;

	static inline var HOURS_TO_REQUEST_UPDATE = 8;

    public function new()
    {
    }

    public function execute() : String
    {
    	try
    	{
	    	LogHelper.info("\n");
	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("Build");
	    	LogHelper.info("------\x1b[0m");
	    	LogHelper.info("\n");

	    	LogHelper.println("");

	    	checkIfItIsAProjectFolder();

	    	LogHelper.println("");

	    	checkUpdateTime();

	    	LogHelper.println("");

	    	determinePlatformToBuildFromArguments();

	    	LogHelper.println("");

	    	determineAndValidateDependenciesAndDefines();

	    	LogHelper.println("");

	    	buildNewExecutableWithBuildLibAndDependencies();

	    	LogHelper.println("");
	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("end");
	    	LogHelper.info("------\x1b[0m");
    	} 
    	catch(error : Dynamic)
    	{
    		LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.error(error);
    	}
	    
	    return "success";
    }

    private function checkIfItIsAProjectFolder()
    {
    	if (!FileSystem.exists(DuellDefines.PROJECT_CONFIG_FILENAME))
    	{
    		LogHelper.error('Running from a folder without a project file ${DuellDefines.PROJECT_CONFIG_FILENAME}');
    	}
    }

    private function determinePlatformToBuildFromArguments()
    {
    	platformName = Arguments.getSelectedPlugin();

    	var platformNameCorrectnessCheck = ~/^[a-z0-9]+$/;

    	if (!platformNameCorrectnessCheck.match(platformName))
    		LogHelper.error('Unknown platform $platformName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell build ios\" or \"duell build android\"');

    	buildLib = DuellLib.getDuellLib("duellbuild" + platformName);

    	if (!DuellLibHelper.isInstalled(buildLib.name))
        {
    		var answer = AskHelper.askYesOrNo('A library for building $platformName is not currently installed. Would you like to try to install it?');

    		if(answer)
    		{
    			DuellLibHelper.install(buildLib.name);
    			LogHelper.println('You should now run "duell update" to set the plugin to the correct version for your project');
    		}
    		else
    		{
	    		LogHelper.println('Rerun with the library "duellbuild$platformName" installed');
    		}
			
			Sys.exit(0);
    	}
    }

    private function checkUpdateTime()
    {
        duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
    	if (duellConfig.lastProjectFile != Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]))
    	{
    		suggestUpdate();
    		return;
    	}

    	var currentDate = Date.now();
    	var previousDate = Date.fromString(duellConfig.lastProjectTime);

    	var previousHours = previousDate.getTime() / 1000.0 / 60.0 / 60.0;
    	var currentHours = currentDate.getTime() / 1000.0 / 60.0 / 60.0;

    	if (previousHours + HOURS_TO_REQUEST_UPDATE < currentHours)
    	{
    		suggestUpdate();
    	}
    }

    private function suggestUpdate()
    {
    	var answer = AskHelper.askYesOrNo("You have not run an update for this project recently. Would like to do so?");

    	if (answer)
    	{
    		new duell.commands.UpdateCommand().execute();
    		Sys.exit(0);
    	}
    	else
    	{
    		duellConfig.lastProjectFile = Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]);
    		duellConfig.lastProjectTime = Date.now().toString();
    		duellConfig.writeToConfig();
    	}
    }

	private function determineAndValidateDependenciesAndDefines()
	{
		if (FileSystem.exists(DuellConfigHelper.getDuellUserFileLocation()))
		{
			parseXML(DuellConfigHelper.getDuellUserFileLocation());
		}

		parseXML(Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]));

		var filtered = libList.filter(function (l) return !l.parsed);
		
		for (lib in filtered)
		{
			lib.parsed = true;
			parseDuellLibWithName(lib.lib.name);
		}
	}

	private function buildNewExecutableWithBuildLibAndDependencies()
	{
		var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
		var outputRunArguments = haxe.io.Path.join(['$outputFolder', 'run_' + platformName + '.args']);
		var outputRun = haxe.io.Path.join(['$outputFolder', 'run_' + platformName + '.n']);

		var buildArguments = new Array<String>();

		buildArguments.push("-main");
		buildArguments.push("duell.build.main.BuildMain");

		buildArguments.push("-neko");
		buildArguments.push(outputRun);

		buildArguments.push("-cp");
		buildArguments.push(DuellLibHelper.getPath("duell"));

		buildArguments.push("-cp");
		buildArguments.push(DuellLibHelper.getPath(buildLib.name));

		for (l in libList)
		{
			buildArguments.push("-cp");
			buildArguments.push(DuellLibHelper.getPath(l.lib.name));

            if (FileSystem.exists(haxe.io.Path.join([DuellLibHelper.getPath(l.lib.name), "duell", "build", "plugin", "library", l.lib.name, "LibraryXMLParser.hx"])))
			{
				buildArguments.push("--macro");
				buildArguments.push('keep(\"duell.build.plugin.library.${l.lib.name}.LibraryXMLParser\")');
			}

            if (FileSystem.exists(haxe.io.Path.join([DuellLibHelper.getPath(l.lib.name), "duell", "build", "plugin", "library", l.lib.name, "LibraryBuild.hx"])))
            {
                buildArguments.push("--macro");
                buildArguments.push('keep(\"duell.build.plugin.library.${l.lib.name}.LibraryBuild\")');
            }
		}

		buildArguments.push("-D");
		buildArguments.push("platform_" + platformName);

		buildArguments.push("-D");
		buildArguments.push("plugin");

 		buildArguments.push("-resource");
 		buildArguments.push(Path.join([DuellLibHelper.getPath("duell"), Arguments.CONFIG_XML_FILE]) + "@generalArguments");

		PathHelper.mkdir(outputFolder);

		CommandHelper.runHaxe("", buildArguments, {errorMessage: "building the plugin"});

		var runArguments = [outputRun];
		runArguments = runArguments.concat(Arguments.getRawArguments());

		var serializer = new Serializer();
		serializer.serialize(runArguments);
		File.write(outputRunArguments, true).writeString(serializer.toString());

    	LogHelper.info("\n");
    	LogHelper.info("\x1b[2m--------------------");
    	LogHelper.info("Building " + platformName);
    	LogHelper.info("--------------------\x1b[0m");
    	LogHelper.info("\n");

		var result = CommandHelper.runNeko("", runArguments, {errorMessage: "running the plugin", exitOnError: false});
		if (result != 0)
			Sys.exit(result);
	}

	private function runFast(): Void
	{
    	platformName = Arguments.getSelectedPlugin();
		var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
		var outputRun = haxe.io.Path.join(['$outputFolder', 'run' + platformName + '.n']);
		var outputRunArguments = haxe.io.Path.join(['$outputFolder', 'run_' + platformName + '.args']);

		if (FileSystem.exists(outputRun))
		{
			LogHelper.error("Could not find a previous execution for this platform in order to run it fast.");
		}

		var s = File.read(outputRunArguments, true).readAll().toString();

		var runArguments: Array<String> = new Unserializer(s).unserialize();
		LogHelper.info("Running fast with arguments:");
		LogHelper.info(runArguments.join(" "));

		runArguments.push("-fast");

		var result = CommandHelper.runNeko("", runArguments, {errorMessage: "running the plugin", exitOnError: false});
		if (result != 0)
			Sys.exit(result);
	}

	/// -------
	/// HELPERS
	/// -------

	private function parseDuellLibWithName(name: String)
	{
		if (!FileSystem.exists(DuellLibHelper.getPath(name) + '/' + DuellDefines.LIB_CONFIG_FILENAME))
		{
			LogHelper.println('$name does not have a ${DuellDefines.LIB_CONFIG_FILENAME}');
		}
		else
		{
			var path = DuellLibHelper.getPath(name) + '/' + DuellDefines.LIB_CONFIG_FILENAME;

			parseXML(path);
		}
	}

	private var currentXMLPath : Array<String> = []; /// used to resolve paths. Is used by all XML parsers (library and platform)
	private function parseXML(path : String):Void
	{ 
		var xml = new Fast(Xml.parse(File.getContent(path)).firstElement());
		currentXMLPath.push(Path.directory(path));

		for (element in xml.elements) 
		{
			switch element.name
			{
				case 'duelllib':
					var name = null;
					var version = null;

					if (!element.has.version || element.att.version == "")
					{
						throw "DuellLib dependencies must always specify a version. File: " + path;
					}

					name = element.att.name;

					version = element.att.version;

					if (name == null || name == '')
					{
						continue;
					}
					var newDuellLib = DuellLib.getDuellLib(name, version);

					handleDuellLibParsed(newDuellLib);

				case 'include':
					if (element.has.path)
					{
						var includePath = resolvePath(element.att.path);

						parseXML(includePath);
					}

			}
		}

		currentXMLPath.pop();
	}

	private function handleDuellLibParsed(newDuellLib: DuellLib)
	{
		for (l in libList)
		{
			if(l.lib.name != newDuellLib.name)
				continue;

			return;
		}

		libList.push({lib: newDuellLib, parsed: false});
	}

	private function resolvePath(path : String) : String
	{
		path = PathHelper.unescape(path);
		
		if (PathHelper.isPathRooted(path))
			return path;

		path = Path.join([currentXMLPath[currentXMLPath.length - 1], path]);

		return path;
	}
}
