
package de.gameduell.cli.program;

using StringTools;
/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gamduell GmbH
 */
class Statement {
    public var isNew(default,default) :Bool;
    private var text :String;
    private var suppressOutput :Bool;

    public function new(text :String, ?forceSemi=false)
    {
        isNew = true;
        text = text.trim();
        if( forceSemi && !text.endsWith(";") )
            text += ";";
        this.suppressOutput = text.endsWith(";");
        this.text = text;
    }

    public function toString() {
        if( isNew && !suppressOutput )
            return 'Lib.println(IhxASTFormatter.format($text));';
        else
        {
            var addSemi = suppressOutput ? "" : ";";
            return text+addSemi;
        }
    }
}
