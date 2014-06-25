package ;

import haxe.io.Error;
import de.gameduell.cli.ConsoleReader;
import de.gameduell.cli.ConsoleReader;
import de.gameduell.cli.processor.CmdProcessor;
import sys.io.FileInput;
import neko.Lib;
import sys.FileSystem;

/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class GDCommadLine {
    public static var VERSION = "0.0.2";

    /** the source for commands **/
    private var console :ConsoleReader;


    /**start the interpreter **/
    public static function main()
    {
        var interpreter = new GDCommadLine();
        interpreter.run();
    }
    public function new()
    {
        console = new ConsoleReader();
    }

    /**
    *  get commands from the console, process them, display output
    *  handle GDConsole commands, get haxe statement (can be multiline), parse it, pass to execution method
    **/
    public function run()
    {
        var args = Sys.args();
        if (args.length > 0 && Sys.systemName() == "Windows") args.shift();
        Lib.println("Gameduell interactive shell v" + VERSION);
        Lib.println("type \"help\" for help");

        var processor = new CmdProcessor();

        while( true )
        {
        // initial prompt
            console.cmd.prompt = "GDShell:~>> ";
            Lib.print("GDShell:~>> ");

            while (true)
            {
                try
                {
                    var ret = processor.process(console.readLine());
                    if( ret != null )
                        Lib.println(ret+"\n");
                }
                catch (ex:CmdError)
                {
                    switch (ex)
                    {
                        case IncompleteStatement:
                            {
                                console.cmd.prompt = ".. "; // continue prompt
                                Lib.print(".. ");
                                continue;
                            }
                        case InvalidStatement(msg): Lib.println(msg);
                    }
                }

                // restart after an error or completed command
                console.cmd.prompt = "GDShell:~>> ";
                Lib.print("GDShell:~>> ");
            }
        }
    }}
