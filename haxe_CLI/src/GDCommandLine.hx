package ;

import de.gameduell.cli.processor.CmdProcessor;
import de.gameduell.cli.helpers.LogHelper;

import neko.Lib;

/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class GDCommandLine 
{
    public static var VERSION = "0.1.0";

    /** **/
    private var processor:CmdProcessor;


    /**start the interpreter **/
    public static function main()
    {
        var interpreter = new GDCommandLine();
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
        printBanner();

        var args = Sys.args();
        var cmd:String;

        // if the argument are empty we set it to help command by default
        if (args.length <= 0)
        {
            cmd = "help";
        }
        else
        {
            cmd = args[0];
        }
        try
        {
            var ret = processor.process(cmd);
            if( ret != null )
                LogHelper.println(ret+"\n");
        }
        catch (ex:CmdError)
        {
            LogHelper.error("Unknown Command");
        }
    }

    private function printBanner()
    {
        LogHelper.println("\x1b[33;1m __                          ");         
        LogHelper.println(" _____ ____  _____ _____ _____ __");   
        LogHelper.println("|   __|    \\|_   _|     |     |  |");   
        LogHelper.println("|  |  |  |  | | | |  |  |  |  |  |__");
        LogHelper.println("|_____|____/  |_| |_____|_____|_____|\x1b[0m");
        LogHelper.println("");
        LogHelper.println("\x1b[1mGDTool \x1b[0m\x1b[3;37mGameduell command line tool\x1b[0m\x1b[0m");
    }
}
