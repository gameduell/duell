package duell.create;

import duell.helpers.LogHelper;

import duell.objects.Arguments;

class CreateMain
{
    public static function main()
    {

        try
        {
            Arguments.validateArguments();
            var pluginLib = new PluginCreate();
            pluginLib.run();
        }
        catch(error : Dynamic)
        {
            LogHelper.info(haxe.CallStack.exceptionStack().join("\n"));
            LogHelper.error(error);
        }

    }
}