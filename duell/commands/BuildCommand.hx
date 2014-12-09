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

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

import haxe.io.Path;

import duell.commands.IGDCommand;

import duell.objects.Arguments;

import haxe.Serializer;
import haxe.Unserializer;

typedef LibList = { duellLibs: Array<DuellLib>, haxelibs: Array<Haxelib> }

class BuildCommand implements IGDCommand
{
	var libList : LibList = { duellLibs : new Array<DuellLib>(), haxelibs : new Array<Haxelib>() };
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

		    	LogHelper.info("\x1b[2m------");
				LogHelper.info("", "Dependencies:");
		    	LogHelper.info("------\x1b[0m");
				for (duellLib in libList.duellLibs)
				{
					LogHelper.info("", "\x1b[1m" + duellLib.name + "\x1b[0m - requested: " + duellLib.version + " - actual: " + duellLib.actualVersion);
				}
		    	LogHelper.info("\x1b[2m------\x1b[0m");

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
	    	if (buildLib.isInstalled())
	    	{
	            if (buildLib.updateNeeded() == true)
	            {
	                var answer = AskHelper.askYesOrNo('The library of $platformName is not up to date on the master branch. Would you like to try to update it?');

	                if(answer)
	                {
	                    buildLib.update();
	                }
	            }
	        }
	        else
	        {
	    		var answer = AskHelper.askYesOrNo('A library for building $platformName is not currently installed. Would you like to try to install it?');

	    		if(answer)
	    		{
	    			buildLib.install();
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
		parseDependencies(DuellDefines.PROJECT_CONFIG_FILENAME);
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
		buildArguments.push(DuellLib.getDuellLib("duell").getPath());

		buildArguments.push("-cp");
		buildArguments.push(buildLib.getPath());

		for (duellLib in libList.duellLibs)
		{
			buildArguments.push("-cp");
			buildArguments.push(duellLib.getPath());

            if (FileSystem.exists(haxe.io.Path.join([duellLib.getPath(), "duell", "build", "plugin", "library", duellLib.name, "LibraryXMLParser.hx"])))
			{
				buildArguments.push("--macro");
				buildArguments.push('keep(\"duell.build.plugin.library.${duellLib.name}.LibraryXMLParser\")');
			}

            if (FileSystem.exists(haxe.io.Path.join([duellLib.getPath(), "duell", "build", "plugin", "library", duellLib.name, "LibraryBuild.hx"])))
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
 		buildArguments.push(Path.join([DuellLib.getDuellLib("duell").getPath(), Arguments.CONFIG_XML_FILE]) + "@generalArguments");

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

		for (duellLib in libList.duellLibs)
		{
			checkIfInstalledAndParseDependenciesOfDuelllib(duellLib);
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

					/// quick check if it is exactly the same object
					if (libList.duellLibs.indexOf(newDuellLib) != -1)
					{
						continue;
					}

					var found = false;
					for (currentDuellLib in libList.duellLibs)
					{
						if(currentDuellLib.name != newDuellLib.name)
						{
							continue;
						}

						found = true;

						if (currentDuellLib.actualVersion != newDuellLib.actualVersion)
						{
							if (!Arguments.isSet("-ignoreversioning"))
							{
								if (!currentDuellLib.resolveConflict(newDuellLib))
								{
									LogHelper.error('Tried to compile with two incompatible versions "${newDuellLib.actualVersion}" and "${currentDuellLib.actualVersion}" of the same library $name');
								}

								LogHelper.info('Library $name had a version conflict with version "${newDuellLib.actualVersion}" and "${currentDuellLib.actualVersion}". Resolving to version "${currentDuellLib.actualVersion}".');
							}
							/// invalidate parsed cache
							dependenciesAlreadyParsed.remove(currentDuellLib);
						}
					}

					if (!found)
					{	
						libList.duellLibs.push(newDuellLib);
					}

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

	private function resolvePath(path : String) : String
	{
		path = PathHelper.unescape(path);
		
		if (PathHelper.isPathRooted(path))
			return path;

		return Path.join([currentXMLPath[currentXMLPath.length - 1], path]);
	}

	private var dependenciesAlreadyParsed = new Array<DuellLib>();
	public function checkIfInstalledAndParseDependenciesOfDuelllib(duellLib : DuellLib)
	{
		if (dependenciesAlreadyParsed.indexOf(duellLib) != -1)
			return;

		dependenciesAlreadyParsed.push(duellLib);

		/// CHECK VERSIONING
		if (!Arguments.isSet("-ignoreversioning"))
		{
			if (!duellLib.isInstalled())
			{
				var answer = AskHelper.askYesOrNo('DuellLib ${duellLib.name} is missing, would you like to install it?');

				if (answer)
					duellLib.install();
				else
					LogHelper.error('Cannot continue with an uninstalled lib.');
			}

			if (!duellLib.isPathValid())
			{
				LogHelper.error('DuellLib ${duellLib.name} has an invalid path - ${duellLib.getPath()} - check your "haxelib list"');
			}

			checkIfDuellLibIsOnCorrectBranch(duellLib);

			checkIfDuellLibIsOnCorrectCommit(duellLib);

	        if (duellLib.updateNeeded() == true)
	        {
	            var libraryName:String = duellLib.name;
	            var answer = AskHelper.askYesOrNo('The library of $libraryName is not up to date on the branch. Would you like to try to update it?');

	            if(answer)
	            {
	                duellLib.update();
	            }
	        }
		}
		/// END OF CHECK VERSIONING

		if (!FileSystem.exists(duellLib.getPath() + '/' + DuellDefines.LIB_CONFIG_FILENAME))
		{
			LogHelper.println('${duellLib.name} does not have a ${DuellDefines.LIB_CONFIG_FILENAME}');
		}
		else
		{
			parseDependencies(duellLib.getPath() + '/' + DuellDefines.LIB_CONFIG_FILENAME);
		}
	}

	private function checkIfDuellLibIsOnCorrectBranch(duellLib: DuellLib): Void
	{
		if (!duellLib.isRepoOnCorrectBranch())
		{
			if (!duellLib.isRepoWithoutLocalChanges())
			{
				LogHelper.error(
					'The library "${duellLib.name}"" is not on the correct version "${duellLib.actualVersion}", ' +
					'and it contains local changes or new files, so we can\'t shift automatically. ' +
					'Please check your repository and save the changes, or set the version to be the branch you are on.');
			}

			if (!duellLib.isPossibleToShiftToTheCorrectBranch())
			{
            	var answer = AskHelper.askYesOrNo('The library of ${duellLib.name} does not have the branch for version ${duellLib.actualVersion}. Would you like to try to update it?');

	            if(answer)
	            {
	                duellLib.update();

					if (!duellLib.isPossibleToShiftToTheCorrectBranch())
					{
						LogHelper.error('After the update, the version ${duellLib.actualVersion} could not be found.');
					}
	            }
	            else
	            {
					LogHelper.error('Cannot continue with an unupdated lib. If you do not want to update please for a specific branch with "-overridebranch <branch>".');
	            }
			}

			duellLib.shiftRepoToCorrectBranch();
		}
	}

	private function checkIfDuellLibIsOnCorrectCommit(duellLib: DuellLib): Void
	{
		if (!duellLib.isRepoOnCorrectCommit())
		{
			if (!duellLib.isRepoWithoutLocalChanges())
			{
				LogHelper.error(
					'The library "${duellLib.name}"" is not on the correct version "${duellLib.actualVersion}", ' +
					'and it contains local changes or new files, so we can\'t shift automatically. ' +
					'Please check your repository and save the changes, or set the version to be the branch you are on.');
			}

			if (!duellLib.isPossibleToShiftToTheCorrectCommit())
			{
            	var answer = AskHelper.askYesOrNo('The library of ${duellLib.name} does not have the version ${duellLib.actualVersion}. Would you like to try to update it?');

	            if(answer)
	            {
	                duellLib.update();

					if (!duellLib.isPossibleToShiftToTheCorrectCommit())
					{
						LogHelper.error('After the update, the version ${duellLib.actualVersion} could not be found.');
					}
	            }
	            else
	            {
					LogHelper.error('Cannot continue with an unupdated lib. If you do not want to update please for a specific branch with "-overridebranch <branch>".');
	            }
			}

			duellLib.shiftRepoToCorrectCommit();
		}
	}


}
