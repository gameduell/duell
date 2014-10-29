package duell.objects;

import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
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

	public function new(name: String, hasPlugin: Bool, commandHandler: IGDCommand, documentation: String, arguments: Map<String, AnyArgumentSpec>)
	{
		this.name = name;
		this.hasPlugin = hasPlugin;
		this.documentation = documentation;
		this.commandHandler = commandHandler;
		this.arguments = arguments;
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
			var duellLib = DuellLib.getDuellLib("duell" + selectedCommand.name + plugin);
			if (duellLib.isInstalled())
			{
				var path = duellLib.getPath();
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

			var argSpec = null;
			if (generalArgumentSpecs.exists(argString))
			{
				argSpec = generalArgumentSpecs.get(argString);
			}
			else if (selectedCommand.arguments.exists(argString))
			{
				argSpec = selectedCommand.arguments.get(argString);
			}
			else if (pluginArgumentSpecs.exists(argString))
			{
				argSpec = pluginArgumentSpecs.get(argString);
			}

			if (argSpec == null)
			{
				Sys.println('Unknown argument "$argString"');
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

		return new CommandSpec(name, hasPlugin, commandHandler, documentation, args);
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