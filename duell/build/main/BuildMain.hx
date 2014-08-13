/**
 * @autor rcam
 * @date 05.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.main;


import duell.build.plugin.platform.PlatformBuild;


class BuildMain 
{
    public static function main()
    {
 		var args = Sys.args();

 		var build = new PlatformBuild();
 		build.build(args);
    }

}
