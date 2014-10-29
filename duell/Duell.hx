package duell;

import duell.helpers.LogHelper;

import duell.objects.Arguments;

import duell.helpers.DuellConfigHelper;
import duell.objects.DuellConfigJSON;
import duell.helpers.AskHelper;
import duell.objects.DuellLib;

import duell.commands.BuildCommand;
import duell.commands.CreateCommand;
import duell.commands.EnvironmentSetupCommand;
import duell.commands.ToolSetupCommand;



/**
 * @autor kgar
 * @date 24.06.2014.
 * @company Gameduell GmbH
 */
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
        if (!Arguments.validateArguments()) 
            return;

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

        if (isMissingSelfSetup)
        {
            var doSetup = AskHelper.askYesOrNo('You are missing the initial setup. Do you want to do it? ("self_setup" command)');

            if (!doSetup)
            {
                return;
            }
        }


        printBanner();

        if (!isMissingSelfSetup && !Arguments.isSet("-fast") && !Arguments.isSet("-ignoreversioning"))
        {
            var duell = DuellLib.getDuellLib("duell");
            if (duell.isInstalled())
            {
                if (duell.updateNeeded() == true)
                {
                    var answer = AskHelper.askYesOrNo('The library of the duell tool is not up to date on the master branch. Would you like to try to update it?');

                    if(answer)
                    {
                        duell.update();
                    }
                }
            }
        }

        if (isMissingSelfSetup)
        {
            new ToolSetupCommand().execute();
        }
        else
        {
            var currentTime = Date.now().getTime();
            Arguments.getSelectedCommand().commandHandler.execute();
            LogHelper.println(' Time passed '+((Date.now().getTime()-currentTime)/1000)+' sec for command "${Arguments.getSelectedCommand().name}"');
        }
        return;
    }

    private function printBanner()
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
}
