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

package duell.objects;

import duell.helpers.DuellLibListHelper;
import duell.helpers.DuellLibHelper;
import duell.helpers.LogHelper;

import duell.commands.IGDCommand;

import duell.Duell;

import haxe.io.Path;

import haxe.xml.Fast;

import sys.io.File;

class NoArgumentValue {}

@:generic
class ArgumentSpec <T>
{
	/// used as key in lookup dictionary
	public var name: String;

	public var documentation: String;

	/// to be filled by the argument checking
	public var set: Bool;
	public var value: T;

	public function new(name: String, documentation: String)
	{
		this.name = name;
		this.documentation = documentation;
		this.set = false;
		this.value = null;
	}
}

typedef AnyArgumentSpec = Dynamic;

class CommandSpec
{
	/// used as key in lookup dictionary
	public var name: String;

	public var hasPlugin: Bool;
	public var documentation: String;

	public var commandHandler: IGDCommand;

	public var arguments: Map<String, AnyArgumentSpec>;
	public var configurationDocumentation: Map<String, String>;

	public function new(name: String, hasPlugin: Bool, commandHandler: IGDCommand, documentation: String, arguments: Map<String, AnyArgumentSpec>, configuration: Map<String, String>)
	{
		this.name = name;
		this.hasPlugin = hasPlugin;
		this.documentation = documentation;
		this.commandHandler = commandHandler;
		this.arguments = arguments;
		this.configurationDocumentation = configuration;
	}
}

class Arguments
{
	public static inline var PLUGIN_XML_FILE = "plugin.xml";
	public static inline var CONFIG_XML_FILE = "config.xml";


	private static var generalArgumentSpecs: Map<String, AnyArgumentSpec> = new Map<String, AnyArgumentSpec>();
	private static var commandSpecs: Map<String, CommandSpec> = new Map<String, CommandSpec>();

	private static var selectedCommand: CommandSpec = null;
	private static var plugin: String = null;
	private static var pluginDocumentation: String = null;
	private static var pluginArgumentSpecs: Map<String, AnyArgumentSpec> = null;
	private static var pluginConfigurationDocumentation: Map<String, String> = null;
	private static var generalDocumentation: String = null;

	public static var defines(default, null): Map<String, String> = new Map<String, String>();

	private static var rawArgs: Array<String>;

	public static function validateArguments(): Bool
	{
		/// force compilation of at least these generics:
		var argSpecInt = new ArgumentSpec<Int>("something", "something else");
		var argSpecNoArgumentValue = new ArgumentSpec<NoArgumentValue>("something", "something else");
		var argSpecString = new ArgumentSpec<String>("something", "something else");
		/// ------------

		/// Parse general and command argument specs
		parseConfig();

		/// parse arguments
        var args = Sys.args();

        #if (!plugin)
        if(Sys.getEnv("HAXELIB_RUN") == "1")
        {
            Sys.setCwd(args.pop());
        }
        #end

        rawArgs = args.copy();

		if (args.length == 0 || args[0] == "-help")
		{
			printGeneralHelp();
			return false;
		}

		if (args[0].charAt(0) == "-")
		{
			Sys.println('The first argument needs to be either a command or "-help".');
			return false;
		}

		if (!commandSpecs.exists(args[0]))
		{
			Sys.println('The command ${args[0]} does not exist. Run "duell -help" for info on the possible commands.');
			return false;
		}

		selectedCommand = commandSpecs.get(args[0]);

		var index = 1;

		if (args.length > 1 && args[index] == "-help")
		{
			printCommandHelp();
			return false;
		}

		if (selectedCommand.hasPlugin)
		{
			if (args.length == 1 || args[index].charAt(0) == "-")
			{
				Sys.println('For the command "${selectedCommand.name}", a plugin name needs to be specified after. I.e. duell ${selectedCommand.name} <plugin_name>.');
				return false;
			}

			plugin = args[index];
			index = 2;

			/// check if plugin is installed and parse its arguments
            var duellLibName = "";

            if (selectedCommand.name == "run")
            {
                duellLibName = plugin;
            }
            else
            {
                duellLibName =  "duell" + selectedCommand.name + plugin;
            }

			if (DuellLibHelper.isInstalled(duellLibName))
			{
				var path = DuellLibHelper.getPath(duellLibName);
				path = Path.join([path, PLUGIN_XML_FILE]);
				if (sys.FileSystem.exists(path))
					parsePlugin(File.getContent(path));
			}
		}

		if (args[index] == "-help")
		{
			printPluginHelp();
			return false;
		}

		while (index < args.length)
		{
			var argString = args[index++];

			if (argString == "-D")
			{
				parseDefine(args[index++]);
				continue;
			}

			var argSpec = null;
			if (generalArgumentSpecs != null && generalArgumentSpecs.exists(argString))
			{
				argSpec = generalArgumentSpecs.get(argString);
			}
			else if (selectedCommand.arguments != null && selectedCommand.arguments.exists(argString))
			{
				argSpec = selectedCommand.arguments.get(argString);
			}
			else if (pluginArgumentSpecs != null && pluginArgumentSpecs.exists(argString))
			{
				argSpec = pluginArgumentSpecs.get(argString);
			}

			if (argSpec == null)
			{
                if (selectedCommand.name != "run")
                {
                    Sys.println('Unknown argument "$argString"');
                }
				return false;
			}
			else
			{
				argSpec.set = true;
				if (Type.getClass(argSpec) == Type.getClass(argSpecNoArgumentValue))
				{
				}
				else if (Type.getClass(argSpec) == Type.getClass(argSpecInt))
				{
					if (args.length == index)
					{
						Sys.println('Argument $argString expected an int, but got nothing');
						return false;
					}
					else
					{
						var argParam = args[index++];

						var argParamInt = Std.parseInt(argParam);

						if (argParamInt == null)
						{
							Sys.println('Argument $argString expected an int, but got $argParam');
							return false;
						}
						else
						{
							argSpec.value = argParamInt;
						}
					}
				}
				else if (Type.getClass(argSpec) == Type.getClass(argSpecString))
				{
					var argParam = args[index++];

					argSpec.value = argParam;
				}
				else
				{
					throw "Unsupported type for argument spec. Internal error.";
				}
			}
		}

		return true;
	}

