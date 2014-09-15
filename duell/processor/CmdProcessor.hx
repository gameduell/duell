package duell.processor;

import duell.commands.create.CreateCommand;
import duell.commands.setup.EnvironmentSetupCommand;
import duell.helpers.DuellLibListHelper;
import duell.helpers.DuellConfigHelper;

import duell.objects.DuellConfigJSON;
import duell.commands.IGDCommand;

import duell.commands.setup.ToolSetupCommand;

import duell.commands.setup.UpdateToolCommand;
import duell.commands.build.BuildCommand;
import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.objects.DuellLib;

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

        addCommand('build', BuildCommand.helpString, new BuildCommand());

        addCommand('create', CreateCommand.helpString, new CreateCommand());

        addCommand('setup', EnvironmentSetupCommand.helpString, new EnvironmentSetupCommand());

        addCommand('self_setup', ToolSetupCommand.helpString, new ToolSetupCommand());

        addCommand('self_update', UpdateToolCommand.helpString, new UpdateToolCommand());
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
        if( cmd.endsWith('\\') )
        {
            throw IncompleteStatement;
        }

        /** If the command is help **/
        if( cmd == 'help' )
        {
            return printHelp();
        }

        /** Check if the self_setup was done already **/

        var isMissingSelfSetup = false;
        if (cmd != 'self_setup')
        {
            if (!sys.FileSystem.exists(DuellConfigHelper.getDuellConfigFileLocation()))
            {
                isMissingSelfSetup = true;
            }
            else
            {
                var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

                if (duellConfig.setupsCompleted.indexOf("self") == -1)
                {
                    isMissingSelfSetup = true;
                }
            }
        }

        if (isMissingSelfSetup)
        {
            var doSetup = AskHelper.askYesOrNo('You are missing the initial setup. Do you want to do it? ("self_setup" command)');

            if (!doSetup)
            {
                return "";
            }
            else
            {
                cmd = "self_setup";
            }
        }

        /** Check if the tools needs to be updated **/

        var duell = DuellLib.getDuellLib("duell");
        if (duell.exists())
        {
            if (duell.updateNeeded() == true)
            {
                var answer = AskHelper.askYesOrNo('The library of the duell tool is not up to date on the master branch. Would you like to try to update it?');

                if(answer)
                {
                    duell.update();
                }
            }
        }

        /** Other commands **/
        for( c in commands )
        {
            if( c.name == cmd )
            {
                currentTime = Date.now().getTime();
                output = c.command.execute(cmd, args);
                LogHelper.println(' Time passed '+((Date.now().getTime()-currentTime)/1000)+' sec for command "$cmd"');
                return output;
            }
        }
        return 'Command ' + cmd + ' Not Found, try to type help for more info';
    }

    //================================================================================
    // command help
    //================================================================================
    public static function printHelp() :String
    {
        var ret : String = 'Version '+ Duell.VERSION +' \n';

        ret += '\n--------------------------\n';
        ret += '\n\x1b[1mCommand explanation\x1b[0m\n';
        ret += '\n--------------------------\n';
        ret += '\nPlease run the tool with one of (' + commands.map(function(cmd) {return cmd.name;}).join(', ') + ') or help to show this message.\n';
        ret += '\nAdditionally you can set common command parameters. Currently there are -verbose and -nocolor. Example: duell -verbose setup mac\n';

        for (c in commands)
        {
            ret += '\n--------------------------\n\n' + c.doc ;
        }
        ret += '\n--------------------------\n';
        return ret;
    }
}
