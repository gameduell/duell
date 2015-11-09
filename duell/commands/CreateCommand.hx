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

import duell.helpers.CommandHelper;
import duell.helpers.PathHelper;
import duell.helpers.AskHelper;
import duell.helpers.DuellLibHelper;
import duell.helpers.PythonImportHelper;
import duell.helpers.DuellLibListHelper;
import duell.objects.DuellLib;
import haxe.CallStack;
import duell.helpers.LogHelper;
import duell.commands.IGDCommand;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

import duell.objects.Arguments;
class CreateCommand implements IGDCommand
{
    var setupLib : DuellLib = null;

    public function new() {}

    public function execute() : String
    {
        LogHelper.info("");
        LogHelper.info("\x1b[2m------");
        LogHelper.info("Create");
        LogHelper.info("------\x1b[0m");
        LogHelper.info("");

        determineDuellLibraryFromArguments();

        LogHelper.println("");

        runPluginLib();

        LogHelper.println("");
        LogHelper.info("\x1b[2m------");
        LogHelper.info("end");
        LogHelper.info("------\x1b[0m");

        return "success";
    }

    private function determineDuellLibraryFromArguments()
    {
        var pluginName = Arguments.getSelectedPlugin();

        var pluginNameCorrectnessCheck = ~/^[A-Za-z0-9]+$/;

        if (!pluginNameCorrectnessCheck.match(pluginName))
            throw 'Unknown plugin $pluginName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell create emptyProject\" or \"duell create helloWorld\"';

        var pluginLibName = "duellcreate" + pluginName;

        var libList = DuellLibListHelper.getDuellLibReferenceList();
        if (!libList.exists(pluginLibName))
        {
            LogHelper.exitWithFormattedError('Unknown plugin \'$pluginName\'. Run \"duell create -help\" to get a list of valid plugins.');
        }

        setupLib = DuellLib.getDuellLib(pluginLibName);

        if (DuellLibHelper.isInstalled(pluginLibName))
        {
            if (DuellLibHelper.updateNeeded(pluginLibName) == true)
            {
                var answer = AskHelper.askYesOrNo('The plugin with name $pluginName is not up to date on the master branch. Would you like to try to update it?');

                if(answer)
                {
                    DuellLibHelper.update(pluginLibName);
                }
            }
            else
            {
                LogHelper.info("","No update needed");
            }
        }
        else
        {
            var answer = AskHelper.askYesOrNo('The plugin of name $pluginName is not currently installed. Would you like to try to install it?');

            if(answer)
            {
                DuellLibHelper.install(pluginLibName);
            }
            else
            {
                LogHelper.println('Rerun with the plugin/library "$pluginName" installed');
                Sys.exit(0);
            }
        }
    }

    private function runPluginLib()
    {
        var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
        var outputRun = haxe.io.Path.join(['$outputFolder', 'run.py']);

        var buildArguments = new Array<String>();

        buildArguments.push("-main");
        buildArguments.push("duell.create.CreateMain");

        buildArguments.push("-python");
        buildArguments.push(outputRun);

        buildArguments.push("-cp");
        buildArguments.push(DuellLibHelper.getPath("duell"));

        buildArguments.push("-cp");
        buildArguments.push(DuellLibHelper.getPath(setupLib.name));

        buildArguments.push("-resource");
        buildArguments.push(Path.join([DuellLibHelper.getPath("duell"), Arguments.CONFIG_XML_FILE]) + "@generalArguments");

        PathHelper.mkdir(outputFolder);

        CommandHelper.runHaxe("", buildArguments, {errorMessage: "building the plugin"});

        /// bootstrap python libs
        var pyLibPath = haxe.io.Path.join([DuellLibHelper.getPath(setupLib.name), "pylib"]);
        if (FileSystem.exists(pyLibPath))
        {
            var file = File.getBytes(outputRun);

            var fileOutput = File.write(outputRun, true);
            fileOutput.writeString("import os\n");
            fileOutput.writeString("import sys\n");
            fileOutput.writeString('sys.path.insert(0, "$pyLibPath")\n');

            fileOutput.writeBytes(file, 0, file.length);
            fileOutput.close();
        }

        PythonImportHelper.runPythonFile(outputRun);
    }

}
