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

		var home = "";
		
		if (env.exists ("HOME")) 
		{
			home = env.get("HOME");
		} 
		else if(env.exists("USERPROFILE")) 
		{
			home = env.get("USERPROFILE");
		} 
		else 
		{	
			return null;
		}
		
		return home + "/.hxcpp_config.xml";
	}
}
