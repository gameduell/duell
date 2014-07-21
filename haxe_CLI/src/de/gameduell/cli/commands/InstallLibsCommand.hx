/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */
package de.gameduell.cli.commands;

import de.gameduell.cli.helpers.SemVer;
import de.gameduell.cli.helpers.LogHelper;

import sys.io.Process;
import Sys;
import sys.FileSystem;
import sys.io.File;
import sys.io.File;
import haxe.Json;
import haxe.io.Error;
import de.gameduell.cli.commands.impl.IGDCommand;
class InstallLibsCommand implements IGDCommand 
{
    private static var DEFAULT_ENVIRONMENT_URL:String = "ssh://git@phabricator.office.gameduell.de:2222/diffusion/HAXMISCHAXEREPOLIST/haxe-repo-list.git";
    private var content:String;
    private var parsedContent:{env_url:String,version:String, dev_libs:Array<String>};
    private var parsedGlobalConfig:Dynamic;
    private var repoErrorOccured:Bool = false;
    private var globalErrorOccured:Bool = false;
    public function new() {}

    public function execute(cmd:String):String
    {
        var fileName:String = null;
        var environment:String;

        if (Sys.args().length > 1)
        {
            fileName = Sys.args()[1];
        }

        /** if file name specified **/
        if (fileName == null || fileName.length == 0)
            return "syntax error you should specifiy the file name example c:/developer/config.json";


        /** if specified file exist ? **/
        if (!FileSystem.exists(fileName))
            return "file with path '" + fileName + "' not found";


        /** Parse local config file **/
        try
        {
            content = File.getContent(fileName);
            parsedContent = Json.parse(content);
        }
        catch (e:Error)
        {
            return "ERROR : Cannot Parse the file";
        }

        /**
        * =============================================================================================
        * clone git repo containing remote config file
        * if the env_url is not specified we take the default envirnoment url
        * =============================================================================================
        **/
        environment = parsedContent.env_url == null ? DEFAULT_ENVIRONMENT_URL : parsedContent.env_url;

        if( !getEnvironmentFile(environment) )
        {
            return "ERROR : Can't load the global config file from the server something went wrong";
        }

        /** Install libs and return final results **/
        return doInstallLibs(fileName);
    }
        /**
        * =============================================================================================
        * cloning global config file repo
        * Parse global config file
        * =============================================================================================
        **/
    private function getEnvironmentFile( environment:String ):Bool
    {
        var destination:String = "haxe-repo-list";
        var globalFileContent:String;

        /** cloning global config file repo , if it exists we git pull**/
        if (FileSystem.exists(destination))
        {
            if( gitPull(destination) != 0 )
            {
                LogHelper.error("Can't Get the  global config file ");
                return false;
            }
        }
        else
        {
            if( gitClone(environment,destination) != 0 )
            {
                LogHelper.error("Can't Get the  global config file ");
                return false;
            }
        }

        /** Parse global config file **/
        try
        {
            globalFileContent = File.getContent(destination+"/haxe-repo-list.json");
            parsedGlobalConfig = Json.parse(globalFileContent);
        }
        catch (e:Error)
        {
            LogHelper.error("Cannot Parse global config file seems to be broken ");
            return false;
        }

        return true;
    }

    private function gitClone( gitURL:String,destination:String ):Int
    {
        Sys.command("mkdir", [destination]);
        return Sys.command("git clone \"" + gitURL + "\" \"" + destination + "\"");
    }

    private function gitPull( destination:String ):Int
    {
        var result:Int = 0;
        LogHelper.info(" Directory already exists, Updating... ");

        result = Sys.command("cd " + destination + " && " + "git pull && cd ..");
        return result;
    }

    private function doInstallLibs(fileName:String):String
    {
        var library:Dynamic;
        repoErrorOccured = false;


        if (parsedContent != null && parsedContent.version != GDCommandLine.VERSION)
        {
            return "the version in the file is different then the current Version of GDShell";
        }

        for (lib in parsedContent.dev_libs) {
            library = Reflect.field(parsedGlobalConfig,lib);
            installLibrary(library,lib);
            repoErrorOccured = false;
            LogHelper.println("Done Installing lib "+ lib +" ==========================================");
        }


        return "Installing done "+(globalErrorOccured ? " With some Errors" : " Without Errors");
    }

    public function installLibrary(library:Dynamic,lib:String):Void
    {
        var repoErrorOccured:Bool = false;
        var parsedHaxeLib:Dynamic;
        var globalDependencies:List<{ project: String, version : String }>;
        var gdLibContent:String;
        var gdLibParsedContent:{dependencies:Array<String>};
        if( library == null ) return;

        LogHelper.println("Installing lib "+ lib +"===============================================");
        LogHelper.println("Creating directory : [" + library.destination_path + "]");



        /**checkout into directory after creating it**/

        if (FileSystem.exists(library.destination_path))
        {
            if( gitPull(library.destination_path) != 0 )
            {
                LogHelper.error("Can't Install library "+lib);
                repoErrorOccured = true;
                globalErrorOccured = true;
            }
        }
        else
        {

            if( gitClone(library.git_path,library.destination_path) != 0 )
            {
                LogHelper.println("Can't Install library "+lib);
                repoErrorOccured = true;
                globalErrorOccured = true;
            }
        }

        /** Haxelib JSON File **/
        try
        {
            parsedHaxeLib = Json.parse( File.getContent(library.library_path+"/haxelib.json") );
            globalDependencies = new List();
            try {
                for( d in Reflect.fields(parsedHaxeLib.dependencies) ) {
                    var version = try {
                        SemVer.ofString( Std.string(Reflect.field(parsedHaxeLib.dependencies,d)) ).toString();
                    } catch (e:Dynamic) "";
                    globalDependencies.add({ project: d, version: version });
                }
            } catch(e:Dynamic) {}
        }
        catch (e:Error)
        {
            parsedHaxeLib = null;
            globalDependencies = null;
            LogHelper.error("Cannot Parse haxelib.json for "+lib+" file seems to be broken ");
        }

        if( globalDependencies != null )
        {
            var arguments:Array<String> =[];
            trace(globalDependencies);
            for ( dependency in globalDependencies )
            {
                LogHelper.println("Installing dependency "+dependency.project+" "+dependency.version);
                arguments.push(dependency.project);
                if( dependency.version != "" )
                    arguments.push(dependency.version);

                Sys.command("haxelib install ",arguments);
                arguments = [];
            }
        }


        /** Haxelib dev **/
        if(!repoErrorOccured)
        {
            var command:String = "haxelib";
            var arguments:Array<String> = ["dev",lib,library.library_path];

            var process:Process = new Process(command, arguments);
            process.exitCode();

            LogHelper.println("Output From Haxelib : "+ process.stdout.readAll().toString());


        }

        /** If there is some custom dev lib to add**/
        if( FileSystem.exists(library.destination_path+"/gd_lib.json") )
        {
            try
            {
                gdLibContent = File.getContent(library.destination_path+"/gd_lib.json");
                gdLibParsedContent = Json.parse(gdLibContent);
                installGDLibs(gdLibParsedContent);
            }
            catch (e:Error)
            {
                LogHelper.error("Cannot Parse gd lib config file seems to be broken ");
            }
        }
    }
    public function installGDLibs( gdLibParsedContent:{dependencies:Array<String>} ):Void
    {
        var library:Dynamic;
        for (lib in gdLibParsedContent.dependencies)
        {
            library = Reflect.field(parsedGlobalConfig,lib);
            installLibrary(library,lib);
        }
    }

}
