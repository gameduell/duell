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

package duell.commands;

import duell.objects.Arguments;
import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;

import haxe.CallStack;

import duell.commands.IGDCommand;

class RepoConfigCommand implements IGDCommand
{
    private static var defaultRepoListURL: String = "git@github.com:gameduell/duell-repository-list.git";

    public function new()
    {
    }

    public function execute() : String
    {
		LogHelper.info("\n");

		var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

		if (Arguments.isSet("-addFront"))
		{
			var arguments: Array<String> = Arguments.getRawArguments();
			var lastArgument: String = arguments.pop();

			if (lastArgument == "-addFront")
			{
				LogHelper.info("Was empty String");
			}
			else
			{
				if(duellConfig.repoListURLs.indexOf(lastArgument) == -1)
				{
					duellConfig.repoListURLs.insert(0, lastArgument);
					duellConfig.writeToConfig();
				}
				else
				{
					LogHelper.info("This entry was already in");
				}

			}
		}
		else if (Arguments.isSet("-add"))
		{
			var arguments: Array<String> = Arguments.getRawArguments();
			var lastArgument: String = arguments.pop();

			if (lastArgument == "-add")
			{
				LogHelper.info("Was empty String");
			}
			else
			{
				if(duellConfig.repoListURLs.indexOf(lastArgument) == -1)
				{
					duellConfig.repoListURLs.push(lastArgument);
					duellConfig.writeToConfig();
				}
				else
				{
					LogHelper.info("This entry was already in");
				}
			}
		}
		else if (Arguments.isSet("-removeAll"))
		{
			while (duellConfig.repoListURLs.length > 0)
			{
				duellConfig.repoListURLs.pop();
			}

			duellConfig.repoListURLs.push(defaultRepoListURL);

			duellConfig.writeToConfig();

			LogHelper.info("Removed all entries, but the default url");
		}
		else if (Arguments.isSet("-remove"))
		{
			var arguments: Array<String> = Arguments.getRawArguments();
			var lastArgument: String = arguments.pop();

			if (lastArgument == "-remove")
			{
				LogHelper.info("URL was empty string. Did not remove anything.");
			}
			else
			{
				if (lastArgument != defaultRepoListURL)
				{
					if (duellConfig.repoListURLs.remove(lastArgument))
					{
						duellConfig.writeToConfig();
						LogHelper.info("Succefully removed " + lastArgument);
					}
					else
					{
						LogHelper.info(lastArgument + " was not in the repo list");
					}
				}
				else
				{
					LogHelper.info("It is not allowed to remove the default URL");
				}
			}
		}
		else if (Arguments.isSet("-reverse"))
		{
			duellConfig.repoListURLs.reverse();
			duellConfig.writeToConfig();
			LogHelper.info("Reversed all entries");
		}

		LogHelper.info("\n");
		LogHelper.info("\x1b[2m------");
		LogHelper.info("Repository List");
		LogHelper.info("------\x1b[0m");
		printRepoList(duellConfig.repoListURLs);
		LogHelper.info("\n");

	    return "success";
    }

	private function printRepoList(repoList: Array<String>): Void
	{
		var counter: Int = 1;
		for (repo in repoList)
		{
			LogHelper.info(counter + ". " + repo);
			counter++;
		}
	}
}
