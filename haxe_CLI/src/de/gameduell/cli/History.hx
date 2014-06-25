package de.gameduell.cli;
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class History
{
    private var commands :Array<String>;
    private var pos :Int;

    public function new()
    {
        commands = [""];
        pos = 1;
    }

    public function add(cmd)
    {
        commands.push(cmd);
        pos = commands.length;
    }

    public function next()
    {
        pos += 1;
        return commands[pos % commands.length];
    }

    public function prev()
    {
        pos -= 1;
        if( pos < 0 )
            pos += commands.length;
        return commands[pos % commands.length];
    }
}
