/**
 * @autor rcam
 * @date 30.07.2014.
 * @company Gameduell GmbH
 */
 
package duell.helpers;

import sys.FileSystem;

import haxe.io.Path;

class DuellConfigHelper
{
	public static function getDuellConfigFolderLocation() : String
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
		
		return Path.join([home,".duell"]);
	}

	public static function getDuellConfigFileLocation() : String
	{
		return getDuellConfigFolderLocation() + "/config.json";
	}

	public static function checkIfDuellConfigExists() : Bool
	{
		return FileSystem.exists(getDuellConfigFolderLocation()) && 
			   FileSystem.exists(getDuellConfigFileLocation());
	}
}
