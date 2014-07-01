package de.gameduell.cli.commands;
/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gamduell GmbH
 */
import sys.io.File;
import haxe.Json;
import de.gameduell.cli.commands.impl.IGDCommand;
class CreateDummyFileCommand implements IGDCommand{

    /** Just dummy file to generate when ask for**/
    private var dummyJSON:Dynamic = Json.parse('{
                                                  "dev_libs":[
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"},
                                                      {"name" : "lib_name","git_path" : "","description":"", "destination":"lib_name"}
                                                             ]
                                               }');

    public function new()
    {
    }

    public function execute( cmd:String ):String
    {
        var fileName = null;
        if(Sys.args().length > 1)
        {
            fileName =  Sys.args()[1];
        }

        if( fileName==null || fileName.length==0 )//check if the lazy ass didn't provide file name we set a default file name
            fileName =  "dummy_gdshell_"+GDCommadLine.VERSION+".json";

        dummyJSON.version = GDCommadLine.VERSION;
        File.saveContent(fileName,Json.stringify(dummyJSON));

        return "dummy JSON was created to path \""+fileName+"\" you lazy ass";
    }

}
