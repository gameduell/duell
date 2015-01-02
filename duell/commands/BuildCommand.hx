/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.commands;

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

typedef UnsolvedDuellLib = { name: String, possibleVersions: Array<String> };

class BuildCommand implements IGDCommand
{
	var libList : LibList = { duellLibs : new Array<DuellLib>(), haxelibs : new Array<Haxelib>() };
	var unsolvedDuellLibs: Map<String, Array<DuellLib> > = new Map<String, Array<DuellLib> >();
	var buildLib : DuellLib = null;
	var platformName : String;

    public function new()
    {
    }

    public function execute() : String
    {
    	try
    	{
	    	LogHelper.info("");
	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("Build");
	    	LogHelper.info("------\x1b[0m");
	    	LogHelper.info("");

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
		while (true)
		{
			parseDependencies(DuellDefines.PROJECT_CONFIG_FILENAME);

			if (!resolveVersions())
			{
				break;
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

	private var currentXMLPath : Array<String> = []; /// used to resolve paths. Is used by all XML parsers (library and platform)
	private function parseDependencies(path : String)
	{		
		parseXML(path);

		for (duellLibArray in unsolvedDuellLibs)
		{
			checkIfInstalledAndParseDependenciesOfLib(duellLibArray[0].name);
		}
	}

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

					addNewDuellLibToUnsolved(newDuellLib);

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

	private function addNewDuellLibToUnsolved(newDuellLib: DuellLib)
	{
		for (duellLibName in unsolvedDuellLibs.keys())
		{
			if(duellLibName != newDuellLib.name)
				continue;

			var unsolvedDuellLibList = unsolvedDuellLibs[duellLibName];

			/// quick check if it is exactly the same object
			if (unsolvedDuellLibList.indexOf(newDuellLib) != -1)
				return;

			unsolvedDuellLibList.push(newDuellLib);
			return;
		}

		unsolvedDuellLibs.set(newDuellLib.name, [newDuellLib]);
	}

	private function resolvePath(path : String) : String
	{
		path = PathHelper.unescape(path);
		
		if (PathHelper.isPathRooted(path))
			return path;

		return Path.join([currentXMLPath[currentXMLPath.length - 1], path]);
	}

	private var dependenciesAlreadyParsed = new Array<String>();
	public function checkIfInstalledAndParseDependenciesOfLib(duellLibName: String)
	{
		if (dependenciesAlreadyParsed.indexOf(duellLibName) != -1)
			return;

		dependenciesAlreadyParsed.push(duellLibName);

		/// CHECK VERSIONING
		if (!Arguments.isSet("-ignoreversioning"))
		{
			if (!DuellLibHelper.isInstalled(duellLibName))
			{
				var answer = AskHelper.askYesOrNo('DuellLib ${duellLibName} is missing, would you like to install it?');

				if (answer)
					DuellLibHelper.install(duellLibName);
				else
					LogHelper.error('Cannot continue with an uninstalled lib.');
			}

			if (!DuellLibHelper.isPathValid(duellLibName))
			{
				LogHelper.error('DuellLib ${duellLibName} has an invalid path - ${DuellLibHelper.getPath(duellLibName)} - check your "haxelib list"');
			}
		}
		/// END OF CHECK VERSIONING

		if (!FileSystem.exists(DuellLibHelper.getPath(duellLibName) + '/' + DuellDefines.LIB_CONFIG_FILENAME))
		{
			LogHelper.println('$duellLibName does not have a ${DuellDefines.LIB_CONFIG_FILENAME}');
		}
		else
		{
			parseDependencies(DuellLibHelper.getPath(duellLibName) + '/' + DuellDefines.LIB_CONFIG_FILENAME);
		}
	}

	/// returns true if something changed
	private function resolveVersions(): Bool
	{
		libList.duellLibs = [];
		var didSomething = false;
		for (duellLibArray in unsolvedDuellLibs)
		{
			var duellLibName = duellLibArray[0].name;

			if (Arguments.isSet("-ignoreversioning"))
			{
				didSomething = false;
				libList.duellLibs.push(DuellLib.getDuellLib(duellLibName, "ignored"));
			}
			else
			{
				var gitvers = new GitVers(DuellLibHelper.getPath(duellLibName));
				
				var versions = duellLibArray.map(function(d) return d.version);

				LogHelper.info("======= version for: " + LogHelper.BOLD + duellLibName + LogHelper.NORMAL);
				LogHelper.info("requested: " + versions.join(", "));

				var resolvedVersion = gitvers.solveVersioning(versions, Arguments.get("-overridebranch"));

				LogHelper.info("solved to: " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
				LogHelper.info("==============");

				libList.duellLibs.push(DuellLib.getDuellLib(duellLibName, resolvedVersion));

				var didSomething = didSomething || gitvers.changeToVersion(resolvedVersion);
			}


		}
		return didSomething;
	}
}
