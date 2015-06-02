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

import duell.helpers.ConnectionHelper;
import duell.helpers.SchemaHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.CommandHelper;
import haxe.CallStack;
import Sys;

import duell.defines.DuellDefines;

import duell.objects.DuellLib;
import duell.objects.Haxelib;
import duell.objects.SemVer;
import duell.objects.DuellProcess;
import duell.objects.DuellConfigJSON;

import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.helpers.PathHelper;
import duell.helpers.DuellLibHelper;

import duell.versioning.GitVers;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

import haxe.io.Path;

import duell.commands.IGDCommand;

import duell.objects.Arguments;

using StringTools;

typedef LibList = { duellLibs: Array<DuellLib>, haxelibs: Array<Haxelib> }

enum VersionState
{
	Unparsed;
	ParsedVersionUnchanged;
	ParsedVersionChanged;
}

typedef DuellLibVersion = { name: String, gitVers: GitVers, versionRequested: String, /*helper var*/ versionState: VersionState};

typedef PluginVersion = { lib: DuellLib, gitVers: GitVers};

typedef ToolVersion = { name: String, version: String};

class UpdateCommand implements IGDCommand
{
	var finalLibList: LibList = { duellLibs : [], haxelibs : [] };
	var finalPluginList: Array<DuellLib> = [];
    var finalToolList: Array<ToolVersion> = [];

	var haxelibVersions: Map<String, Haxelib> = new Map();
	var duellLibVersions: Map<String, DuellLibVersion> = new Map();
	var pluginVersions: Map<String, PluginVersion> = new Map();

	var buildLib: DuellLib = null;
	var platformName: String;

	var duellToolGitVers: GitVers;
	var duellToolRequestedVersion: String = null;

	var isDifferentDuellToolVersion: Bool = false;

    public function new()
    {
    }

    public function execute() : String
    {
    	LogHelper.info("\n");
    	LogHelper.info("\x1b[2m------------");
    	LogHelper.info("Update Dependencies");
    	LogHelper.info("------------\x1b[0m");
    	LogHelper.info("\n");

    	determineAndValidateDependenciesAndDefines();

    	LogHelper.info("\x1b[2m------");

    	LogHelper.info("\n");
    	LogHelper.info("\x1b[2m-------------------------");
    	LogHelper.info("Resulting dependencies update and resolution");
    	LogHelper.info("--------------------------\x1b[0m");
    	LogHelper.info("\n");

    	printFinalResult();

		// schema validation requires internet connection
        if (duellFileHasDuellNamespace() && ConnectionHelper.isOnline())
        {
            LogHelper.info("\x1b[2m------");

            LogHelper.info("\n");
            LogHelper.info("\x1b[2m-------------------------");
            LogHelper.info("Validating XML schema");
            LogHelper.info("--------------------------\x1b[0m");
            LogHelper.info("\n");

			if (userFileHasDuellNamespace())
			{
				validateUserSchemaXml();
			}

            validateSchemaXml();

            LogHelper.info("Success!");
        }

    	saveUpdateExecution();

    	LogHelper.println("");
    	LogHelper.info("\x1b[2m------");
    	LogHelper.info("end");
    	LogHelper.info("------\x1b[0m");


		if (isDifferentDuellToolVersion)
		{
            	LogHelper.info("Rerunning the update because the duell tool version changed.");
				CommandHelper.runHaxelib(Sys.getCwd(), ["run", "duell_duell"].concat(Arguments.getRawArguments()), {});
		}

	    return "success";
    }

	private function determineAndValidateDependenciesAndDefines()
	{
		/// ADD HXCPP
        handleHaxelibParsed(Haxelib.getHaxelib("hxcpp", DuellDefines.DEFAULT_HXCPP_VERSION));

		duellToolGitVers = new GitVers(DuellLib.getDuellLib("duell").getPath());

    	LogHelper.info("\n");
		LogHelper.info("parsing");

		parseDuellUserFile();

		parseProjectFile();

		iterateDuellLibVersionsUntilEverythingIsParsedAndVersioned();

		checkVersionsOfPlugins();

		checkDuellToolVersion();

		checkHaxeVersion();

		createFinalLibLists();

        createSchemaXml();
	}

	private function parseDuellUserFile()
	{
		if (FileSystem.exists(DuellConfigHelper.getDuellUserFileLocation()))
		{
			LogHelper.info("     parsing user file");
			parseXML(DuellConfigHelper.getDuellUserFileLocation());
		}
	}

