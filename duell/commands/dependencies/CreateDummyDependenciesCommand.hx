/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */
package duell.commands.dependencies;

import sys.io.File;
import haxe.Json;

import duell.commands.IGDCommand;
class CreateDummyDependenciesCommand implements IGDCommand{

    /** Just dummy file to generate when ask for**/
    private var dummyJSON:Dynamic = Json.parse('{   
    "version":"0.3.0"
    ,"duell_libs": [
                    "types",
                    "graphics",
                    "opengl",
                    "platform"
                 ]
    ,"haxe_libs": [
                    "format",
                    "ash",
                    "polygonal-ds"
                    ]

}');

    public function new()
    {
    }

    public function execute(cmd : String, args : Array<String>):String
    {
        dummyJSON.version = Duell.VERSION;
        File.saveContent(duell.helpers.DuellLibListHelper.DEPENDENCY_LIST_FILENAME, Json.stringify(dummyJSON));

        return "dummy JSON was created to file \"" + duell.helpers.DuellLibListHelper.DEPENDENCY_LIST_FILENAME + "\"";
    }

}
