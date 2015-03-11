/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.helpers.PlatformHelper;
import duell.helpers.LogHelper;
import duell.helpers.DuellConfigHelper;

import duell.objects.DuellProcess;

import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.io.Path;
import sys.io.Process;
import sys.FileSystem;
import sys.io.FileOutput;
import sys.io.File;
import neko.Lib;

using StringTools;

typedef CommandOptions = 
{
	?logOnlyIfVerbose : Bool, /// defaults to true
	?systemCommand : Bool, /// defaults to true
	?exitOnError : Bool, /// defaults to true
	?errorMessage : String /// defaults to nothing
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
		else 
		{
			result = runCommand ("", "/usr/bin/xdg-open", [url, "&"]);
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
				LogHelper.error("The path \"" + path + "\" does not exist");
				return 1;
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

		if (result != 0 && exitOnError)
		{
			var pathString = path != null && path != "" ? " - in path: " + path : "";
			var additionalMessage = errorMessage != null ? " - Action was: " + errorMessage : "";
			LogHelper.error("Failed to run command " + LogHelper.BOLD + commandString + LogHelper.NORMAL + " " + pathString + " -  Exit code:" + result + additionalMessage);
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
            // case Platform.WINDOWS: Path.join([javaHome, "bin", "java.exe"]);
            case _: "java";
        };

        return CommandHelper.runCommand(path, javaBinaryPath, args, options);
    }
}