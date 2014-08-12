/**
 * @autor rcam
 * @date 04.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.objects;

import duell.defines.DuellDefines;

import duell.helpers.PathHelper;
import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.helpers.XMLHelper;

import duell.objects.DuellLib;
import duell.objects.Haxelib;

import duell.build.objects.Configuration;
import duell.build.plugin.platform.PlatformConfiguration;
import duell.build.plugin.platform.PlatformXMLParser;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;
import haxe.Template;

using StringTools;

class DuellProjectXML
{
	/// PARSING STATE
	private var currentXML : Fast = null;
	private var currentDuellLib : DuellLib = null; /// currently being parsed lib, null if parsing the project
	private var currentXMLPath : String = null; /// used to resolve paths. Is used by all XML parsers (library and platform)
	/// --------------

	private var parsingConditions : Array<String>; /// used in validating elements for "if" or "unless"


	private function new() : Void
	{
		parsingConditions = [];

		parsingConditions.concat(Configuration.getConfigParsingDefines());
		parsingConditions.concat(PlatformConfiguration.getConfigParsingDefines());
	}

	private static var cache : DuellProjectXML;
	public static function getConfig() : DuellProjectXML
	{
		if(cache == null)
		{
			cache = new DuellProjectXML();
			return cache;
		}

		return cache;
	}

	public function parse()
	{
		if (!FileSystem.exists(DuellDefines.PROJECT_CONFIG_FILENAME))
		{
			LogHelper.error('Project config file not found. There should be a ${DuellDefines.PROJECT_CONFIG_FILENAME} here');
		}

		var platformXML = DuellLib.getDuellLib("duellbuild" + PlatformConfiguration.getData().PLATFORM_NAME).getPath() + "/" + DuellDefines.PLATFORM_CONFIG_FILENAME;

		if (FileSystem.exists(platformXML))
		{
			parseFile(platformXML);
		}

		parseFile(DuellDefines.PROJECT_CONFIG_FILENAME);

		parseDuellLibs();
	}

	private function parseFile(file : String)
	{		
		var elements = file.split("/");
		elements.pop();
		currentXMLPath = resolvePath(elements.join("/"));

		var stringContent = File.getContent(file);

		var template = haxe.Template(stringContent);

		template.execute({}, {
			duelllib: function(_, s) return DuellLib.getDuellLib(s).getPath(),
			haxelib: function(_, s) return Haxelib.getHaxelib(s).getPath(),
			projectpath: function(_, s) return Sys.getCwd()
		});

		currentXML = new Fast(Xml.parse().firstElement());

		for (element in currentXML.elements) 
		{
			if (!XMLHelper.isValidElement(element, parsingConditions))
				continue;
			switch (element.name)
			{
				case 'app':
					parseAppElement(element);

				case 'output':
					parseOutputElement(element);

				case 'haxe-compile-arg':
					parseHaxeCompileArgElement(element);

				case 'platform-config':
					parsePlatformConfigSection(element);		

				case 'library-config':
					parseLibraryConfigSection(element);

				case 'haxelib':
					parseHaxelibElement(element);

				case 'duelllib':
					parseDuellLibElement(element);

				case 'ndll':
					parseNDLLElement(element);

				case 'include':
					parseIncludeElement(element);
			}
		}
	}

	private var libsAlreadyParsed = new Array<{name : String, version : String}>();
	private function parseDuellLibs()
	{
		/// BFS
		while (libsAlreadyParsed.length != Configuration.getData().DEPENDENCIES.DUELLLIBS.length) 
		{
			var duellLibsToParse = Configuration.getData().DEPENDENCIES.DUELLLIBS.copy();

			for (duellLibDef in duellLibsToParse)
			{
				if (libsAlreadyParsed.indexOf(duellLibDef) != -1)
					continue;

				libsAlreadyParsed.push(duellLibDef);

				var duellLib = DuellLib.getDuellLib(duellLibDef.name, duellLibDef.version);

				if (!duellLib.exists())
				{ 
					/// should never happen because the build command checks this before.
					continue;
				}

				var xmlPath = duellLib.getPath() + '/' + DuellDefines.LIB_CONFIG_FILENAME;

				if (!FileSystem.exists(xmlPath))
				{
					LogHelper.println('${duellLib.name} does not have a ${DuellDefines.LIB_CONFIG_FILENAME}');
				}
				else
				{
					currentDuellLib = duellLib;

					parseFile(xmlPath);
				}
			}
		}
	}

	/// ---------------
	/// SECTION PARSERS
	/// ---------------

	private function parseHaxelibElement(lib : Fast)
	{
		var name = null;
		var version = null;
		if(lib.has.name)
		{
			name = lib.att.name;
		}

		if(lib.has.version)
		{
			version = lib.att.version;
		}

		if (name != null && name != '')
		{
			var found = false;
			for (haxelibDef in Configuration.getData().DEPENDENCIES.HAXELIBS)
			{
				if (haxelibDef.name == name) /// only check the name, because validation was already done in the build command
				{
					found = true;
					break;
				}
			}

			if (!found)
			{
				Configuration.getData().DEPENDENCIES.HAXELIBS.push({name : name, version : version});
			}
		} 
	}

	private function parseDuellLibElement(lib : Fast)
	{	
		var name = null;
		var version = null;
		if(lib.has.name)
		{
			name = lib.att.name;
		}

		if(lib.has.version)
		{
			version = lib.att.version;
		}


		if (name != null && name != '')
		{
			var found = false;
			for (duellLibDef in Configuration.getData().DEPENDENCIES.DUELLLIBS)
			{
				if (duellLibDef.name == name) /// only check the name, because validation was already done in the build command
				{
					found = true;
					break;
				}
			}

			if (!found)
			{
				Configuration.getData().DEPENDENCIES.DUELLLIBS.push({name : name, version : version});
			}
		} 
	}

	private function parseAppElement(element : Fast)
	{
		if (element.has.title)
		{
			Configuration.getData().APP.TITLE = element.att.title;
		}

		if (element.has.resolve("package")) ///package is a keyword
		{
			Configuration.getData().APP.PACKAGE = element.att.resolve("package");
		}

		if (element.has.company)
		{
			Configuration.getData().APP.COMPANY = element.att.company;
		}

		if (element.has.version)
		{
			Configuration.getData().APP.VERSION = element.att.version;
		}
	}

	private function parseOutputElement(element : Fast)
	{
		if (element.has.path)
		{
			Configuration.getData().OUTPUT = element.att.path;
		}
	}

	private function parseHaxeCompileArgElement(element : Fast)
	{
		if (element.has.value)
		{
			Configuration.getData().HAXE_COMPILE_ARGS.push(element.att.value);
		}
	}

	private function parsePlatformConfigSection(platformSectionXML : Fast)
	{
		PlatformXMLParser.getConfig().parse(platformSectionXML);
	}

	private function parseLibraryConfigSection(element : Fast)
	{
		
	}

	private function parseNDLLElement(element : Fast)
	{
		var name : String = "";
		var buildFilePath : String = "project/Build.xml";
		var binPath = "bin";
		if (element.has.name)
		{
			name  = element.att.name;

			if (element.has.resolve("build-file-path"))
			{
				buildFilePath = element.att.resolve("build-file-path");
			}

			if (element.has.resolve("bin-path"))
			{
				binPath = element.att.resolve("bin-path");
			}	
		}
	}

	private function parseIncludeElement(element : Fast)
	{
		if (element.has.path)
		{
			var path = resolvePath(element.att.path);


		}
	}

	/// ---------------
	/// HELPERS
	/// ---------------

	public function resolvePath(path : String) : String
	{
		if (PathHelper.isPathRooted(path))
			return path;

		return currentXMLPath + "/" + path;
	}
}
