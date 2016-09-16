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

package duell;

import haxe.io.Path;
import duell.helpers.PlatformHelper;
import duell.helpers.LogHelper;

import duell.objects.Arguments;

import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;
import duell.helpers.AskHelper;
import duell.helpers.DuellLibHelper;
import duell.objects.DuellLib;

import duell.commands.RunCommand;
import duell.commands.BuildCommand;
import duell.commands.UpdateCommand;
import duell.commands.CreateCommand;
import duell.commands.EnvironmentSetupCommand;
import duell.commands.RepoConfigCommand;
import duell.commands.ToolSetupCommand;
import duell.commands.DependencyCommand;

class Duell
{
    public static var VERSION = "1.0.1";

    /**start the interpreter **/
    public static function main()
    {
        new Duell().run();
    }
    public function new()
    {
    }

    /**
    *  get commands from the console, process them, display output
    *  handle GDConsole commands, get haxe statement (can be multiline), parse it, pass to execution method
    **/
    public function run()
    {
        try {

            if (!Arguments.validateArguments())
            {
                return;
            }

            /// check for missing initial setup
            var isMissingSelfSetup = false;

            if (!sys.FileSystem.exists(DuellConfigHelper.getDuellConfigFileLocation()))
            {
                isMissingSelfSetup = true;
            }
            else
            {
                var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

                if (duellConfig.setupsCompleted.indexOf("self") == -1)
                {
                    isMissingSelfSetup = true;
                }
            }

            if (isMissingSelfSetup && Arguments.getSelectedCommand().name != "self_setup")
            {
                throw 'You are missing the initial setup. Please run the "self_setup" command. For more info run with "-help".';
            }

            if (Arguments.getSelectedCommand().name != "self_setup")
            {
                setLocalJavaDistributionHome();
            }

            if (Arguments.getSelectedCommand().name != "run")
            {
                printBanner();
            }

            if (isMissingSelfSetup)
            {
                new ToolSetupCommand().execute();
            }
            else
            {
                var currentTime = Date.now().getTime();
                Arguments.getSelectedCommand().commandHandler.execute();

                if (Arguments.getSelectedCommand().name != "run")
                {
                    LogHelper.println(' Time passed '+((Date.now().getTime()-currentTime)/1000)+' sec for command "${Arguments.getSelectedCommand().name}"');
                }
            }
        }
        catch (error: Dynamic)
        {
            LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
    		LogHelper.exitWithFormattedError(Std.string(error));
        }
        return;
    }

    private static function printBanner()
    {
        LogHelper.println("\x1b[33;1m                         ");
        LogHelper.println("    ____   __  __ ______ __     __ ");
        LogHelper.println("   / __ \\ / / / // ____// /    / / ");
        LogHelper.println("  / / / // / / // __/  / /    / /  ");
        LogHelper.println(" / /_/ // /_/ // /___ / /___ / /___");
        LogHelper.println("/_____/ \\____//_____//_____//_____/");
        LogHelper.println("                                   \x1b[0m");
        LogHelper.println("");
        LogHelper.println("\x1b[1mDuell tool \x1b[0m\x1b[3;37mDuell command line tool\x1b[0m\x1b[0m");
    }

    private static function setLocalJavaDistributionHome(): Void
    {
        var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();

        var javaHome: String = switch (PlatformHelper.hostPlatform)
        {
            case Platform.MAC: Path.join([duellLibPath, "bin", "mac", "jdk1.8.0_102"]);
            case Platform.WINDOWS: Path.join([duellLibPath, "bin", "win", "jdk1.8.0_102"]);
            case _: null;
        }

        if (javaHome != null)
        {
            Sys.putEnv("JAVA_HOME", javaHome);
        }
    }
}
