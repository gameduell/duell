package duell.commands;

import duell.helpers.CommandHelper;
import duell.helpers.PathHelper;
import duell.helpers.AskHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellLib;
import duell.objects.DuellConfigJSON;
import haxe.CallStack;
import duell.helpers.LogHelper;
import duell.commands.IGDCommand;

import duell.objects.Arguments;
import haxe.io.Path;
class EnvironmentSetupCommand implements IGDCommand
{

    var setupLib : DuellLib = null;
    var platformName : String;

    public function new()
    {

    }

    public function execute() : String
    {
        try
        {
            LogHelper.info("");
            LogHelper.info("\x1b[2m------");
            LogHelper.info("Setup");
            LogHelper.info("------\x1b[0m");
            LogHelper.info("");

            determinePlatformToSetupFromArguments();

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
            LogHelper.error(error);
        }

        return "success";
    }

    private function determinePlatformToSetupFromArguments()
    {
        platformName = Arguments.getSelectedPlugin();

        var platformNameCorrectnessCheck = ~/^[a-z0-9]+$/;

        if (!platformNameCorrectnessCheck.match(platformName))
            LogHelper.error('Unknown platform $platformName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell setup mac\" or \"duell setup android\"');

        setupLib = DuellLib.getDuellLib("duellsetup" + platformName);

        if (setupLib.isInstalled())
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
        var outputFolder = haxe.io.Path.join([duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
        var outputRun = haxe.io.Path.join(['$outputFolder', 'run.n']);

        var buildArguments = new Array<String>();

        buildArguments.push("-main");
        buildArguments.push("duell.setup.main.SetupMain");

        buildArguments.push("-neko");
        buildArguments.push(outputRun);

        buildArguments.push("-cp");
        buildArguments.push(DuellLib.getDuellLib("duell").getPath());

        buildArguments.push("-cp");
        buildArguments.push(setupLib.getPath());

        buildArguments.push("-D");
        buildArguments.push("plugin");

        buildArguments.push("-resource");
        buildArguments.push(Path.join([DuellLib.getDuellLib("duell").getPath(), Arguments.CONFIG_XML_FILE]) + "@generalArguments");

        PathHelper.mkdir(outputFolder);

        CommandHelper.runHaxe("", buildArguments, {errorMessage: "building the plugin"});

        var runArguments = [outputRun];
        runArguments = runArguments.concat(Arguments.getRawArguments());

        var result = CommandHelper.runNeko("", runArguments, {errorMessage: "running the plugin", exitOnError: false});
        if (result != 0)
            Sys.exit(result);

        LogHelper.println("Saving Setup Done Marker... ");
        var duellConfig = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        if (duellConfig.setupsCompleted.indexOf(platformName) == -1)
        {
            duellConfig.setupsCompleted.push(platformName);
            duellConfig.writeToConfig();
        }
    }

}
