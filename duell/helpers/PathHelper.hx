/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.helpers.PlatformHelper;
import duell.helpers.CommandHelper;
import duell.helpers.LogHelper;
import sys.FileSystem;

import haxe.io.Path;

using StringTools;

class PathHelper
{
	public static function mkdir(directory : String) : Void 
	{
		directory = StringTools.replace(directory, "\\", "/");
		var total = "";
		
		if (!isPathRooted(directory))
		{
			total = Sys.getCwd();
		}
		else
		{
            if(PlatformHelper.hostPlatform != Platform.WINDOWS)
			    total = "/";
		}


        var parts;
        parts = directory.split("/");

		if (PlatformHelper.hostPlatform != Platform.WINDOWS && parts[0] == "~")
		{
			total += getHomeFolder();
			parts.shift();
		}

		if (PlatformHelper.hostPlatform == Platform.WINDOWS && parts[0].length == 2 && parts[0].charAt(1) == ":")
		{
			total += parts.shift();
		}

		var oldPath = "";
		
		for(part in parts) 
		{
			if(part != "." && part != "") 
			{
				total = haxe.io.Path.join([total, part]);
				
				if(!FileSystem.exists(total)) 
				{
					LogHelper.info("", " - \x1b[1mCreating directory:\x1b[0m " + total);
					
					FileSystem.createDirectory(total);
				}
			}
		}
	}

	public static function unescape(path : String) : String 
	{
		path = StringTools.replace(path, "\\ ", " ");
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS && StringTools.startsWith(path, "~/")) 
		{
			path = Path.join([getHomeFolder(), path.substr(2)]);
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
				duell.helpers.LogHelper.error("An error occurred while deleting the directory " + directory);
			}
			
			for (file in FileSystem.readDirectory(directory)) 
			{
				var path = Path.join([directory, file]);
				
				try {

					if (FileSystem.isDirectory(path)) 
					{
						removeDirectory(path);
					} 
					else 
					{
						try 
						{
							FileSystem.deleteFile(path);
						}
						catch (e:Dynamic)
						{
							if (PlatformHelper.hostPlatform == Platform.WINDOWS)
							{
								CommandHelper.runCommand("", "del", [path.replace("/", "\\"), "/f", "/q"]);
							}
							else
							{
								CommandHelper.runCommand("", "rm", ["-f", path]);
							}
						}
					}
				}
				catch (e:Dynamic) 
				{
					duell.helpers.LogHelper.error("An error occurred while deleting the directory " + directory);
				}
			}
			
			LogHelper.info("", " - \x1b[1mRemoving directory:\x1b[0m " + directory);
			
			try 
			{
				FileSystem.deleteDirectory (directory);
			} 
			catch (e:Dynamic) 
			{
				duell.helpers.LogHelper.error("An error occurred while deleting the directory " + directory);
			}
			
		}
		
	}

	/// gathered file list, and prefix are is used in the recursion.
	public static function getRecursiveFileListUnderFolder(folder : String, gatheredFileList : Array<String> = null, prefix : String = "") : Array<String>
	{
		if (gatheredFileList == null)
			gatheredFileList = [];

		var files = [];
		try 
		{
			files = FileSystem.readDirectory(folder);
		} 
		catch (e:Dynamic) 
		{
			LogHelper.error("Could not find folder directory \"" + folder + "\"");
		}
		
		for (file in files) 
		{
			if (file.substr(0, 1) != ".") /// hidden file
			{
				var fullPath = Path.join([folder, file]);
				if (FileSystem.isDirectory(fullPath))
				{
					getRecursiveFileListUnderFolder(fullPath, gatheredFileList, haxe.io.Path.join([prefix, file]));
				} 
				else
				{
					gatheredFileList.push(haxe.io.Path.join([prefix, file]));
				}
			}
		}

		return gatheredFileList;
	}

	public static function getHomeFolder() : String
	{
		var env = Sys.environment();
		if (env.exists ("HOME")) 
		{
			return env.get("HOME");
		} 
		else if(env.exists("USERPROFILE")) 
		{
			return env.get("USERPROFILE");
		} 
		else 
		{	
			throw 'No home variable is set!!';
		}
	}

	public static function isPathRooted(path : String) : Bool
	{
		if (path.charAt(0) == "/" || path.charAt(0) == "\\" || path.charAt(1) == ":")
			return true;

		return false;
	}
}
