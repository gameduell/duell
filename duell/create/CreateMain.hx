package duell.create;

class CreateMain
{
    public static function main()
    {
        var args = Sys.args();

        var pluginLib = new PluginCreate();
        pluginLib.run(args);
    }
}