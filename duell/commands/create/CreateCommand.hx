package duell.commands.create;

import duell.helpers.ProcessHelper;
import duell.helpers.PathHelper;
import duell.helpers.AskHelper;
import duell.objects.DuellLib;
import haxe.CallStack;
import duell.helpers.LogHelper;
import duell.commands.IGDCommand;

class CreateCommand implements IGDCommand
{
    public static var helpString : String = '   \x1b[1mcreate <plugin_name>\x1b[0m\n' +
                                            '\n' +
                                            'Generic running of plugins from duell libs. \n' +
                                            'Can be used for creating a default project in current folder like: duell create emptyProject . \n';

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
            LogHelper.info("Create");
            LogHelper.info("------\x1b[0m");
            LogHelper.info("");

            determineDuellLibraryFromArguments(args);

            LogHelper.println("");

            runPluginLib();

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

    private function determineDuellLibraryFromArguments(args : Array<String>)
    {
        if (args.length == 0)
        {
            LogHelper.error("Please specify a plugin as a parameter. \"duell create <plugin_name>\". (helloWorld, emptyProject, help, ...)");
        }

        var pluginName = args[0];

        var pluginNameCorrectnessCheck = ~/^[A-Za-z0-9]+$/;

        if (!pluginNameCorrectnessCheck.match(pluginName))
            LogHelper.error('Unknown plugin $pluginName, should be composed of only letters or numbers, no spaces of other characters. Example: \"duell create emptyProject\" or \"duell create helloWorld\"');

        setupLib = DuellLib.getDuellLib("duellcreate" + pluginName);

        if (setupLib.exists())
        {
            if (setupLib.updateNeeded() == true)
            {
                var answer = AskHelper.askYesOrNo('The plugin with name $pluginName is not up to date on the master branch. Would you like to try to update it?');

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
            var answer = AskHelper.askYesOrNo('The plugin of name $pluginName is not currently installed. Would you like to try to install it?');

            if(answer)
            {
                setupLib.install();
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
        var outputRun = haxe.io.Path.join(['$outputFolder', 'run.n']);

        var buildArguments = new Array<String>();

        buildArguments.push("-main");
        buildArguments.push("duell.create.CreateMain");

        buildArguments.push("-neko");
        buildArguments.push(outputRun);

        buildArguments.push("-cp");
        buildArguments.push(DuellLib.getDuellLib("duell").getPath());

        buildArguments.push("-cp");
        buildArguments.push(setupLib.getPath());

        PathHelper.mkdir(outputFolder);

        var result = duell.helpers.ProcessHelper.runCommand("", "haxe", buildArguments);

        if (result != 0)
            LogHelper.error("An error occured while compiling the plugin");

        var runArguments = [outputRun];
        runArguments.concat(arguments);

        result = duell.helpers.ProcessHelper.runCommand("", "neko", runArguments);

        if (result != 0)
            LogHelper.error("An error occured while running the plugin");
    }

}
