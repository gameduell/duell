package duell.processor;

import duell.commands.IGDCommand;
import duell.commands.dependencies.CreateDummyDependenciesCommand;
import duell.commands.dependencies.InstallDependenciesCommand;
import duell.commands.setup.SetupAndroidCommand;
import duell.commands.setup.SetupFlashCommand;
import duell.commands.setup.BaseSetupCommand;
import duell.commands.setup.SetupMacCommand;
import duell.commands.setup.UpdateToolCommand;
import duell.helpers.LogHelper;

using Lambda;
using StringTools;
enum CmdError
{
    IncompleteStatement;
    InvalidStatement(msg :String);
}
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gameduell GmbH
 */
class CmdProcessor
{
    /** connecting command to a specific function */
    public static var commands : List<{ name : String, doc : String, command : IGDCommand }>;
    private var currentTime:Float;

    public function new()
    {
        commands = new List();

        addCommand("setup",             "   \x1b[1msetup\x1b[0m\n" +
                                        "\n" +
                                        "Basic setup for the environment. It checks/creates a folders .duell in your home folder. \n" +
                                        "Inside that folder a config file is created and the tool itself is downloaded, installed into haxelib and \"duell\" command placed into the path.\n", new BaseSetupCommand());

        addCommand("setup_android",     "   \x1b[1msetup_android\x1b[0m\n" +
                                        "\n" +
                                        "Setup the environment for android development. \n" +
                                        "Currently it asks for downloading the android sdk, ndk, ant and jdk(except mac). \n" +
                                        "The paths to the sdk's are then written to the hxcpp_config.xml file. \n" +
                                        "The hxcpp_config file by default is in ~/.hxcpp_config.xml.\n", new SetupAndroidCommand());

        addCommand("setup_flash",       "   \x1b[1msetup_flash\x1b[0m\n" +
                                        "\n" +
                                        "Setup the environment for flash development. \n" +
                                        "Currently it asks for downloading the air sdk. \n" +
                                        "The path to the sdk is written to the hxcpp_config.xml file. \n" +
                                        "The hxcpp_config file by default is in ~/.hxcpp_config.xml.\n", new SetupFlashCommand());

        addCommand("setup_mac",         "   \x1b[1msetup_mac\x1b[0m\n" +
                                        "\n" +
                                        "Setup the environment for development in mac. \n" +
                                        "Currently it checks for xcode and the command line tools, and helps installing them.\n" , new SetupMacCommand());

        addCommand("install_dependencies",   "   \x1b[1minstall_dependencies\x1b[0m\n" +
                                             "\n" +
                                             "To be run inside a project that has a duell_dependencies.json\n", new InstallDependenciesCommand());

        addCommand("dependencies_example"  ,    "   \x1b[1mdependencies_example\x1b[0m\n" +
                                                "\n" +
                                                "Generate dependencies project config file with the name $duell.helpers.DuellLibListHelper.DEPENDENCY_LIST_FILENAME in the current directory.\n", new CreateDummyDependenciesCommand());

        addCommand("update_tool",       "   \x1b[1mupdate_tool\x1b[0m\n" +
                                        "\n" +
                                        "Update the tool itself. \n", new UpdateToolCommand());
    }

    function addCommand( name, doc, command ) : Void
    {
        commands.add({ name : name, doc : doc, command : command });
    }

    /**
    * process a line of user input
    **/
    public function process(cmd : String, args : Array<String>) :String
    {
        var output:String;
        if( cmd.endsWith("\\") )
        {
            throw IncompleteStatement;
        }

        /** If the command is help **/
        if( cmd == "help" )
        {
            return printHelp();
        }

        /** Other commands **/
        for( c in commands )
        {
            if( c.name == cmd )
            {
                currentTime = Date.now().getTime();
                output = c.command.execute(cmd, args);
                LogHelper.println(" Time passed "+((Date.now().getTime()-currentTime)/1000)+" sec for command '"+cmd+"''");
                return output;
            }
        }
        return "Command " + cmd + " Not Found, try to type help for more info";
    }

    //================================================================================
    // command help
    //================================================================================
    public static function printHelp() :String
    {
        var ret : String = "GDShell "+ Duell.VERSION+" \n";

        ret += "\n--------------------------\n";
        ret += "\n\x1b[1mCommand explanation\x1b[0m\n";
        ret += "\n--------------------------\n";
        ret += "\nPlease run the tool with one of - " + commands.map(function(cmd) {return cmd.name;}).join(", ") + " or help to show this message.\n";
        ret += "\nAdditionally you can set common command parameters. Currently there are -verbose and -nocolor. Example: gdtool -verbose setup\n";

        for (c in commands)
        {
            ret += "\n--------------------------\n\n" + c.doc ;
        }
        ret += "\n--------------------------\n";
        return ret;
    }
}
