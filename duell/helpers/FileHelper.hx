/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.helpers;


import sys.FileSystem;

import haxe.io.Path;
import sys.io.File;

import duell.helpers.PlatformHelper;

import duell.helpers.CommandHelper;

class FileHelper
{
	private static var binaryExtensions = [ "jpg", "jpeg", "png", "exe", "gif", "ini", "zip", "tar", "gz", "fla", "swf" ];
	private static var textExtensions = [ "xml", "java", "hx", "hxml", "html", "ini", "gpe", "pch", "pbxproj", "plist", "json", "cpp", "mm", "properties", "hxproj", "nmml", "lime" ];

	public static function isNewer(source:String, destination:String) : Bool
	{
		if (source == null || !FileSystem.exists(source))
		{
			throw "Source path \"" + source + "\" does not exist";
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
					throw "Cannot copy to \"" + destination + "\", is the file in use?";
					return;
				}
			} catch (e:Dynamic) {}

			throw "Cannot open \"" + destination + "\" for writing, do you have correct access permissions?";
		}
	}
	public static function getAllFilesInDir(source:String):Array<String>
	{
	    var files:Array <String> = null;
		var retFiles: Array<String> = [];
		try
		{
			files = FileSystem.readDirectory(source);
		}
		catch (e:Dynamic)
		{
			throw "Could not find source directory \"" + source + "\"";
		}

		for (file in files)
		{
			if (file != "." && file != "..")
			{
				var itemSource:String = source + "/" + file;

				if (FileSystem.isDirectory(itemSource))
				{
					getAllFilesInDir(itemSource);
				}
				else
				{
					retFiles.push(itemSource);
				}
			}
		}
		return retFiles;

	}

	public static function recursiveCopyFiles(source:String, destination:String, onlyIfNewer: Bool = true, purgeDestination: Bool = false)
	{
		PathHelper.mkdir(destination);

		if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
			var purgeArg = purgeDestination ? "/MIR": "/E";
			CommandHelper.runCommand("", "robocopy", ["/DCOPY:DAT", "/COPY:DAT", "/NJH", "/NJS", purgeArg, source, destination], {systemCommand: true, nonErrorExitCodes: [0, 1]});
		}
		else
		{
			if (purgeDestination)
			{
				CommandHelper.runCommand("", "cp", ["-pR", source, destination], {systemCommand: true});
			}
			else
			{
				/// not using cp because cp removes files
				var files:Array <String> = null;

				try
				{
					files = FileSystem.readDirectory(source);
				}
				catch (e:Dynamic)
				{
					throw "Could not find source directory \"" + source + "\"";
				}

				for (file in files)
				{
					if (file != "." && file != "..")
					{
						var itemDestination:String = destination + "/" + file;
						var itemSource:String = source + "/" + file;

						if (FileSystem.isDirectory(itemSource))
						{
							recursiveCopyFiles(itemSource, itemDestination, onlyIfNewer);
						}
						else
						{
							if (!onlyIfNewer || FileHelper.isNewer(itemSource, itemDestination))
							{
								CommandHelper.runCommand("", "cp", ["-p", itemSource, itemDestination], {systemCommand: true});
							}
						}
					}
				}
			}
		}
	}
}
