package duell.commands.setup;

import duell.helpers.ProcessHelper;
import duell.helpers.PathHelper;
import duell.helpers.AskHelper;
import duell.objects.DuellLib;
import haxe.CallStack;
import duell.helpers.LogHelper;
import duell.commands.IGDCommand;

class EnvironmentSetupCommand implements IGDCommand
{
    public static var helpString : String = '   \x1b[1msetup <platform>\x1b[0m\n' +
                                            '\n' +
                                            'Setup for the specified environment.\n' +
                                            '(mac, android, flash)\n';

    var setupLib : DuellLib = null;
    var arguments : Array<String>;

    public function new()
    {

    }

    public function execute(cmdStr : String, args : Array<String>) : String
    {
        arguments = args;

        try
        {
            LogHelper.info("");
            LogHelper.info("\x1b[2m------");
            LogHelper.info("Setup");
            LogHelper.info("------\x1b[0m");
            LogHelper.info("");

            determinePlatformToSetupForFromArguments(args);

            LogHelper.println("");

            buildNewEnvironmentWithSetupLib();

            LogHelper.println("");
            LogHelper.info("\x1b[2m------");
            LogHelper.info("end");
            LogHelper.info("------\x1b[0m");
        }
        catch(error : Dynamic)
        {
            LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
            LogHelper.error("An error occurred. Error: " + error);
        }

        return "success";
    }

    private function determinePlatformToSetupForFromArguments(args : Array<String>)
    {
        if (args.length == 0)
        {
            LogHelper.error("Please specify a platform as a parameter. \"duell setup <platform>\". (android, flash, mac)");
        }

        var platformName = args[0].toLowerCase();

        var platformNameCorrectnessCheck = ~/^[a-z0-9]+$/;

        if (!platformNameCorrectnessCheck.match(platformName))
            LogHelper.error('Unknown platform $platformName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell setup mac\" or \"duell setup android\"');

        setupLib = DuellLib.getDuellLib("duellsetup" + platformName);

        if (setupLib.exists())
        {
            if (setupLib.updateNeeded() == true)
            {
                var answer = AskHelper.askYesOrNo('The library of $platformName environment is not up to date on the master branch. Would you like to try to update it?');

                if(answer)
                {
                    setupLib.update();
                }
            }
            else
            {
                LogHelper.info("","No update needed");
            }
        }
        else
        {
            var answer = AskHelper.askYesOrNo('A library for setup of $platformName environment is not currently installed. Would you like to try to install it?');

            if(answer)
            {
                setupLib.install();
            }
            else
            {
                LogHelper.println('Rerun with the library "duellsetup$platformName" installed');
                Sys.exit(0);
            }
        }
    }

    private function buildNewEnvironmentWithSetupLib()
    {
        var outputFolder = ".setupEnvironment";

        var buildArguments = new Array<String>();

        buildArguments.push("-main");
        buildArguments.push("duell.setup.main.SetupMain");

        buildArguments.push("-neko");
        buildArguments.push('$outputFolder/environmenttool/run.n');

        buildArguments.push("-cp");
        buildArguments.push(DuellLib.getDuellLib("duell").getPath());

        buildArguments.push("-cp");
        buildArguments.push(setupLib.getPath());

        PathHelper.mkdir('$outputFolder/environmenttool');

        var result = duell.helpers.ProcessHelper.runCommand("", "haxe", buildArguments);

        if (result != 0)
            LogHelper.error("An error occured while compiling the environment tool");

        var runArguments = ['$outputFolder/environmenttool/run.n'];
        runArguments.concat(arguments);

        result = duell.helpers.ProcessHelper.runCommand("", "neko", runArguments);

        if (result != 0)
            LogHelper.error("An error occured while running the environment tool");
    }

}
