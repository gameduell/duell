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

import duell.objects.DuellProcess;

using StringTools;

class GitHelper
{
	static public function setRemoteURL(path : String, remoteName : String, url : String) : Int
	{
        var gitProcess = runGitCommand(path, ["remote", "set-url", remoteName, url], "setting git remote url");
        gitProcess.blockUntilFinished();

		return gitProcess.exitCode();
	}

    static public function clone(gitURL : String, path : String) : Int
    {
		PathHelper.mkdir(path);

		var pathComponents = path.split("/");
		var folder = pathComponents.pop();
		path = pathComponents.join("/");

        var gitProcess = runGitCommand(path, ["clone", gitURL, folder], "cloning git", true);

        return gitProcess.exitCode();
    }

    static public function pull(destination : String, parameters: Array<String> = null) : Int
    {
        if (!ConnectionHelper.isOnline())
        {
            return 0;
        }

		if (parameters == null)
		{
			parameters = [];
		}

        var gitProcess = runGitCommand(destination, ["pull"].concat(parameters), "pulling git");
        gitProcess.blockUntilFinished();

        return gitProcess.exitCode();
    }

    static public function updateNeeded(destination : String) : Bool
    {
        if (!ConnectionHelper.isOnline())
        {
            return false;
        }

        runGitCommand(destination, ["remote", "update"], "checking for update on git", true);

        var gitProcess = runGitCommand(destination, ["status", "-b", "--porcelain"],
                                        "checking for update on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        if (output.indexOf("[behind") != -1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    static public function isRepoWithoutLocalChanges(destination : String) : Bool
    {
        var gitProcess = runGitCommand(destination, ["status", "-s", "--porcelain"],
                                        "checking for local changes on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        var changesListStrings = output.split("\n");
        var changesListStringsTrimmed = changesListStrings.map(function(str : String): String return str.trim());

        for (str in changesListStringsTrimmed)
        {
            if(str != "" && !str.startsWith("??"))
                return false;
        }

        return true;
    }

    static public function fetch(destination : String)
    {
        if (!ConnectionHelper.isOnline())
        {
            return;
        }

        runGitCommand(destination, ["fetch", "--tags", "--prune"], "fetching git", true);
    }

    static public function getCurrentBranch(destination : String) : String
    {
        var gitProcess = runGitCommand(destination, ["rev-parse", "--verify", "--abbrev-ref", "HEAD"],
                                        "getting current branch on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        return output.split("\n")[0];
    }

    static public function getCurrentCommit(destination : String) : String
    {
        var gitProcess = runGitCommand(destination, ["rev-parse", "--verify", "HEAD"],
                                        "getting current commit on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        return output.split("\n")[0];
    }

    static public function getCurrentTags(destination : String) : Array<String>
    {
        var gitProcess = runGitCommand(destination, ["tag", "--contains", "HEAD"], "getting current tags on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        return output.split("\n");
    }

    static public function getCommitForTag(destination : String, tag : String) : String
    {
        var gitProcess = runGitCommand(destination, ["rev-parse", tag + "~0"], "getting commit for tag on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        return output.split("\n")[0];
    }

    static public function listRemotes(destination: String): Map<String, String>
    {
        var gitProcess = runGitCommand(destination, ["remote", "-v"], "listing remotes on git", true);

        var allRemotes: String = gitProcess.getCompleteStdout().toString();

        var allRemoteList: Array<String> = allRemotes.split("\n");
        var returnedMap: Map<String, String> = new Map();

        for (line in allRemoteList)
        {
            // format: <remote name>	<url> (<fetch/push>)
            // mind the tab!
            var remoteParts: Array<String> = line.trim().split(" ");
            remoteParts = remoteParts[0].split("\t");

            if (remoteParts.length < 2)
            {
                continue;
            }

            var remoteName: String = remoteParts[0].trim();
            var remoteUrl: String = remoteParts[1].trim();

            if (!returnedMap.exists(remoteName))
            {
                returnedMap.set(remoteName, remoteUrl);
            }
        }

        return returnedMap;
    }

    static public function listBranches(destination : String) : Array<String>
    {
        var gitProcess = runGitCommand(destination, ["branch", "-a"], "listing branches on git", true);

        var outputAllBranches = gitProcess.getCompleteStdout().toString();

        var outputList : Array<String> = outputAllBranches.split("\n");
        var returnedList : Array<String> = [];

        for (line in outputList)
        {
            var branch = null;
            var remote = null;

            if (line.charAt(0) == "*")
                line = line.substr(1);

            line = line.trim();

            if (line.startsWith("remotes/"))
            {
                line = line.substr("remotes/".length);
                remote = line.substr(0, line.indexOf("/"));

                branch = line.substr(line.indexOf("/") + 1);

                if (returnedList.indexOf(branch) == -1)
                    returnedList.push(branch);
            }
            else
            {
                branch = line;
                returnedList.push(branch);
            }
        }

        return returnedList;
    }


    static public function listTags(destination : String) : Array<String>
    {
        var gitProcess = runGitCommand(destination, ["tag"], "listing tags on git", true);

        var output = gitProcess.getCompleteStdout().toString();

        return output.split("\n");
    }

    static public function checkoutBranch(destination : String, branch : String) : Int
    {
        var gitProcess = runGitCommand(destination, ["checkout", branch], "checking out branch on git", true);

        return gitProcess.exitCode();
    }

    static public function checkoutCommit(destination : String, commit : String) : Int
    {
        var gitProcess = runGitCommand(destination, ["checkout", commit], "checking out commit on git", true);

        return gitProcess.exitCode();
    }

    static public function createTag(destination : String, tagName: String, tagMessage: String): Int
    {
        var gitProcess = runGitCommand(destination, ["tag", "-a", tagName, "-m", tagMessage], "creating a tag on git");

        return gitProcess.exitCode();
    }

    static public function pushTags(destination : String): Int
    {
        var gitProcess = runGitCommand(destination, ["push", "origin", "--tags"], "pushing a tag on git", true);

        return gitProcess.exitCode();
	}

    /**
        Number of retries for remote git commands. Set to 0 to disable it.
    **/
    private static inline var MAX_COMMAND_RETRIES: Int = 2;

    /**
        Macro function for executing Git commands as Duell processes.
        @param retryOnError If set to true it will retry for the number of times assuming that the error could be a
        connection issue. Default value is false.
    **/
    static private function runGitCommand(path: String, args: Array<String>, errorMessage: String,
                                          retryOnError: Bool = false): DuellProcess
    {
        var options: ProcessOptions = {
            systemCommand:      true,
            loggingPrefix:      "[Git]",
            block:              true,
            errorMessage:       errorMessage
        };

        if (retryOnError)
        {
            options.shutdownOnError = true;

            var retry: Int = 0;
            while (true)
            {
                try
                {
                    return new DuellProcess(path, "git", args, options);
                }
                catch (e: Dynamic)
                {
                    if (MAX_COMMAND_RETRIES > 0 && ++retry <= MAX_COMMAND_RETRIES)
                    {
                        LogHelper.warn('$e. Retrying #$retry...');
                    }
                    else
                    {
                        throw e;
                    }
                }
            }
            return null;
        }
        else
        {
            return new DuellProcess(path, "git", args, options);
        }
    }

}
