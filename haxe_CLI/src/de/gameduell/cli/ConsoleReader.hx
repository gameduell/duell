package de.gameduell.cli;

import neko.Lib;

typedef CodeSet = {
    var arrow     :Int;
    var up        :Int;
    var down      :Int;
    var right     :Int;
    var left      :Int;
    var home      :Int;
    var end       :Int;
    var backspace :Int;
    var ctrlc     :Int;
    var enter     :Int;
    var ctrla     :Int;
    var ctrle     :Int;
    var ctrlb     :Int;
    var ctrlf     :Int;
    var ctrld     :Int;
}
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */

/** read a command from the console.  handle arrow keys. **/

class ConsoleReader
{
    public var cmd(default,null) :PartialCommand;
    private var code :Int;
    private var history :History;
    private var codeSet :CodeSet;

    public static function main()
    {
        var cr = new ConsoleReader();
        var cmdStr = cr.readLine();
        Lib.println("\n" + cmdStr);
    }

    public function new()
    {
        code = 0;
        cmd = new PartialCommand();
        history = new History();
        if( std.Sys.systemName() == "Windows" )
            codeSet = {arrow: 224, up: 72, down: 80, right: 77, left: 75, home: 71, end: 79,
            backspace: 8, ctrlc: 3, enter: 13,
            ctrla: 1, ctrle: 5, ctrlb: 2, ctrlf: 6, ctrld: 83 };
        else
            codeSet = {arrow: 27, up: 65, down: 66, right: 67, left: 68, home: 72, end: 70,
            backspace: 127, ctrlc: 3, enter: 13,
            ctrla: 1, ctrle: 5, ctrlb: 2, ctrlf: 6, ctrld: 4 };
    }

    public function readLine()
    {
        cmd.set("");
        while( true )
        {
            code = Sys.getChar(false);
            if( code == codeSet.arrow ) // arrow keys
            {
                if( std.Sys.systemName() != "Windows" )
                    Sys.getChar(false); // burn extra char
                code = Sys.getChar(false);
                switch( code )
                {
                    case _ if(code == codeSet.up):    { clear(cmd); cmd.set(history.prev()); }
                    case _ if(code == codeSet.down):  { clear(cmd); cmd.set(history.next()); }
                    case _ if(code == codeSet.right): cmd.cursorForward();
                    case _ if(code == codeSet.left):  cmd.cursorBack();
                    case _ if(code == codeSet.home):  cmd.home();
                    case _ if (code == codeSet.end):   cmd.end();
                    case _ if (code == codeSet.ctrld && std.Sys.systemName() == "Windows"): cmd.del();
                }
            }
            else
            {
                switch( code )
                {
                    case _ if(code == codeSet.ctrlc):
                        if( cmd.toString().length > 0 )
                        {
                            clear(cmd); cmd.set("");
                        }
                        else
                        {
                            Lib.println("");
                            std.Sys.exit(1);
                        }
                    case _ if(code == codeSet.enter):
                        Lib.println("");
                        history.add(cmd.toString());
                        return cmd.toString();
                    case _ if(code == codeSet.ctrld): cmd.del(); // del shares code with tilde?
                    case _ if(code == codeSet.ctrla): cmd.home();
                    case _ if(code == codeSet.ctrle): cmd.end();
                    case _ if(code == codeSet.ctrlf): cmd.cursorForward();
                    case _ if(code == codeSet.ctrlb): cmd.cursorBack();
                    case _ if(code == codeSet.backspace): cmd.backspace();
                    case _ if( code>=32 && code<=126 ): cmd.addChar(String.fromCharCode(code));
                }
            }
            Lib.print(cmd.toConsole());
        }
        return "";
    }

    public function clear(len)
    {
        Lib.print(cmd.clearString());
    }
}
