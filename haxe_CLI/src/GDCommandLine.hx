package ;

import de.gameduell.cli.processor.CmdProcessor;
import neko.Lib;

/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class GDCommandLine {
    public static var VERSION = "0.0.2";


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
                Lib.println(ret+"\n");
        }
        catch (ex:CmdError)
        {
            Sys.print("Unknown Command");
        }
    }}
