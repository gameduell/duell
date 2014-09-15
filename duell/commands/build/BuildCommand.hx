/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.commands.build;

import duell.helpers.ProcessHelper;
import haxe.CallStack;
import Sys;

import duell.defines.DuellDefines;

import duell.objects.DuellLib;
import duell.objects.Haxelib;

import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.helpers.PathHelper;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

import haxe.io.Path;

import duell.commands.IGDCommand;


typedef LibList = { duellLibs: Array<DuellLib>, haxelibs: Array<Haxelib> }

class BuildCommand implements IGDCommand
{
	var libList : LibList = { duellLibs : new Array<DuellLib>(), haxelibs : new Array<Haxelib>() };
	var buildLib : DuellLib = null;
	var platformName : String;

	var arguments : Array<String>;

    public function new()
    {
    }

    public static var helpString : String = '   \x1b[1mbuild <platform>\x1b[0m\n' +
                                            '\n' +
                                            'To be run inside a project that has a duell_project.xml. \n' +
                                            'Will build the specified platform.\n';

    public function execute(cmd : String, args : Array<String>) : String
    {
    	arguments = args;

    	try
    	{
	    	LogHelper.info("");
	    	LogHelper.info("\x1b[2m------");
	    	LogHelper.info("Build");
	    	LogHelper.info("------\x1b[0m");
	    	LogHelper.info("");

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
    		LogHelper.error("An error occurred. Error: " + error);
    	}
	    
	    return "success";
    }

    private function determinePlatformToBuildFromArguments()
    {
    	if (arguments.length == 0)
    	{
    		LogHelper.error("Please specify a platform as a parameter. \"duell build <platform>\".");
    	}

    	platformName = arguments[0].toLowerCase();

    	var platformNameCorrectnessCheck = ~/^[a-z0-9]+$/;

    	if (!platformNameCorrectnessCheck.match(platformName))
    		LogHelper.error('Unknown platform $platformName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell build ios\" or \"duell build android\"');

    	buildLib = DuellLib.getDuellLib("duellbuild" + platformName);

    	if (buildLib.exists())
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

	private function determineAndValidateDependenciesAndDefines()
	{
		parseDependencies(DuellDefines.PROJECT_CONFIG_FILENAME);
	}

	private function buildNewExecutableWithBuildLibAndDependencies()
	{
		var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
		var outputRun = haxe.io.Path.join(['$outputFolder", "run.n']);

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

		PathHelper.mkdir(outputFolder);

		var result = duell.helpers.ProcessHelper.runCommand("", "haxe", buildArguments);

		if (result != 0)
			LogHelper.error("An error occured while compiling the build tool");

		var runArguments = [outputRun];
		runArguments = runArguments.concat(arguments);

		result = duell.helpers.ProcessHelper.runCommand("", "neko", runArguments);

		if (result != 0)
			LogHelper.error("An error occured while running the build tool");
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
			parseDependenciesOfDuelllib(duellLib);
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
								var answer = AskHelper.askYesOrNo('Haxelib ${haxelib.name} is missing, would you like to install it?');

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
						var duellLib = DuellLib.getDuellLib(name, version);

						if (libList.duellLibs.indexOf(duellLib) == -1)
						{
							for (duellLib in libList.duellLibs)
							{
								if(duellLib.name == name && duellLib.version != version) /// version doesn't need to be checked
								{
									LogHelper.error('Tried to compile with two versions ($version and ${duellLib.version}) of the same library $name');
								}
							}

							libList.duellLibs.push(duellLib);
						}
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
	public function parseDependenciesOfDuelllib(duellLib : DuellLib)
	{
		if (dependenciesAlreadyParsed.indexOf(duellLib) != -1)
			return;

		dependenciesAlreadyParsed.push(duellLib);

		if (duellLib.exists())
		{
            if (duellLib.updateNeeded() == true)
            {
                var libraryName:String = duellLib.name;
                var answer = AskHelper.askYesOrNo('The library of $libraryName is not up to date on the master branch. Would you like to try to update it?');

                if(answer)
                {
                    duellLib.update();
                }
            }
        }
        else
        {
			var answer = AskHelper.askYesOrNo('DuellLib ${duellLib.name} is missing, would you like to install it?');

			if (answer)
				duellLib.install();
			else
				LogHelper.error('Cannot continue with an uninstalled lib.');
		}

		if (!FileSystem.exists(duellLib.getPath() + '/' + DuellDefines.LIB_CONFIG_FILENAME))
		{
			LogHelper.println('${duellLib.name} does not have a ${DuellDefines.LIB_CONFIG_FILENAME}');
		}
		else
		{
			parseDependencies(duellLib.getPath() + '/' + DuellDefines.LIB_CONFIG_FILENAME);
		}
	}
}
