package de.gameduell.cli;
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
/**  put together a command string from keystrokes **/
class PartialCommand
{
    /** current command string **/
    private var str :String;

    /** cursor position **/
    private var pos :Int;

    /** prompt to show **/
    public var prompt(null,default) :String;

    public function new()
    {
        str = "";
        pos = 0;
        prompt = "";
    }

    /**
       add a character at the current position
    **/
    public function addChar(ch)
    {
        if( pos == str.length )
            str += ch;
        else
            str = str.substr(0, pos) + ch + str.substr(pos);
        cursorForward();
    }

    /**
       delete the character before the cursor
    **/
    public function backspace()
    {
        if( pos == 0 )
            return;
        str = str.substr(0, pos-1) + str.substr(pos);
        cursorBack();
    }

    /**
       delete the character under the cursor
    **/
    public function del()
    {
        if( pos == str.length )
            return;

        str = str.substr(0, pos) + str.substr(pos+1);
    }

    /**
       move the cursor foreward
    **/
    public function cursorForward()
    {
        pos += 1;
        pos = Std.int(Math.min(pos, str.length));
    }

    /**
       move the cursor back
    **/
    public function cursorBack()
    {
        pos -= 1;
        pos = Std.int(Math.max(pos, 0));
    }

    /**
       move the cursor to the front of the line
    **/
    public function home()
    {
        pos = 0;
    }

    /**
       move the cursor to the end of the line
    **/
    public function end()
    {
        pos = str.length;
    }

    /**
       set command to given string
    **/
    public function set(newStr)
    {
        str = newStr;
        pos = str.length;
    }

    /**
       get command
    **/
    public function toString()
    {
        return str;
    }

    /**
       get command to show on console.  draw twice to get the cursor in the right place.
    **/
    public function toConsole()
    {
        return "\r" + prompt + str + " " + "\r" + prompt + str.substr(0, pos);
    }

    /**
       get string to clear this command from the console
    **/
    public function clearString()
    {
        return "\r" + StringTools.rpad("", " ", str.length + prompt.length);
    }
}
