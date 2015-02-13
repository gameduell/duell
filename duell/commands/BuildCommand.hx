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

typedef LibList = { duellLibs: Array<DuellLib>, haxelibs: Array<Haxelib> }

enum VersionState
{
	Unparsed;
	ParsedVersionUnchanged;
	ParsedVersionChanged;
}

typedef DuellLibVersion = { name: String, gitVers: GitVers, versionRequested: String, /*helper var*/ versionState: VersionState}; 

class BuildCommand implements IGDCommand
{
	var libList : LibList = { duellLibs : new Array<DuellLib>(), haxelibs : new Array() };
	var duellLibVersions: Map<String, DuellLibVersion> = new Map();

	var buildLib : DuellLib = null;
	var platformName : String;

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

	    	if (Arguments.isSet("-fast"))
	    	{
	    		runFast();
	    	}
	    	else
	    	{
		    	LogHelper.println("");

		    	checkIfItIsAProjectFolder();

		    	LogHelper.println("");

		    	determinePlatformToBuildFromArguments();

		    	LogHelper.println("");

		    	determineAndValidateDependenciesAndDefines();

		    	LogHelper.println("");

		    	buildNewExecutableWithBuildLibAndDependencies();
	    	}

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

    	if (!Arguments.isSet("-ignoreversioning"))
    	{
	    	if (DuellLibHelper.isInstalled(buildLib.name))
	    	{
	            if (DuellLibHelper.updateNeeded(buildLib.name) == true)
	            {
	                var answer = AskHelper.askYesOrNo('The library of $platformName is not up to date on the master branch. Would you like to try to update it?');

	                if(answer)
	                {
	                    DuellLibHelper.update(buildLib.name);
	                }
	            }
	        }
	        else
	        {
	    		var answer = AskHelper.askYesOrNo('A library for building $platformName is not currently installed. Would you like to try to install it?');

	    		if(answer)
	    		{
	    			DuellLibHelper.install(buildLib.name);
	    		}
	    		else
	    		{
		    		LogHelper.println('Rerun with the library "duellbuild$platformName" installed');
					Sys.exit(0);
	    		}
	    	}
    	}
    }

	private function determineAndValidateDependenciesAndDefines()
	{

    	LogHelper.info("\n");
    	LogHelper.info("\x1b[2m------------");
    	LogHelper.info("Dependencies");
    	LogHelper.info("------------\x1b[0m");
    	LogHelper.info("\n");

    	LogHelper.info("\n");
		LogHelper.info("checking project");

		if (FileSystem.exists(DuellConfigHelper.getDuellUserFileLocation()))
		{
			LogHelper.info("     parsing user file");
			parseXML(DuellConfigHelper.getDuellUserFileLocation());
		}

		LogHelper.info("     parsing project file");
		parseXML(Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]));

		while(true)
		{
			var foundSomethingNotParsed = false;
			var clone = [for (l in duellLibVersions) l]; /// because the duellLibVersions will change
			for (duellLibVersion in clone)
			{
				switch (duellLibVersion.versionState)
				{
					case VersionState.Unparsed: 
					{
    					LogHelper.info("\n");
						LogHelper.info("checking version of " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
						duellLibVersion.versionState = VersionState.ParsedVersionUnchanged;

						foundSomethingNotParsed = true;

				    	if (!Arguments.isSet("-ignoreversioning"))
				    	{
							var resolvedVersion = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested);

							if (duellLibVersion.gitVers.currentVersion != resolvedVersion)
							{
								LogHelper.info("  - changing to version " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
								duellLibVersion.gitVers.changeToVersion(resolvedVersion);
							}
						}

						LogHelper.info("     parsing " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
						parseDuellLibWithName(duellLibVersion.name);
					}

					case VersionState.ParsedVersionChanged: 
					{
    					LogHelper.info("\n");
						LogHelper.info("rechecking version of " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
				    	if (Arguments.isSet("-ignoreversioning"))
				    	{
				    		throw "should never happen, internal error";
				    	}

						duellLibVersion.versionState = VersionState.ParsedVersionUnchanged;

						var resolvedVersion = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested);

						if (duellLibVersion.gitVers.currentVersion != resolvedVersion)
						{
							LogHelper.info("  - changing to version " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
							if (duellLibVersion.gitVers.changeToVersion(resolvedVersion)) /// only reparse if something changed
							{
								foundSomethingNotParsed = true;
								LogHelper.info("     reparsing: " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
								parseDuellLibWithName(duellLibVersion.name);
							}
						}

					}
					case VersionState.ParsedVersionUnchanged:
						///nothing happens
				}
			}
			if (!foundSomethingNotParsed)
			{
				break;
			}
		}

		for (duellLibVersion in duellLibVersions)
		{
	    	if (!Arguments.isSet("-ignoreversioning"))
	    	{
				libList.duellLibs.push(DuellLib.getDuellLib(duellLibVersion.name, duellLibVersion.gitVers.currentVersion));
			}
			else
			{
				libList.duellLibs.push(DuellLib.getDuellLib(duellLibVersion.name, "ignored"));
			}
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

		for (duellLib in libList.duellLibs)
		{
			buildArguments.push("-cp");
			buildArguments.push(DuellLibHelper.getPath(duellLib.name));

            if (FileSystem.exists(haxe.io.Path.join([DuellLibHelper.getPath(duellLib.name), "duell", "build", "plugin", "library", duellLib.name, "LibraryXMLParser.hx"])))
			{
				buildArguments.push("--macro");
				buildArguments.push('keep(\"duell.build.plugin.library.${duellLib.name}.LibraryXMLParser\")');
			}

            if (FileSystem.exists(haxe.io.Path.join([DuellLibHelper.getPath(duellLib.name), "duell", "build", "plugin", "library", duellLib.name, "LibraryBuild.hx"])))
            {
                buildArguments.push("--macro");
                buildArguments.push('keep(\"duell.build.plugin.library.${duellLib.name}.LibraryBuild\")');
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
				case 'haxelib':
					var name = null;
					var version = null;
					if(element.has.name)
					{
						name = element.att.name;
					}

					if(element.has.version)
					{
						version = element.att.version;
					}

					if (name != null && name != '')
					{
						var haxelib = Haxelib.getHaxelib(name, version);

						if (libList.haxelibs.indexOf(haxelib) == -1)
						{
							if (!haxelib.exists())
							{	

								var haxelibMessagePart = haxelib.name + (haxelib.version != "" ? " with version " + haxelib.version : "");
								var answer = AskHelper.askYesOrNo('Haxelib $haxelibMessagePart is missing, would you like to install it?');

								if (answer)
									haxelib.install();
								else
									LogHelper.error('Cannot continue with an uninstalled lib.');
							}

							for (haxelib in libList.haxelibs)
							{
								if(haxelib.name == name && haxelib.version != version) /// version doesn't need to be checked
								{
									LogHelper.error('Tried to compile with two versions ($version and ${haxelib.version}) of the same library $name');
								}
							}

							libList.haxelibs.push(haxelib);
						}
					} 

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

					LogHelper.info("      depends on " + LogHelper.BOLD + newDuellLib.name + LogHelper.NORMAL + " " + newDuellLib.version);

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
		if (Arguments.isSet("-ignoreversioning"))
		{
			for (duellLibName in duellLibVersions.keys())
			{
				if(duellLibName != newDuellLib.name)
					continue;

				return;
			}

			duellLibVersions.set(newDuellLib.name, {name: newDuellLib.name, gitVers: null, versionRequested: "ignored", versionState:VersionState.Unparsed});
		}
		else
		{
			if (!DuellLibHelper.isInstalled(newDuellLib.name))
			{
				var answer = AskHelper.askYesOrNo('DuellLib ${newDuellLib.name} is missing, would you like to install it?');

				if (answer)
					DuellLibHelper.install(newDuellLib.name);
				else
					LogHelper.error('Cannot continue with an uninstalled lib.');
			}

			if (!DuellLibHelper.isPathValid(newDuellLib.name))
			{
				LogHelper.error('DuellLib ${newDuellLib.name} has an invalid path - ${DuellLibHelper.getPath(newDuellLib.name)} - check your "haxelib list"');
			}

			for (duellLibName in duellLibVersions.keys())
			{
				if(duellLibName != newDuellLib.name)
					continue;

				var duellLibVersion = duellLibVersions[newDuellLib.name];

				var prevVersion = duellLibVersion.versionRequested;

				if (prevVersion == newDuellLib.version)
					return;

				var newVersion = duellLibVersion.gitVers.resolveVersionConflict([duellLibVersion.versionRequested, newDuellLib.version], Arguments.get("-overridebranch"));

				if (prevVersion != newVersion)
				{
					switch(duellLibVersion.versionState)
					{
						case (VersionState.ParsedVersionUnchanged):
							duellLibVersion.versionState = VersionState.ParsedVersionChanged;
						default:
							/// if its not parsed or if the version is already changed, nothing happens
					}
					duellLibVersion.versionRequested = newVersion;
				}

				return;
			}

			duellLibVersions[newDuellLib.name] = {name: newDuellLib.name, gitVers: new GitVers(newDuellLib.getPath()), versionRequested: newDuellLib.version, versionState:VersionState.Unparsed};
		}

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
