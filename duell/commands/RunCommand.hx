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

import duell.helpers.ConnectionHelper;
import duell.helpers.SchemaHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.CommandHelper;
import haxe.CallStack;
import Sys;

import duell.defines.DuellDefines;

import duell.objects.DuellLib;

import duell.helpers.LogHelper;
import duell.helpers.AskHelper;
import duell.helpers.PathHelper;
import duell.helpers.DuellLibHelper;

import duell.versioning.GitVers;

import sys.io.File;
import sys.FileSystem;

import haxe.xml.Fast;

import haxe.io.Path;

import duell.commands.IGDCommand;

import duell.objects.Arguments;

import duell.objects.DuellConfigJSON;

class RunCommand implements IGDCommand
{
    var runLib : DuellLib = null;

    var buildGitVers: GitVers = null;
    var pluginName : String;

    var duellConfig: DuellConfigJSON;

    public function new()
    {
    }

    public function execute() : String
    {
        checkIfItIsAProjectOrLibraryFolder();
        determinePluginToRunFromArguments();
        checkPluginVersion();
        buildNewRunExecutableWithRunLib();
        return "success";
    }

    private function checkIfItIsAProjectOrLibraryFolder()
    {
        if (!FileSystem.exists(DuellDefines.PROJECT_CONFIG_FILENAME) && !FileSystem.exists(DuellDefines.LIB_CONFIG_FILENAME))
        {
            throw 'Running from a folder which is not a project or a library';
        }
    }

    private function determinePluginToRunFromArguments()
    {
        pluginName = Arguments.getSelectedPlugin();

        var pluginNameCorrectnessCheck = ~/^[A-Za-z0-9]+$/;

        if (!pluginNameCorrectnessCheck.match(pluginName))
            throw 'Unknown plugin $pluginName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell run myLib\" or \"duell run coverageCheck\"';

        runLib = DuellLib.getDuellLib(pluginName);

        if (!DuellLibHelper.isInstalled(runLib.name))
        {
            var answer = AskHelper.askYesOrNo('A library for running $pluginName is not currently installed. Would you like to try to install it?');
            var stopBuild = true;

            if (answer)
            {
                DuellLibHelper.install(runLib.name); // Is now on master
                stopBuild = false;
            }
            else
            {
                LogHelper.println('Rerun with the library "$pluginName" installed');
            }

            if (stopBuild)
            {
                Sys.exit(0);
            }
        }
    }

    private function checkPluginVersion()
    {
        if (runLib.version == "master")
        {
            if (runLib.updateNeeded()) // TODO Maybe check every 8 hours
            {
                runLib.update();
            }
        }
    }

    private function buildNewRunExecutableWithRunLib()
    {
        var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
        var outputRun = haxe.io.Path.join(['$outputFolder', 'run_' + pluginName + '.n']);

        var buildArguments = new Array<String>();

        buildArguments.push("-main");
        buildArguments.push("duell.run.main.RunMain");

        buildArguments.push("-neko");
        buildArguments.push(outputRun);

        buildArguments.push("-cp");
        buildArguments.push(DuellLibHelper.getPath("duell"));

        buildArguments.push("-cp");
        buildArguments.push(DuellLibHelper.getPath(runLib.name));

        buildArguments.push("-D");
        buildArguments.push("run_plugin_" + pluginName);

        buildArguments.push("-D");
        buildArguments.push("plugin");

        buildArguments.push("-resource");
        buildArguments.push(Path.join([DuellLibHelper.getPath("duell"), Arguments.CONFIG_XML_FILE]) + "@generalArguments");

        CommandHelper.runHaxe("", buildArguments, {errorMessage: "building the plugin"});

        var runArguments = [outputRun];
        runArguments = runArguments.concat(Arguments.getRawArguments());

        var result = CommandHelper.runNeko("", runArguments, {errorMessage: "running the plugin", exitOnError: false});

        if (result != 0)
        {
            Sys.exit(result);
        }
    }
}