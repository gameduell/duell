package de.gameduell.cli.processor;

import de.gameduell.cli.commands.CreateDummyFileCommand;
import de.gameduell.cli.commands.InstallLibsCommand;
import de.gameduell.cli.commands.impl.IGDCommand;
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
 * @company Gamduell GmbH
 */
class CmdProcessor
{
    /** connecting command to a specific function */
    public static var commands : List<{ name : String, doc : String, command : IGDCommand }>;
    private var currentTime:Float;

    public function new()
    {
        commands = new List();
        addCommand("install","install [filename]       install libs based on the sepcified filename\n",new InstallLibsCommand());
        addCommand("dummy"  ,"dummy   [filename]       generate dummy config file to filename destiination\n",new CreateDummyFileCommand());
    }

    function addCommand( name, doc, command ) : Void
    {
        commands.add({ name : name, doc : doc, command : command });
    }

    /**
    * process a line of user input
    **/
    public function process(cmd :String) :String
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
                output = c.command.execute(cmd);
                Sys.println(" Time passed "+((Date.now().getTime()-currentTime)/1000)+" sec for command '"+cmd+"''");
                return output;
            }
        }
        return "Command "+cmd+" Not Found, try to type help for more info";
    }

    //================================================================================
    // command help
    //================================================================================
    public static function printHelp() :String
    {
        var ret:String="GDShell "+ GDCommandLine.VERSION+" \n";
        for( c in commands )
        {
            ret += c.doc ;
        }
        return ret;
    }
}
