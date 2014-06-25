package de.gameduell.cli.processor;

import haxe.io.Error;
import sys.io.File;
import de.gameduell.cli.program.NekoEval;
import de.gameduell.cli.program.Program;
import haxe.ds.StringMap;
using Lambda;
using StringTools;
import sys.FileSystem;
import haxe.ds.StringMap;
import neko.Lib;
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
    /** name of new lib to include in build */
    private var cmdStr :String;

    /** accumulating command fragments */
    private var sb :StringBuf = new StringBuf();

    /** connecting command to a specific function */
    private var commands : StringMap<Dynamic>;
    /** runs haxe compiler and neko vm */
    private var nekoEval :NekoEval;

    /** controls temp program text */
    private var program :Program;

    public function new()
    {
        commands = new StringMap<Void->String>();

        commands.set("hello", sayHello);
        commands.set("help", printHelp);
        commands.set("install", installLibs);
        commands.set("exit", function() std.Sys.exit(0));
        commands.set("quit", function() std.Sys.exit(0));

    }
    /**
    * process a line of user input
    **/
    public function process(cmd :String) :String
    {
        if( cmd.endsWith("\\") )
        {
            sb.add(cmd.substr(0, cmd.length-1));
            throw IncompleteStatement;
        }

        sb.add(cmd);
        var ret = new StringBuf();
        try
        {
            cmdStr = sb.toString();
            var cmd = firstWord(cmdStr);
            if( commands.exists(cmd) )                      // handle GDConsole commands
                ret = commands.get(cmd)();
            else                                            // execute a haxe statement
            {
                program.addStatement(cmdStr);
                ret = nekoEval.evaluate(program.getProgram());
                program.acceptLastCmd(true);
            }
        }
        catch (ex :String)
        {
            program.acceptLastCmd(false);
            sb = new StringBuf();
            throw InvalidStatement(ex);
        }

        sb = new StringBuf();
        return (ret==null) ? null : Std.string(ret);
    }

    private function firstWord(str :String) :String
    {
        var space = str.indexOf(" ");
        if( space == -1 )
            return str;
        return str.substr(0, space);
    }

    /**
       return a list of all user defined variables
    **/
    private function listVars() :String
    {
        var vars = program.getVars();
        if( vars.isEmpty() )
            return "vars: (none)";
        return wordWrap("vars: "+ vars.join(", "));
    }
    private function wordWrap(str :String) :String
    {
        if( str.length<=80 )
            return str;

        var words :Array<String> = str.split(" ");
        var sb = new StringBuf();
        var ii = 0; // index of current word
        var oo = 1; // index of current output line
        while( ii<words.length )
        {
            while( ii<words.length && sb.toString().length+words[ii].length+1<80*oo )
            {
                if( ii!=0 )
                    sb.add(" ");
                sb.add(words[ii]);
                ii++;
            }
            if( ii<words.length )
            {
                sb.add("\n    ");
                oo++;
            }
        }

        return sb.toString();
    }
    public function sayHello():String
    {
        return "hello there";
    }

    public function installLibs():String
    {
        var fileName = cmdStr.split(" ")[1];
        if( fileName==null || fileName.length==0 )
            return "syntax error you should specifiy the file name example c:/developer/config.json";

        return doInstallLibs(fileName);
    }

    public function doInstallLibs( fileName:String ) :String
    {
        if( !FileSystem.exists(fileName) )
            return "file with path '"+fileName +"' not found";
        var content:String;

        try
        {
            content = File.getContent(fileName);
        }
        catch(e:Error)
        {
            content = "Cannot Parse the file";
        }

        return content;
    }
    // print the help
    public static function printHelp() :String
    {
        return "Help:\n"
        + "  hello                    Just Saying Hello\n"
        + "  exit                     exit the console \n"
        + "  quit                     quit the shell   \n"
        + "  install [filename]       install libs based on the sepcified filename \n";
    }
}
