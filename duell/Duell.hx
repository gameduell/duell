package duell;

import duell.processor.CmdProcessor;
import duell.helpers.LogHelper;
import duell.helpers.AskHelper;

import neko.Lib;

/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gameduell GmbH
 */
class Duell 
{
    public static var VERSION = "0.3.0";

    /** **/
    private var processor:CmdProcessor;


    /**start the interpreter **/
    public static function main()
    {
        var interpreter = new Duell();
        interpreter.run();
    }
    public function new()
    {
        processor = new CmdProcessor();
    }

    /**
    *  get commands from the console, process them, display output
    *  handle GDConsole commands, get haxe statement (can be multiline), parse it, pass to execution method
    **/
    public function run()
    {
        var command = parseArgumentsAndGetCommand();

        printBanner();

        try
        {
            var ret = processor.process(command);
            if( ret != null )
                LogHelper.println(ret+"\n");
        }
        catch (ex:CmdError)
        {
            LogHelper.error("Unknown Command");
        }
    }

    private function parseArgumentsAndGetCommand()
    {

        var args = Sys.args();

        if(args[0] == "haxelib")
        {
        }
        for(arg in Sys.args())
        {
            if(arg.charAt(0) == "-")
            {
                switch(arg)
                {
                    case("-verbose"):
                        LogHelper.verbose = true;
                    case("-nocolor"):
                        LogHelper.enableColor = false;
                    default:
                        LogHelper.println("unknown parameter " + arg);
                        break;
                }
            }
            else
            {
                return arg;
            }
        }

        return "help";

    }

    private function printBanner()
    {
        LogHelper.println("\x1b[33;1m                         ");         
        LogHelper.println("    ____   __  __ ______ __     __ ");   
        LogHelper.println("   / __ \\ / / / // ____// /    / / ");  
        LogHelper.println("  / / / // / / // __/  / /    / /  ");    
        LogHelper.println(" / /_/ // /_/ // /___ / /___ / /___");
        LogHelper.println("/_____/ \\____//_____//_____//_____/");
        LogHelper.println("                                   \x1b[0m");
        LogHelper.println("");
        LogHelper.println("\x1b[1mDuell tool \x1b[0m\x1b[3;37mDuell command line tool\x1b[0m\x1b[0m");
    }
}
