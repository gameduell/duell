package de.gameduell.cli.commands;
/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */
import sys.io.File;
import haxe.Json;
import de.gameduell.cli.commands.impl.IGDCommand;
class CreateDummyFileCommand implements IGDCommand{

    /** Just dummy file to generate when ask for**/
    private var dummyJSON:Dynamic = Json.parse('{
                                                    "version":"0.1.0"
                                                    ,"env_url":"ssh://git@phabricator.office.gameduell.de:2222/diffusion/HAXMISCHAXEREPOLIST/haxe-repo-list.git"
                                                    ,"dev_libs": [
                                                                    "ash",
                                                                    "types",
                                                                    "asyncrunner",
                                                                    "filesystem",
                                                                    "graphics",
                                                                    "hxcpp",
                                                                    "hxjni",
                                                                    "ios_appdelegate",
                                                                    "android_appdelegate",
                                                                    "lime",
                                                                    "lime-tools",
                                                                    "munit",
                                                                    "media",
                                                                    "opengl",
                                                                    "platform",
                                                                    "renderer",
                                                                    "unittest"
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
            fileName =  "dummy_gdshell_"+GDCommandLine.VERSION+".json";

        dummyJSON.version = GDCommandLine.VERSION;
        File.saveContent(fileName,Json.stringify(dummyJSON));

        return "dummy JSON was created to path \""+fileName+"\"";
    }

}
