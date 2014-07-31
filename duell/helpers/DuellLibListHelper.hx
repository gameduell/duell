/**
 * @autor rcam
 * @date 30.07.2014.
 * @company Gameduell GmbH
 */
 
package duell.helpers;

import duell.helpers.DuellConfigHelper;
import duell.helpers.GitHelper;
import duell.helpers.PathHelper;
import duell.objects.DuellConfigJSON;
import duell.objects.DuellLib;

import sys.io.File;
import Reflect;
import sys.FileSystem;
import haxe.io.Error;
import haxe.Json;

class DuellLibListHelper
{
    public static var DEPENDENCY_LIST_FILENAME = "duell_dependencies.json" ;

	private static var repoListCache : Map<String, DuellLib> = null;
    public static function getDuellLibList() : Map<String, DuellLib>
    {
    	if(repoListCache != null)
    		return repoListCache;

        repoListCache = new Map<String, DuellLib>();

    	var duellConfig : DuellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        var libListFolder : String = DuellConfigHelper.getDuellConfigFolderLocation() + "/" + "lib_list";

        if(duellConfig.repoListURLs == null || duellConfig.repoListURLs.length == 0)
        {
            LogHelper.error("No repo urls are defined. Run \"duell setup\" to fix this.");
        }

        /// we remove because if the user changes lib lists urls, the result will be very undefined. This way is a bit slower but cleaner.
        if(FileSystem.exists(libListFolder))
        {    
            LogHelper.info("Cleaning up existing lib lists...");

            PathHelper.removeDirectory(libListFolder);
        }

        var repoListIndex = 1;
        for(repoURL in duellConfig.repoListURLs)
        {
            var path = libListFolder + "/" + repoListIndex;
            if(GitHelper.clone(repoURL, path) != 0)
            {
                LogHelper.error("Can't access the repo list in " + repoURL + " or something is wrong with the folder " + path);
            }

            try
            {
                var configContent = File.getContent(path + "/haxe-repo-list.json");
                var configJSON = Json.parse(configContent);

                addLibsToTheRepoCache(configJSON);
            }
            catch (e : Error)
            {
                LogHelper.error("Cannot Parse repo list. Check if this file is correct: " + path + "/haxe-repo-list.json");
            }
        }

        return repoListCache;
    }

    private static function addLibsToTheRepoCache(configJSON : Dynamic) 
    {
        var listOfRepos = Reflect.fields(configJSON);

        var duellLibMap = new Map<String, DuellLib>();

        for(repo in listOfRepos)
        {
            var repoInfo = Reflect.field(configJSON, repo);
            if(repoListCache.exists(repo))
            {
                LogHelper.info("Found duplicate for " + repo + " in the repo list URLs. Using " + repoInfo.git_path);
            }

            repoListCache.set(repo, new DuellLib(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path));
        }
    }

    private static var alreadyInstalledFiles : Array<String> = new Array<String>();
    public static function installWithDependenciesFile(filename : String)
    {
        if(alreadyInstalledFiles.indexOf(filename) != -1)
            return;

        alreadyInstalledFiles.push(filename);

        var duellLibList = getDuellLibList();

        var requestedLibraries : {version:String, duell_libs:Array<String>, haxe_libs:Array<String>} = null;
        try
        {
            var content = File.getContent(filename);
            requestedLibraries = Json.parse(content);
        }
        catch (e:Error)
        {
            LogHelper.error("Cannot parse " + filename);
        }

        if (requestedLibraries != null && requestedLibraries.version != Duell.VERSION)
        {
            LogHelper.error("the version in the file is different then the current Version of Duell tool");
        }

        for (requestedLib in requestedLibraries.duell_libs) 
        {
            if(!duellLibList.exists(requestedLib))
            {
                LogHelper.error("Unknown library " + requestedLib + ". Please check the repo list for this library.");
            }

            var duellLib = duellLibList.get(requestedLib);

            installDuellLibrary(duellLib);

        }

        for (requestedLib in requestedLibraries.haxe_libs) 
        {
            installHaxeLibrary(requestedLib);
        }
    }

    public static function installDuellLibrary(library : DuellLib)
    {
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Installing lib " + library.name +"===============================================");
        LogHelper.println("Creating directory : [" + library.destinationPath + "]");

        var path = duellConfigJSON.localLibraryPath + "/" + library.destinationPath;

        /// checkout 
        if (FileSystem.exists(path))
        {
            if (GitHelper.pull(path) != 0 )
            {
                LogHelper.error("Can't Install library " + library.name);
            }
        }
        else
        {
            if(GitHelper.clone(library.gitPath, path) != 0 )
            {
                LogHelper.error("Can't Install library " + library.name);
            }
        }

        LogHelper.println("Setting repo as haxelib dev");

        ProcessHelper.runCommand(path, "haxelib", ["dev", library.name, duellConfigJSON.localLibraryPath + "/" + library.libPath]);

        LogHelper.info("Done Installing lib " + library.name +" ==========================================");

        if (FileSystem.exists(path + "/" + DEPENDENCY_LIST_FILENAME))
        {
            installWithDependenciesFile(path + "/" + DEPENDENCY_LIST_FILENAME);
        }

    }

    public static function installHaxeLibrary(lib : String)
    {
        ProcessHelper.runCommand("", "haxelib", ["install", lib]);
    }

    private static var alreadyUpdatedFiles : Array<String> = new Array<String>();
    public static function updateWithDependenciesFile(filename : String)
    {
        if(alreadyUpdatedFiles.indexOf(filename) != -1)
            return;

        alreadyUpdatedFiles.push(filename);

        var duellLibList = getDuellLibList();

        var requestedLibraries : {version:String, duell_libs:Array<String>, haxe_libs:Array<String>} = null;
        try
        {
            var content = File.getContent(filename);
            requestedLibraries = Json.parse(content);
        }
        catch (e:Error)
        {
            LogHelper.error("Cannot parse " + filename);
        }

        if (requestedLibraries != null && requestedLibraries.version != Duell.VERSION)
        {
            LogHelper.error("the version in the file is different then the current Version of Duell tool");
        }

        for (requestedLib in requestedLibraries.duell_libs) 
        {
            if(!duellLibList.exists(requestedLib))
            {
                LogHelper.error("Unknown library " + requestedLib + ". Please check the repo list for this library.");
            }

            var duellLib = duellLibList.get(requestedLib);

            updateDuellLib(duellLib);

        }

        for (requestedLib in requestedLibraries.haxe_libs) 
        {
            updateHaxeLibrary(requestedLib);
        }
    }

    public static function updateDuellLib(library : DuellLib)
    {        
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Updating lib " + library.name +"===============================================");

        var path = duellConfigJSON.localLibraryPath + "/" + library.destinationPath;

        if (!FileSystem.exists(path))
        {
            LogHelper.error("library " + library.name + " not installed!");
        }

        GitHelper.pull(path);
    }

    public static function updateHaxeLibrary(lib : String)
    {
        ProcessHelper.runCommand("", "haxelib", ["update", lib]);
    }
}

