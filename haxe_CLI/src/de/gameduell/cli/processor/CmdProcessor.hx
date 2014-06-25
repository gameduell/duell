package de.gameduell.cli.processor;

import haxe.Json;
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
    /** Just dummy file to generate when ask for**/
    private var dummyJSON:Dynamic = Json.parse('{
                                                  "dev_libs":[
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"}
                                                  ]
                                              }
                                                ');


    public function new()
    {
        commands = new StringMap<Void->String>();

        commands.set("hello", sayHello);
        commands.set("help", printHelp);
        commands.set("install", installLibs);
        commands.set("dummy", createDuymmyFile);
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

    //================================================================================
    // command install [filename]
    //================================================================================
    public function installLibs():String
    {
        var fileName = cmdStr.split(" ")[1];

        if( fileName==null || fileName.length==0 )//file name specified
            return "syntax error you should specifiy the file name example c:/developer/config.json";

        if( !FileSystem.exists(fileName) )// File does not existe
            return "file with path '"+fileName +"' not found";

        return doInstallLibs(fileName);
    }

    public function doInstallLibs( fileName:String ) :String
    {
        var content:String;
        var startTime:Float = Date.now().getTime();
        var parsedContent : {version:String,dev_libs:Array<Dynamic>};
        try
        {
            Sys.println("Parsing config file Start....");
            content = File.getContent(fileName);
            parsedContent = Json.parse(content);
            Sys.println("Parsing config file Done ! took ["+( Date.now().getTime() - startTime)+" sec]");
        }
        catch(e:Error)
        {
            return "Cannot Parse the file";
        }

        if(parsedContent != null && parsedContent.version != GDCommadLine.VERSION)
        {
            return "the version in the file is different then the current Version of GDShell";
        }

        for (lib in parsedContent.dev_libs) {
            Sys.println(" Creating directory : ----------------"+ lib.destination);
            Sys.command("mkdir", [lib.destination]);
        }

        return "Installing done";
    }

    //================================================================================
    // command dummy [filename]
    //================================================================================
    public function createDuymmyFile():String
    {
        var fileName = cmdStr.split(" ")[1];

        if( fileName==null || fileName.length==0 )//check if the lazy ass didn't provide file name we set a default file name
            fileName =  "dummy_gdshell_"+GDCommadLine.VERSION+".json";

        dummyJSON.version = GDCommadLine.VERSION;
        File.saveContent(fileName,Json.stringify(dummyJSON));

        return "dummy JSON was created to path \""+fileName+"\" you lazy ass";
    }

    //================================================================================
    // command help
    //================================================================================
    public static function printHelp() :String
    {
        return "Help:\n"
        + "  hello                    Just Saying Hello\n"
        + "  exit                     exit the console \n"
        + "  quit                     quit the shell   \n"
        + "  install [filename]       install libs based on the sepcified filename \n"
        + "  dummy   [filename]       generqte dummy config file to filename destiination \n";
    }
}
