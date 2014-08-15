/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
 
package duell.helpers;

class HXCPPConfigXMLHelper
{
	public static function getProbableHXCPPConfigLocation() : String
	{
		var env = Sys.environment();

		var home = duell.helpers.PathHelper.getHomeFolder();

		return home + "/.hxcpp_config.xml";
	}
}
