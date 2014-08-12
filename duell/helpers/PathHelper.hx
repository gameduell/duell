/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.helpers.PlatformHelper;
import sys.FileSystem;

class PathHelper
{
	public static function mkdir(directory : String) : Void 
	{
		directory = StringTools.replace(directory, "\\", "/");
		var total = "";
		
		if (directory.substr (0, 1) == "/") 
		{
			total = "/";
		}
		
		var parts = directory.split("/");
		var oldPath = "";
		
		if(parts.length > 0 && parts[0].indexOf(":") > -1) 
		{
			oldPath = Sys.getCwd();
			Sys.setCwd(parts[0] + "\\");
			parts.shift();
		}
		
		for(part in parts) 
		{
			if(part != "." && part != "") 
			{
				if(total != "" && total != "/") 
				{
					total += "/";
				}
				
				total += part;
				
				if(!FileSystem.exists(total)) 
				{
					LogHelper.info("", " - \x1b[1mCreating directory:\x1b[0m " + total);
					
					FileSystem.createDirectory (total);
				}
			}
		}
		
		if (oldPath != "") 
		{
			Sys.setCwd (oldPath);
		}
	}

	public static function unescape(path : String) : String 
	{
		path = StringTools.replace(path, "\\ ", " ");
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS && StringTools.startsWith(path, "~/")) 
		{
			path = Sys.getEnv ("HOME") + "/" + path.substr(2);
		}
		
		return path;
	}
	
	public static function escape(path : String) : String 
	{
		if(PlatformHelper.hostPlatform != Platform.WINDOWS) 
		{
			path = StringTools.replace (path, "\\ ", " ");
			path = StringTools.replace (path, " ", "\\ ");
			path = StringTools.replace (path, "\\'", "'");
			path = StringTools.replace (path, "'", "\\'");
		} 
		else 
		{
			path = StringTools.replace (path, "^,", ",");
			path = StringTools.replace (path, ",", "^,");
		}
		
		return expand(path);
	}

	public static function expand(path : String) : String 
	{
		if(path == null) 
		{
			path = "";
		}
		
		if(PlatformHelper.hostPlatform != Platform.WINDOWS) 
		{
			if(StringTools.startsWith(path, "~/")) 
			{
				path = Sys.getEnv("HOME") + "/" + path.substr(2);
			}
		}
		
		return path;
	}
	
	public static function stripQuotes(path : String) : String 
	{
		if (path != null) 
		{
			return path.split ("\"").join ("");
		}
		
		return path;
	}	
	public static function removeDirectory(directory : String) : Void 
	{
		if (FileSystem.exists(directory)) 
		{
			var files;
			try 
			{
				files = FileSystem.readDirectory(directory);
			} 
			catch(e : Dynamic) 
			{
				return;
			}
			
			for (file in FileSystem.readDirectory(directory)) 
			{
				var path = directory + "/" + file;
				
				try 
				{
					if (FileSystem.isDirectory(path)) 
					{
						removeDirectory (path);
					} 
					else 
					{
						FileSystem.deleteFile (path);
					}
				} 
				catch (e:Dynamic) {}
			}
			
			LogHelper.info("", " - \x1b[1mRemoving directory:\x1b[0m " + directory);
			
			try 
			{
				FileSystem.deleteDirectory (directory);
			} 
			catch (e:Dynamic) {}
			
		}
		
	}

	public static function isPathRooted(path : String) : Bool
	{
		if (path.charAt(0) == "/" || path.charAt(0) == "\\" || path.charAt(1) == ":")
			return true;

		return false;
	}
}
