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

import duell.helpers.PlatformHelper;
import duell.helpers.CommandHelper;
import duell.helpers.LogHelper;
import duell.objects.DuellProcess;

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

	public static function isLink(path : String) : Bool
	{
		if (PlatformHelper.hostPlatform == Platform.MAC)
		{
			var process = new DuellProcess("", "readlink", [path], {
																		systemCommand: true,
																		block: true,
																		mute: true
																	});
			var output = process.getCompleteStdout().toString();
			if (output == null || output == "")
				return false;
			else
				return true;
		}

		return false;
	}


	public static function removeDirectory(directory : String) : Void
	{
		if (FileSystem.exists(directory))
		{
			if (PlatformHelper.hostPlatform == Platform.WINDOWS)
			{
				python.Syntax.pythonCode("
				import os
				import stat

				for root, dirs, files in os.walk(directory, topdown=False):
					for name in files:
						filename = os.path.join(root, name)
						os.chmod(filename, stat.S_IWUSR)
						os.remove(filename)
					for name in dirs:
						os.rmdir(os.path.join(root, name))
				os.rmdir(directory)");
			}
			else
			{
				python.Syntax.pythonCode("
				import shutil
				shutil.rmtree(directory)");
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
			throw "Could not find folder directory \"" + folder + "\"";
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

    public static function getRecursiveFolderListUnderFolder(folder : String, gatheredFolderList : Array<String> = null, prefix : String = "") : Array<String>
    {
        if (gatheredFolderList == null)
        {
            gatheredFolderList = [];
        }

        var files = [];
        try
        {
            files = FileSystem.readDirectory(folder);
        }
        catch (e:Dynamic)
        {
            throw "Could not find folder directory \"" + folder + "\"";
        }

        for (file in files)
        {
            if (file.substr(0, 1) != ".") /// hidden file
            {
                var fullPath = Path.join([folder, file]);

                if (FileSystem.isDirectory(fullPath))
                {
                    gatheredFolderList.push(haxe.io.Path.join([prefix, file]));
                    getRecursiveFolderListUnderFolder(fullPath, gatheredFolderList, haxe.io.Path.join([prefix, file]));
                }
            }
        }

        return gatheredFolderList;
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
