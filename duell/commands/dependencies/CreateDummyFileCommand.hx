/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */
package duell.commands.dependencies;

import sys.io.File;
import haxe.Json;

import duell.commands.IGDCommand;
class CreateDummyFileCommand implements IGDCommand{

    /** Just dummy file to generate when ask for**/
    private var dummyJSON:Dynamic = Json.parse('{
                                                    "version":"0.1.0"
                                                    ,"duell_libs": [
                                                                    "types",
                                                                    "events",
                                                                    "asyncrunner",
                                                                    "filesystem",
                                                                    "graphics",
                                                                    "events",
                                                                    "hxcpp",
                                                                    "hxjni",
                                                                    "ios_appdelegate",
                                                                    "android_appdelegate",
                                                                    "munit",
                                                                    "media",
                                                                    "opengl",
                                                                    "platform",
                                                                    "renderer",
                                                                    "unittest"
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

    public function execute( cmd:String ):String
    {
        var fileName = null;
        if(Sys.args().length > 1)
        {
            fileName =  Sys.args()[1];
        }

        if( fileName==null || fileName.length==0 )//check if the lazy ass didn't provide file name we set a default file name
            fileName =  "dummy_gdshell_"+Duell.VERSION+".json";

        dummyJSON.version = Duell.VERSION;
        File.saveContent(fileName,Json.stringify(dummyJSON));

        return "dummy JSON was created to path \""+fileName+"\"";
    }

}
