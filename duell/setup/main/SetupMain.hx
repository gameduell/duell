package duell.setup.main;

import duell.setup.plugin.EnvironmentSetup;

class SetupMain
{
    public static function main()
    {
        var args = Sys.args();

        var environment = new EnvironmentSetup();
        environment.setup(args);
    }

}
