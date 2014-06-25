
package de.gameduell.cli.program;
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class Var
{
    public var isNew :Bool;
    private var name :String;
    private var type :String;

    public function new(name, ?type)
    {
        this.name = name;
        this.type = type;
    }

    public function toString()
    {
        if( type != null )
            return "var " + name + " : " + type + ";";
        else
            return "var " + name + ";";
    }
}

