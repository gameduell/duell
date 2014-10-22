package duell.create;

import duell.helpers.LogHelper;

class CreateMain
{
    public static function main()
    {
        var args = Sys.args();

        try
        {
            var pluginLib = new PluginCreate();
            pluginLib.run(args);
        }
        catch(error : Dynamic)
        {
            LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
            LogHelper.error(error);
        }

    }
}