	private static function parseDefine(str: String): Void
	{
		var array = str.split("=");
		if (array.length == 1)
		{
			defines.set(array[0], null);
		}
		else if (array.length > 2)
		{
			throw "Argument define " + str + " has incorrect structure, should be like -D SOMETHING or -D SOMETHING=2";
		}
		else
		{
			defines.set(array[0], array[1]);
		}

	}

	private static function parseConfig(): Void
	{
		var xml: Fast;
		xml = new Fast(Xml.parse(haxe.Resource.getString("generalArguments")).firstElement());



		for (element in xml.elements)
		{
			switch element.name
			{
				case 'arg':
					var argSpec = parseArgumentSpec(element);
					generalArgumentSpecs.set(argSpec.name, argSpec);

				case 'command':
					var commandSpec = parseCommandSpec(element);
					commandSpecs.set(commandSpec.name, commandSpec);

				case 'documentation':
					generalDocumentation = StringTools.htmlUnescape(element.innerData);
			}
		}
	}

	private static function parsePlugin(fileString: String): Void
	{
		var xml = new Fast(Xml.parse(fileString).firstElement());

		for (element in xml.elements)
		{
			switch element.name
			{
				case 'documentation':
					pluginDocumentation = StringTools.htmlUnescape(StringTools.trim(element.innerData));
				case 'arg':
					if (pluginArgumentSpecs == null)
					{
						pluginArgumentSpecs = new Map<String, AnyArgumentSpec>();
					}
					var argSpec = parseArgumentSpec(element);
					pluginArgumentSpecs.set(argSpec.name, argSpec);
				case 'configuration':
					var configurationElements = element.elements;
					for (configElem in configurationElements)
					{
						if (pluginConfigurationDocumentation == null)
							pluginConfigurationDocumentation = new Map<String, String>();
						var name = configElem.att.name;
						var documentation =  StringTools.htmlUnescape(StringTools.trim(configElem.innerData));
						pluginConfigurationDocumentation.set(name, documentation);
					}
			}
		}
	}

	private static function parseCommandSpec(command: Fast): CommandSpec
	{
		var name = command.att.name;
		var hasPlugin = command.att.hasPlugin == "true" ? true : false;

		var klassName = "duell.commands." + command.att.resolve("class");
		var klass = Type.resolveClass(klassName);
		var commandHandler = Type.createInstance(klass, []);
		var documentation = StringTools.htmlUnescape(StringTools.trim(command.node.documentation.innerData));

		var args = null;

		if (command.hasNode.args)
		{
			for (argXML in command.node.args.elements)
			{
				if (args == null)
					args = new Map<String, AnyArgumentSpec>();

				var argSpec = parseArgumentSpec(argXML);
				args.set(argSpec.name, argSpec);
			}
		}

		var configuration = null;

		if (command.hasNode.configuration)
		{
			for (argXML in command.node.configuration.elements)
			{
				if (configuration == null)
					configuration = new Map<String, String>();
				var name = argXML.att.name;
				var documentation =  StringTools.htmlUnescape(StringTools.trim(argXML.innerData));
				configuration.set(name, documentation);
			}
		}

		return new CommandSpec(name, hasPlugin, commandHandler, documentation, args, configuration);
	}

