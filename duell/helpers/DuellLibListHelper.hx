/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.helpers;

import duell.helpers.DuellConfigHelper;
import duell.helpers.GitHelper;
import duell.helpers.PathHelper;
import duell.objects.DuellConfigJSON;
import duell.objects.DuellLibReference;

import sys.io.File;
import Reflect;
import sys.FileSystem;
import haxe.io.Error;
import haxe.Json;

class DuellLibListHelper
{
    public static var DEPENDENCY_LIST_FILENAME = "duell_dependencies.json";

	private static var repoListCache : Map<String, DuellLibReference> = null;

    public static function getDuellLibReferenceList() : Map<String, DuellLibReference>
    {
    	if(repoListCache != null)
    		return repoListCache;

        repoListCache = new Map<String, DuellLibReference>();

        var duellConfig : DuellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
        var libListFolder : String = DuellConfigHelper.getDuellConfigFolderLocation() + "/" + "lib_list";

        validateAndCleanRepos(duellConfig, libListFolder);

        var repoListIndex = 1;
        /// reversed to give priority to the ones which are first on the list
        var reverseRepoListduellConfig = duellConfig.repoListURLs.copy();
        reverseRepoListduellConfig.reverse();
        for(repoURL in reverseRepoListduellConfig)
        {
            var path = libListFolder + "/" + repoListIndex;
            if(GitHelper.clone(repoURL, path) != 0)
            {
                throw "Can't access the repo list in " + repoURL + " or something is wrong with the folder " + path;
            }

            try
            {
                var configContent = File.getContent(path + "/haxe-repo-list.json");
                var configJSON = Json.parse(configContent);

                addLibsToTheRepoCache(configJSON);
            }
            catch (e : Error)
            {
                throw "Cannot Parse repo list. Check if this file is correct: " + path + "/haxe-repo-list.json";
            }

            repoListIndex++;
        }

        return repoListCache;
    }

    private static function validateAndCleanRepos(duellConfig : DuellConfigJSON, libListFolder : String)
    {
        if(duellConfig.repoListURLs == null || duellConfig.repoListURLs.length == 0)
        {
            throw "No repo urls are defined. Run \"duell setup\" to fix this.";
        }

        /// we remove because if the user changes lib lists urls, the result will be very undefined. This way is a bit slower but cleaner.
        if(FileSystem.exists(libListFolder))
        {
            LogHelper.info("", "Cleaning up existing lib lists...");

            PathHelper.removeDirectory(libListFolder);
        }
    }

    private static function addLibsToTheRepoCache(configJSON : Dynamic)
    {
        var listOfRepos = Reflect.fields(configJSON);
        var duellLibMap = new Map<String, DuellLibReference>();
        var duplicates  = false;

        for(repo in listOfRepos)
        {
            var repoInfo = Reflect.field(configJSON, repo);
            if(repoListCache.exists(repo))
            {
                duplicates = true;//LogHelper.info("Found duplicate for " + repo + " in the repo list URLs. Using " + repoInfo.git_path);
            }

            repoListCache.set(repo, new DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path));
        }

        if(duplicates){
            LogHelper.info("Duplicates found in the repo list URLs. List duplicates by using \"duell repo_list\" command.");
            LogHelper.info(" ");
        }
    }

    public static function getDuplicatesFromRepoLists() : Map<String, Array<DuellLibReference>>
    {
        var duellConfig : DuellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
        var libListFolder : String = DuellConfigHelper.getDuellConfigFolderLocation() + "/" + "lib_list";

        validateAndCleanRepos(duellConfig, libListFolder);

        var source = new Map<String, DuellLibReference>();
        var duplicates = new Map<String, Array<DuellLibReference>>();

        var repoListIndex = 1;
        /// reversed to give priority to the ones which are first on the list
        var reverseRepoListduellConfig = duellConfig.repoListURLs.copy();
        reverseRepoListduellConfig.reverse();
        for(repoURL in reverseRepoListduellConfig)
        {
            var path = libListFolder + "/" + repoListIndex;
            if(GitHelper.clone(repoURL, path) != 0)
            {
                throw "Can't access the repo list in " + repoURL + " or something is wrong with the folder " + path;
            }

            try
            {
                var configContent = File.getContent(path + "/haxe-repo-list.json");
                var configJSON = Json.parse(configContent);

                createDuplicateList(configJSON, source, duplicates);
            }
            catch (e : Error)
            {
                throw "Cannot Parse repo list. Check if this file is correct: " + path + "/haxe-repo-list.json";
            }

            repoListIndex++;
        }

        return duplicates;
    }

    private static function createDuplicateList(configJSON : Dynamic, source : Map<String, DuellLibReference>, duplicates : Map<String, Array<DuellLibReference>>)
    {
        var listOfRepos = Reflect.fields(configJSON);
        for(repo in listOfRepos)
        {
            var repoInfo = Reflect.field(configJSON, repo);
            if(source.exists(repo))
            {
                var duplicateList : Array<DuellLibReference>;
                if(!duplicates.exists(repo))
                {
                    duplicateList = [source.get(repo)];
                    duplicates.set(repo, duplicateList);
                }
                
                duplicateList = duplicates.get(repo);
                duplicateList.push(new DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path));
            }
            else
            {
                source.set(repo, new DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path));
            }
        }
    }

    /**
    * function libraryExists
    * @param name String
    * @return Boolean
    *
    * Checks if a certain libray name is available in the configured repository lists.
    */
    public static function libraryExists(name : String) : Bool
    {
        if(name == null)
        {
            return false;
        }

        var list = getDuellLibReferenceList();
        for ( key in list.keys() )
        {
            if ( key == name )
            {
                return true;
            }
        }

        return false;
    }
}