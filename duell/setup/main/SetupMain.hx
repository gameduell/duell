package duell.setup.main;

import duell.setup.plugin.EnvironmentSetup;

class SetupMain
{
    public static function main()
    {
    	duell.objects.Arguments.validateArguments();

        var environment = new EnvironmentSetup();
        environment.setup();
    }

}