	private static function parseArgumentSpec(arg: Fast): AnyArgumentSpec
	{
		var name = arg.att.name;
		var documentation = StringTools.htmlUnescape(StringTools.trim(arg.node.documentation.innerData));
		var type = arg.att.type;

		switch (type)
		{
			case 'void':
				return new ArgumentSpec<NoArgumentValue>(name, documentation);
			case 'int':
				return new ArgumentSpec<Int>(name, documentation);
			case 'string':
				return new ArgumentSpec<String>(name, documentation);
			default:
				throw "Not yet supported argument type " + type;
		}
	}

	public static function isSet(argument: String): Bool
	{
		if (generalArgumentSpecs != null && generalArgumentSpecs.exists(argument))
			return generalArgumentSpecs.get(argument).set;

		if (selectedCommand != null && selectedCommand.arguments != null && selectedCommand.arguments.exists(argument))
			return selectedCommand.arguments.get(argument).set;

		if (pluginArgumentSpecs != null && pluginArgumentSpecs.exists(argument))
			return pluginArgumentSpecs.get(argument).set;

		throw "Unknown argument " + argument;
	}

	public static function get(argument: String): Dynamic
	{
		if (generalArgumentSpecs != null && generalArgumentSpecs.exists(argument))
			return generalArgumentSpecs.get(argument).value;

		if (selectedCommand != null && selectedCommand.arguments != null && selectedCommand.arguments.exists(argument))
			return selectedCommand.arguments.get(argument).value;

		if (pluginArgumentSpecs != null && pluginArgumentSpecs.exists(argument))
			return pluginArgumentSpecs.get(argument).value;

		throw "Unknown argument " + argument;
	}

    public static function isGeneralArgument(argument: String): Bool
    {
        if (generalArgumentSpecs != null && generalArgumentSpecs.exists(argument))
        {
            return generalArgumentSpecs.get(argument).set;
        }

        return false;
    }

	public static function isDefineSet(define: String)
	{
		return defines.exists(define);
	}

	public static function getDefine(define: String)
	{
		return defines.get(define);
	}

	public static function getSelectedCommand()
	{
		return selectedCommand;
	}

	public static function getSelectedPlugin()
	{
		return plugin;
	}

	public static function getRawArguments()
	{
		return rawArgs;
	}

	public static function printGeneralHelp()
	{
		LogHelper.info(" ");
		LogHelper.info(LogHelper.RED + "--------------------------------------------" + LogHelper.NORMAL);
		LogHelper.info('  Help for the ${LogHelper.BOLD}Duell Tool${LogHelper.NORMAL}, Version ${LogHelper.BOLD}${Duell.VERSION}${LogHelper.NORMAL}');
		LogHelper.info(LogHelper.RED + "--------------------------------------------" + LogHelper.NORMAL);

		LogHelper.info(" ");
		LogHelper.info(LogHelper.UNDERLINE + "Description:" + LogHelper.NORMAL);
		LogHelper.info(" ");
		LogHelper.info(generalDocumentation);
		LogHelper.info(" ");

		LogHelper.info(" ");
		LogHelper.info(LogHelper.UNDERLINE + "Commands:" + LogHelper.NORMAL);
		LogHelper.info(" ");
		for (command in commandSpecs)
		{
			LogHelper.info("  duell " + LogHelper.BOLD + command.name + " " + LogHelper.NORMAL);
		}


		if (generalArgumentSpecs != null)
		{
			LogHelper.info(" ");
			LogHelper.info(LogHelper.UNDERLINE + "Arguments:" + LogHelper.NORMAL);

			for (arg in generalArgumentSpecs)
			{
				printArgument(arg);
			}
		}

		LogHelper.info(LogHelper.UNDERLINE + "Additional Help:" + LogHelper.NORMAL);

		LogHelper.info(" ");
		LogHelper.info(' This message: ${LogHelper.BOLD}duell -help${LogHelper.NORMAL}');
		LogHelper.info('For a command: ${LogHelper.BOLD}duell <command> -help${LogHelper.NORMAL}');
		LogHelper.info(' For a plugin: ${LogHelper.BOLD}duell <command> <plugin> -help${LogHelper.NORMAL}');

		LogHelper.info(" ");
	}