	private function parseProjectFile()
	{
		LogHelper.info("     parsing configuration file in current directory");

		var projectFile = Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]);
		var libFile = Path.join([Sys.getCwd(), DuellDefines.LIB_CONFIG_FILENAME]);

		if (FileSystem.exists(projectFile))
		{
			parseXML(projectFile);
		}
		else if (FileSystem.exists(libFile))
		{
			parseXML(libFile);
		}
	}

	private function iterateDuellLibVersionsUntilEverythingIsParsedAndVersioned()
	{
		while(true)
		{
			var foundSomethingNotParsed = false;
			var libClone = [for (l in duellLibVersions) l]; /// because the duellLibVersions will change
			for (duellLibVersion in libClone)
			{
				switch (duellLibVersion.versionState)
				{
					case VersionState.Unparsed:
					{
    					LogHelper.info("\n");
						LogHelper.info("checking version of " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
						duellLibVersion.versionState = VersionState.ParsedVersionUnchanged;

						foundSomethingNotParsed = true;

						var resolvedVersion = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested);

						if (duellLibVersion.gitVers.needsToChangeVersion(resolvedVersion))
						{
							LogHelper.info("  - changing to version " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
							duellLibVersion.gitVers.changeToVersion(resolvedVersion);
						}

						LogHelper.info("     parsing " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);
						parseDuellLibWithName(duellLibVersion.name);
					}

					case VersionState.ParsedVersionChanged:
					{
    					LogHelper.info("\n");
						LogHelper.info("rechecking version of " + LogHelper.BOLD + duellLibVersion.name + LogHelper.NORMAL);

						duellLibVersion.versionState = VersionState.ParsedVersionUnchanged;

						var resolvedVersion = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested);

						if (duellLibVersion.gitVers.needsToChangeVersion(resolvedVersion))
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

	}


	private function checkVersionsOfPlugins()
	{
		for (pluginVersion in pluginVersions)
		{
			LogHelper.info("\n");
			LogHelper.info("checking version of " + LogHelper.BOLD + pluginVersion.lib.name + LogHelper.NORMAL);
			var resolvedVersion = pluginVersion.gitVers.solveVersion(pluginVersion.lib.version);

			if (pluginVersion.gitVers.needsToChangeVersion(resolvedVersion))
			{
				LogHelper.info("  - changing to version " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
				pluginVersion.gitVers.changeToVersion(resolvedVersion);
			}
			else
			{
				LogHelper.info("  - using version " + LogHelper.BOLD + pluginVersion.gitVers.currentVersion + LogHelper.NORMAL);
			}
		}
	}

	private function checkDuellToolVersion()
	{
		if (duellToolRequestedVersion == null)
			return;

		LogHelper.info("\n");
		LogHelper.info("checking version of " + LogHelper.BOLD + "duell tool" + LogHelper.NORMAL);
		var resolvedVersion = duellToolGitVers.solveVersion(duellToolRequestedVersion);

		if (duellToolGitVers.needsToChangeVersion(resolvedVersion))
		{
			LogHelper.info("  - changing to version " + LogHelper.BOLD + resolvedVersion + LogHelper.NORMAL);
			var duellToolPreviousVersion = duellToolGitVers.currentVersion;
			duellToolGitVers.changeToVersion(resolvedVersion);
			var duellToolChangedToVersion = duellToolGitVers.currentVersion;

			if (duellToolPreviousVersion != duellToolChangedToVersion)
			{
				isDifferentDuellToolVersion = true;
			}

		}
		else
		{
			LogHelper.info("  - using version " + LogHelper.BOLD + duellToolGitVers.currentVersion + LogHelper.NORMAL);
		}

        finalToolList.push({name: "duell tool", version: duellToolGitVers.currentVersion});
	}

	private function checkHaxeVersion()
	{
		LogHelper.info("checking version of " + LogHelper.BOLD + "haxe" + LogHelper.NORMAL);

		var haxePath = Sys.getEnv("HAXEPATH");

		var options: ProcessOptions = {systemCommand: true,
												mute: true,
									 shutdownOnError: true,
									 	errorMessage: "Error retrieving haxe version",
									 		   block:true};

    	var duellProcess = new DuellProcess(Sys.getCwd(), Path.join([haxePath, "haxe"]), ["-version"], options);
    	var versionString = duellProcess.getCompleteStderr().toString().trim();

		var haxeVersion = SemVer.ofString(versionString);

		if (!SemVer.areCompatible(haxeVersion, SemVer.ofString(DuellDefines.HAXE_VERSION)))
		{
			throw "DuellTool Haxe Version " + DuellDefines.HAXE_VERSION + " and current version " + haxeVersion.toString() + " are not compatible. Please install a haxe version that is compatible.";
		}

        finalToolList.push({name: "haxe", version: versionString});
	}

	private function printFinalResult(): Void
	{
    	LogHelper.info(LogHelper.BOLD + "DuellLibs:" + LogHelper.NORMAL);
    	LogHelper.info("\n");

    	for (lib in finalLibList.duellLibs)
    	{
    		LogHelper.info("   " + lib.name + " - " + lib.version);
    	}

    	LogHelper.info("\n");
    	LogHelper.info(LogHelper.BOLD + "HaxeLibs:" + LogHelper.NORMAL);
    	LogHelper.info("\n");

    	for (lib in finalLibList.haxelibs)
    	{
    		LogHelper.info("   " + lib.name + " - " + lib.version);
    	}

    	if (finalPluginList.length > 0)
    	{
	    	LogHelper.info("\n");
	    	LogHelper.info(LogHelper.BOLD + "Build Plugins:" + LogHelper.NORMAL);
	    	LogHelper.info("\n");

	    	for (lib in finalPluginList)
	    	{
	    		LogHelper.info("   " + lib.name + " - " + lib.version);
	    	}
    	}

        if (finalToolList.length > 0)
        {
            LogHelper.info("\n");
            LogHelper.info(LogHelper.BOLD + "Tools:" + LogHelper.NORMAL);
            LogHelper.info("\n");

            for (tool in finalToolList)
            {
                LogHelper.info("   " + tool.name + " - " + tool.version);
            }
        }
	}

	private function createFinalLibLists()
	{
		for (duellLibVersion in duellLibVersions)
		{
			finalLibList.duellLibs.push(DuellLib.getDuellLib(duellLibVersion.name, duellLibVersion.gitVers.currentVersion));
		}

		finalLibList.haxelibs = [];
		for (haxelibVersion in haxelibVersions)
		{
			finalLibList.haxelibs.push(haxelibVersion);
		}

        for (plugin in pluginVersions.keys())
        {
            finalPluginList.push(DuellLib.getDuellLib(pluginVersions[plugin].lib.name,  pluginVersions[plugin].gitVers.currentVersion));
        }
	}

    private function createSchemaXml()
    {
        SchemaHelper.createSchemaXml([for (l in finalLibList.duellLibs) l.name], [for (p in finalPluginList) p.name]);
    }

    private function saveUpdateExecution()
	{
        var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
    	duellConfig.lastProjectFile = Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]);
    	duellConfig.lastProjectTime = Date.now().toString();
    	duellConfig.writeToConfig();
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

					var name = element.att.name;

					if (name == '')
					{
						continue;
					}

					var version = null;

					if (!element.has.version || element.att.version == "")
					{
						LogHelper.info("WARNING: Haxelib dependencies must always specify a version. This will become an error in future releases. File: " + path);
						version = "";
					}
					else
					{
						version = element.att.version;
					}

					var haxelib = Haxelib.getHaxelib(name, version);

					handleHaxelibParsed(haxelib);

					LogHelper.info("      depends on haxelib " + LogHelper.BOLD + haxelib.name + LogHelper.NORMAL + " " + haxelib.version);

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

				case 'supported-build-plugin':

					var name = null;
					var version = null;

					if (!element.has.version || element.att.version == "")
					{
						throw "Supported builds must always specify a version. File: " + path;
					}

					name = element.att.name;

					version = element.att.version;

			    	var buildLib = DuellLib.getDuellLib("duellbuild" + name, version);

					LogHelper.info("      supports build plugin " + LogHelper.BOLD + name + LogHelper.NORMAL + " " + version);

			    	if (DuellLibHelper.isInstalled(buildLib.name))
			    	{
			    		handlePluginParsed(buildLib);
			    	}
			    	else
			    	{
			    		var answer = AskHelper.askYesOrNo('A library for building $name is not currently installed. Would you like to try to install it?');

			    		if (answer)
			    		{
			    			DuellLibHelper.install(buildLib.name);
					    	handlePluginParsed(buildLib);
						}
						else
						{
							/// ignore the lib
						}
			    	}

				case 'supported-duell-tool':

					var version = null;

					version = element.att.version;

					LogHelper.info("      supports " + LogHelper.BOLD + "duell tool " + LogHelper.NORMAL + " " + version);

					if (duellToolRequestedVersion == null)
					{
						duellToolRequestedVersion = version;
					}
					else
					{
						if (version != duellToolRequestedVersion)
						{
							try {
								duellToolRequestedVersion = duellToolGitVers.resolveVersionConflict([version, duellToolRequestedVersion], Arguments.get("-overridebranch"));
							}
							catch (e: String)
							{
								neko.Lib.rethrow('Duell tool version conflict: ' + e);
							}
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

	private function handleDuellLibParsed(newDuellLib: DuellLib)
	{
		if (!DuellLibHelper.isInstalled(newDuellLib.name))
		{
			var answer = AskHelper.askYesOrNo('DuellLib ${newDuellLib.name} is missing, would you like to install it?');

			if (answer)
				DuellLibHelper.install(newDuellLib.name);
			else
				throw 'Cannot continue with an uninstalled lib.';
		}

		if (!DuellLibHelper.isPathValid(newDuellLib.name))
		{
			throw 'DuellLib ${newDuellLib.name} has an invalid path - ${DuellLibHelper.getPath(newDuellLib.name)} - check your "haxelib list"';
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

        var gitVers: GitVers = new GitVers(newDuellLib.getPath());
        var newVersion: String = gitVers.resolveVersionConflict([newDuellLib.version], Arguments.get("-overridebranch"));

		duellLibVersions[newDuellLib.name] = {name: newDuellLib.name, gitVers: gitVers, versionRequested: newVersion, versionState:VersionState.Unparsed};
    }

	private function handleHaxelibParsed(haxelib: Haxelib)
	{
		if (!haxelibVersions.exists(haxelib.name))
		{
			if (!haxelib.exists())
			{
				var haxelibMessagePart = haxelib.name + (haxelib.version != "" ? " with version " + haxelib.version : "");
				var answer = AskHelper.askYesOrNo('Haxelib $haxelibMessagePart is missing, would you like to install it?');

				if (answer)
					haxelib.install();
				else
					throw 'Cannot continue with an uninstalled lib.';
			}

			haxelib.selectVersion();
			haxelibVersions.set(haxelib.name, haxelib);
		}
		else
		{
			var existingHaxelib = haxelibVersions.get(haxelib.name);

			var solvedlib = Haxelib.solveConflict(existingHaxelib, haxelib);

			if(solvedlib == null) /// version doesn't need to be checked
			{
				throw 'Tried to compile with two incompatible versions ("$haxelib" and "$existingHaxelib") of the same library ${haxelib.name}';
			}

			if (solvedlib != existingHaxelib)
			{
				solvedlib.selectVersion(); /// just to make sure
			}

			haxelibVersions.set(haxelib.name, solvedlib);
		}

	}

	private function handlePluginParsed(buildLib: DuellLib)
	{
		if (!pluginVersions.exists(buildLib.name))
		{
			var gitvers = new GitVers(buildLib.getPath());
			pluginVersions.set(buildLib.name, {lib: buildLib, gitVers: gitvers});
		}
		else
		{
			var plugin = pluginVersions.get(buildLib.name);

			var prevVersion = plugin.lib.version;
			var newVersion = buildLib.version;

			if (prevVersion != newVersion)
			{
				try {
					var solvedVersion = plugin.gitVers.resolveVersionConflict([prevVersion, newVersion], Arguments.get("-overridebranch"));

					if (solvedVersion != prevVersion)
					{
						plugin.lib = DuellLib.getDuellLib(buildLib.name, solvedVersion);
					}
				}
				catch (e: String)
				{
					neko.Lib.rethrow('Plugin ${buildLib.name} version conflict: ' + e);
				}
			}
		}
	}

    private static function duellFileHasDuellNamespace(): Bool
    {
        var projectFile = Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]);
        var libFile = Path.join([Sys.getCwd(), DuellDefines.LIB_CONFIG_FILENAME]);

        if (FileSystem.exists(projectFile))
        {
            return SchemaHelper.hasDuellNamespace(projectFile);
        }
        else if (FileSystem.exists(libFile))
        {
            return SchemaHelper.hasDuellNamespace(libFile);
        }

        return false;
    }

	private static function userFileHasDuellNamespace(): Bool
	{
		var userFile: String = DuellConfigHelper.getDuellUserFileLocation();

		return FileSystem.exists(userFile) && SchemaHelper.hasDuellNamespace(userFile);
	}

    private static function validateSchemaXml(): Void
    {
        var projectFile = Path.join([Sys.getCwd(), DuellDefines.PROJECT_CONFIG_FILENAME]);
        var libFile = Path.join([Sys.getCwd(), DuellDefines.LIB_CONFIG_FILENAME]);

        if (FileSystem.exists(projectFile))
        {
            SchemaHelper.validate(projectFile);
        }
        else if (FileSystem.exists(libFile))
        {
            SchemaHelper.validate(libFile);
        }
    }

	private static function validateUserSchemaXml(): Void
	{
		SchemaHelper.validate(DuellConfigHelper.getDuellUserFileLocation());
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
