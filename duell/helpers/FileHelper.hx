/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;


import sys.FileSystem;

import haxe.io.Path;
import sys.io.File;

class FileHelper
{
	private static var binaryExtensions = [ "jpg", "jpeg", "png", "exe", "gif", "ini", "zip", "tar", "gz", "fla", "swf" ];
	private static var textExtensions = [ "xml", "java", "hx", "hxml", "html", "ini", "gpe", "pch", "pbxproj", "plist", "json", "cpp", "mm", "properties", "hxproj", "nmml", "lime" ];

	public static function isNewer(source:String, destination:String) : Bool 
	{
		if (source == null || !FileSystem.exists(source)) 
		{
			LogHelper.error("Source path \"" + source + "\" does not exist");
		}
		
		if (FileSystem.exists(destination)) 
		{
			if (FileSystem.stat(source).mtime.getTime () < FileSystem.stat(destination).mtime.getTime ()) 
			{
				return false;
			}
		}
		return true;
	}
	
	public static function isText (source:String):Bool 
	{
		if(!FileSystem.exists(source)) 
		{
			return false;
		}

		var input = File.read(source, true);
		
		var numChars = 0;
		var numBytes = 0;
		
		try 
		{
			while (numBytes < 512) 
			{
				var byte = input.readByte();
				numBytes++;
				
				if (byte == 0) 
				{
					input.close();
					return false;
				}
				
				if ((byte > 8 && byte < 16) || (byte >= 32 && byte < 256) || byte > 287) 
				{
					numChars++;
				}
			}
		} catch (e:Dynamic) { }
		
		input.close ();
		
		if (numBytes == 0 || (numChars / numBytes) > 0.7) 
		{
			return true;
		}
		
		return false;
	}

	public static function copyIfNewer(source:String, destination:String) : Void
	{      
		if(!isNewer(source, destination)) 
		{
			return;
		}
		
		PathHelper.mkdir(Path.directory(destination));
		
		LogHelper.info ("", " - \x1b[1mCopying file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);
		
		try 
		{
			File.copy(source, destination);
		} 
		catch (e:Dynamic) {
			
			try 
			{
				if(FileSystem.exists(destination)) 
				{
					LogHelper.error ("Cannot copy to \"" + destination + "\", is the file in use?");
					return;
				}
			} catch (e:Dynamic) {}
			
			LogHelper.error ("Cannot open \"" + destination + "\" for writing, do you have correct access permissions?");
		}
	}
}