	public static function printCommandHelp()
	{
		LogHelper.info(" ");
		LogHelper.info(LogHelper.RED + "-----------------------------" + LogHelper.NORMAL);
		LogHelper.info('  Help for the ${LogHelper.BOLD}${selectedCommand.name}${LogHelper.NORMAL} command');
		LogHelper.info(LogHelper.RED + "-----------------------------" + LogHelper.NORMAL);

		LogHelper.info(" ");
		LogHelper.info(LogHelper.UNDERLINE + "Description:" + LogHelper.NORMAL);
		LogHelper.info(" ");
		LogHelper.info(selectedCommand.documentation);


		if (selectedCommand.hasPlugin)
		{

			LogHelper.info(" ");
			LogHelper.info(LogHelper.UNDERLINE + "Plugins:" + LogHelper.NORMAL);
			LogHelper.info(" ");

			var libList = DuellLibListHelper.getDuellLibReferenceList();
			for (key in libList.keys())
			{
				if (StringTools.startsWith(key, "duell" + selectedCommand.name))
				{
					LogHelper.info("  duell " + selectedCommand.name + " " + LogHelper.BOLD + key.substr(("duell" + selectedCommand.name).length) + LogHelper.NORMAL);
				}
			}

			LogHelper.info(" ");
			LogHelper.info('For additional information on each plugin, run ${LogHelper.BOLD}duell ${selectedCommand.name} <plugin> -help ${LogHelper.NORMAL}');
			LogHelper.info(" ");
		}

		if (selectedCommand.arguments != null)
		{
			LogHelper.info(LogHelper.UNDERLINE + "Arguments:" + LogHelper.NORMAL);

			for (arg in selectedCommand.arguments)
			{
				printArgument(arg);
			}
		}

		LogHelper.info(" ");
		if (selectedCommand.configurationDocumentation != null)
		{
			LogHelper.info(LogHelper.UNDERLINE + "Project Configuration Documentation:" + LogHelper.NORMAL);

			for (doc in selectedCommand.configurationDocumentation.keys())
			{
				printDocumentationConfiguration(doc, selectedCommand.configurationDocumentation.get(doc));
			}
		}
	}

	public static function printPluginHelp()
	{
		LogHelper.info(" ");
		LogHelper.info(LogHelper.RED + "----------------------------------------------------------" + LogHelper.NORMAL);
		LogHelper.info('  Help for the ${LogHelper.BOLD}${plugin}${LogHelper.NORMAL} plugin in the ${LogHelper.BOLD}${selectedCommand.name}${LogHelper.NORMAL} command');
		LogHelper.info(LogHelper.RED + "----------------------------------------------------------" + LogHelper.NORMAL);

		LogHelper.info(" ");
		LogHelper.info(LogHelper.UNDERLINE + "Description:" + LogHelper.NORMAL);
		LogHelper.info(" ");
		LogHelper.info(pluginDocumentation);

		LogHelper.info(" ");
		if (pluginArgumentSpecs != null)
		{
			LogHelper.info(LogHelper.UNDERLINE + "Arguments:" + LogHelper.NORMAL);

			for (arg in pluginArgumentSpecs)
			{
				printArgument(arg);
			}
		}

		LogHelper.info(" ");
		if (pluginConfigurationDocumentation != null)
		{
			LogHelper.info(LogHelper.UNDERLINE + "Project Configuration Documentation:" + LogHelper.NORMAL);

			for (doc in pluginConfigurationDocumentation.keys())
			{
				printDocumentationConfiguration(doc, pluginConfigurationDocumentation.get(doc));
			}
		}
	}

	private static function printArgument(arg: AnyArgumentSpec)
	{
		LogHelper.info(" ");
		LogHelper.info(LogHelper.BOLD + "  " + arg.name + LogHelper.NORMAL);
		LogHelper.info(" ");
		LogHelper.info("  " + arg.documentation);
		LogHelper.info(" ");
	}

	private static function printDocumentationConfiguration(name: String, documentation: String)
	{
		LogHelper.info(" ");
		LogHelper.info(LogHelper.BOLD + "  <" + name + ">" + LogHelper.NORMAL);
		LogHelper.info(" ");
		LogHelper.info("  " + documentation);
		LogHelper.info(" ");
	}
}
