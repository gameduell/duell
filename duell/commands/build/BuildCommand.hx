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

import duell.commands.IGDCommand;


typedef LibList = { duellLibs: Array<DuellLib>, haxelibs: Array<Haxelib> }

class BuildCommand implements IGDCommand
{
	var libList : LibList = { duellLibs : new Array<DuellLib>(), haxelibs : new Array<Haxelib>() };
	var buildLib : DuellLib = null;
	var defines : Map<String, String> = new Map<String, String>();

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

	    	determinePlatformToBuildForFromArguments(args);

	    	LogHelper.println("");

	    	determineProfileFromArguments(args);

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

    private function determinePlatformToBuildForFromArguments(args : Array<String>)
    {
    	if (args.length == 0)
    	{
    		LogHelper.error("Please specify a platform as a parameter. \"duell build <platform>\".");
    	}

    	var platformName = args[0].toLowerCase();

    	var platformNameCorrectnessCheck = ~/^[a-z0-9]+$/;

    	if (!platformNameCorrectnessCheck.match(platformName))
    		LogHelper.error('Unknown platform $platformName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell build ios\" or \"duell build android\"');

    	buildLib = DuellLib.getDuellLib("duellbuild" + platformName);

    	if (!buildLib.exists())
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

    private function determineProfileFromArguments(args : Array<String>)
    {
    	var profile = "release";
    	if (args.length >= 2)
    	{
	    	if (args[1] == "debug" || args[2] == "release")
	    	{
	    		profile = args[1];
	    	}
	    }

	    LogHelper.println("Building with profile " + profile);
	    defines[profile] = null;
    }

	private function determineAndValidateDependenciesAndDefines()
	{
		if (FileSystem.exists(buildLib.getPath() + "/" + DuellDefines.PLATFORM_CONFIG_FILENAME))
		{
			parseDependencies(buildLib.getPath() + "/" + DuellDefines.PLATFORM_CONFIG_FILENAME);
		}

		parseDependencies(DuellDefines.PROJECT_CONFIG_FILENAME);
	}

	private function buildNewExecutableWithBuildLibAndDependencies()
	{
		var outputFolder = ".build";

		var buildArguments = new Array<String>();

		buildArguments.push("-main");
		buildArguments.push("duell.build.main.BuildMain");

		buildArguments.push("-neko");
		buildArguments.push('$outputFolder/buildtool/run.n');


		buildArguments.push("-cp");
		buildArguments.push(DuellLib.getDuellLib("duell").getPath());

		buildArguments.push("-cp");
		buildArguments.push(buildLib.getPath());

		for (duellLib in libList.duellLibs)
		{
			buildArguments.push("-cp");
			buildArguments.push(duellLib.getPath());
		}

		PathHelper.mkdir('$outputFolder/buildtool');

		var result = duell.helpers.ProcessHelper.runCommand("", "haxe", buildArguments);

		if (result != 0)
			LogHelper.error("An error occured while compiling the build tool");

		var runArguments = ['$outputFolder/buildtool/run.n'];
		runArguments.concat(arguments);

		result = duell.helpers.ProcessHelper.runCommand("", "neko", runArguments);

		if (result != 0)
			LogHelper.error("An error occured while running the build tool");
	}

	/// -------
	/// HELPERS
	/// -------

	private function parseDependencies(path : String)
	{		
		var xml = new Fast(Xml.parse(File.getContent(path)).firstElement());

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
			}
		}

		for (duellLib in libList.duellLibs)
		{
			parseDependenciesOfDuelllib(duellLib);
		}
	}

	private var dependenciesAlreadyParsed = new Array<DuellLib>();
	public function parseDependenciesOfDuelllib(duellLib : DuellLib)
	{
		if (dependenciesAlreadyParsed.indexOf(duellLib) != -1)
			return;

		dependenciesAlreadyParsed.push(duellLib);

		if (!duellLib.exists())
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
