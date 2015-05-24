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
import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.FileOutput;
import sys.io.File;

using StringTools;

typedef CommandOptions =
{
	?logOnlyIfVerbose : Bool, /// defaults to true
	?systemCommand : Bool, /// defaults to true
	?exitOnError : Bool, /// defaults to true
	?errorMessage : String, /// defaults to nothing
	?nonErrorExitCodes : Array<Int> /// defaults to nothing
}

class CommandHelper
{
	public static function openFile(workingDirectory : String, targetPath : String, executable : String = "") : Void
	{
		if(executable == null)
		{
			executable = "";
		}

		if(PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
			if (executable == "")
			{
				if(targetPath.indexOf(":\\") == -1)
				{
					runCommand(workingDirectory, targetPath, []);
				}
				else
				{
					runCommand(workingDirectory, ".\\" + targetPath, []);
				}

			}
			else
			{
				if(targetPath.indexOf (":\\") == -1)
				{
					runCommand(workingDirectory, executable, [targetPath]);
				}
				else
				{
					runCommand(workingDirectory, executable, [".\\" + targetPath]);
				}
			}
		}
		else if(PlatformHelper.hostPlatform == Platform.MAC)
		{
			if(executable == "")
			{
				executable = "/usr/bin/open";
			}

			if(targetPath.substr (0, 1) == "/")
			{
				runCommand(workingDirectory, executable, [targetPath]);
			}
			else
			{
				runCommand(workingDirectory, executable, ["./" + targetPath]);
			}
		}
		else
		{
			if(executable == "")
			{
				executable = "/usr/bin/xdg-open";
			}

			if (targetPath.substr(0, 1) == "/")
			{
				runCommand(workingDirectory, executable, [ targetPath ]);
			}
			else
			{
				runCommand(workingDirectory, executable, [ "./" + targetPath ]);
			}
		}
	}

	public static function openURL(url : String) : Int
	{
		var result : Int = 0;
		if(PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
			result = runCommand ("", "start", [url]);
		}
		else if (PlatformHelper.hostPlatform == Platform.MAC)
		{
			result = runCommand ("", "/usr/bin/open", [url]);
		}
		else if (PlatformHelper.hostPlatform == Platform.LINUX)
		{
			result = runCommand ("", "/usr/bin/xdg-open", [url]);
		} else {
			throw "Unknown platform, cannot start browser";
		}
		return result;
	}

	public static function runCommand(path : String, command : String, args : Array <String>, ?options: CommandOptions) : Int
	{
		command = PathHelper.escape(command);

		var argString = "";

		for (arg in args)
		{
			if (arg.indexOf (" ") > -1)
			{
				argString += " \"" + arg + "\"";
			}
			else
			{
				argString += " " + arg;
			}
		}

		var commandString = command + argString;

		var systemCommand = options != null && options.systemCommand != null ? options.systemCommand : true;
		var logOnlyIfVerbose = options != null && options.logOnlyIfVerbose != null ? options.logOnlyIfVerbose : true;
		var exitOnError = options != null && options.exitOnError != null ? options.exitOnError : true;
		var errorMessage = options != null && options.errorMessage != null ? options.errorMessage : null;
		var nonErrorExitCodes = options != null && options.nonErrorExitCodes != null ? options.nonErrorExitCodes : [0];

		var message = " - Running command: " + LogHelper.BOLD + commandString + LogHelper.NORMAL + (path != null && path != "" ? " - in path: " + path : "");

		if (logOnlyIfVerbose)
		{
			LogHelper.info("", message);
		}
		else
		{
			LogHelper.info(message, "");
		}

		/// CHECK FOR LOCAL COMMAND
		if (!systemCommand && PlatformHelper.hostPlatform != Platform.WINDOWS)
		{
			command = "./" + command;
		}

		/// CHANGE DIRECTORY
		var oldPath:String = "";
		if (path != null && path != "") {

			LogHelper.info ("", " - " + LogHelper.BOLD + "Changing directory: " + LogHelper.NORMAL + path + "");

			if(!FileSystem.exists(path))
			{
				throw "The path \"" + path + "\" does not exist";
			}
			oldPath = Sys.getCwd ();
			Sys.setCwd (path);
		}

		/// RUN COMMAND
		var result = 0;

		if(args != null && args.length > 0)
		{
			result = Sys.command (command, args);
		}
		else
		{
			result = Sys.command (command);
		}

		if (nonErrorExitCodes.indexOf(result) == -1 && exitOnError)
		{
			var pathString = path != null && path != "" ? " - in path: " + path : "";
			var additionalMessage = errorMessage != null ? " - Action was: " + errorMessage : "";
			throw "Failed to run command " + LogHelper.BOLD + commandString + LogHelper.NORMAL + " " + pathString + " -  Exit code:" + result + additionalMessage;
		}

		/// RESET WORKING DIRECTORY
		if (oldPath != "")
		{
			Sys.setCwd (oldPath);
		}

		return result;
	}

	public static function runNeko(path: String, args : Array <String>, ?options: CommandOptions) : Int
	{
    	var haxePath = Sys.getEnv("NEKO_INSTPATH");
    	if (options == null)
    	{
    		options = {systemCommand: true};
    	}
    	else
    	{
    		options.systemCommand = true;
    	}
		return CommandHelper.runCommand(path, Path.join([haxePath, "neko"]), args, options);
	}

	public static function runHaxe(path: String, args : Array <String>, ?options: CommandOptions) : Int
	{
    	var haxePath = Sys.getEnv("HAXEPATH");
    	if (options == null)
    	{
    		options = {systemCommand: true};
    	}
    	else
    	{
    		options.systemCommand = true;
    	}

    	if (FileSystem.exists(duell.helpers.DuellConfigHelper.getDuellConfigFolderLocation()))
    	{
			var outputFolder = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"]);
			var outputFile = Path.join([outputFolder, "commandHelperHaxeExec.hxml"]);

			var file: FileOutput = File.write(outputFile, true);
			file.writeString(args.join("\n"));
			file.close();

			return CommandHelper.runCommand(path, Path.join([haxePath, "haxe"]), [outputFile], options);
    	}
    	else
    	{
			return CommandHelper.runCommand(path, Path.join([haxePath, "haxe"]), args, options);
    	}
	}

	public static function runHaxelib(path: String, args : Array <String>, ?options: CommandOptions) : Int
	{
    	var haxePath = Sys.getEnv("HAXEPATH");
    	if (options == null)
    	{
    		options = {systemCommand: true};
    	}
    	else
    	{
    		options.systemCommand = true;
    	}
		return CommandHelper.runCommand(path, Path.join([haxePath, "haxelib"]), args, options);
	}

    public static function runJava(path: String, args: Array <String>, ?options: CommandOptions): Int
    {
        var javaHome: String = Sys.getEnv("JAVA_HOME");

        var javaBinaryPath: String = switch (PlatformHelper.hostPlatform)
        {
            case Platform.MAC: Path.join([javaHome, "bin", "java"]);
            case Platform.WINDOWS: Path.join([javaHome, "bin", "java.exe"]);
            case _: "java";
        };

        return CommandHelper.runCommand(path, javaBinaryPath, args, options);
    }
}
