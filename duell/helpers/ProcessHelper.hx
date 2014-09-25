/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.helpers.PlatformHelper;
import duell.helpers.PathHelper;

import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.io.Path;
import sys.io.Process;
import sys.FileSystem;
import neko.Lib;


class ProcessHelper 
{
	public static var processorCores(get_processorCores, null) : Int;
	
	private static var _processorCores : Int = 0;
	
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
 	public static function startBlockingProcess(process : Process) : Void 
 	{
 		if(process == null)
 			return;
 			
 			var buffer = new BytesOutput ();
			var waiting = true;
			while (waiting) {
				
				try  {
					var current = process.stdout.readAll (1024);
					buffer.write (current);
					
					if (current.length == 0) 
					{						
						waiting = false;
					}
					
				} catch (e:Eof) 
				{					
					waiting = false;
				}
				
			}
			var result : Int = process.exitCode ();
			process.close();
 	}
	public static function runCommand(path : String, command : String, args : Array <String>, safeExecute : Bool = true, ignoreErrors : Bool = false, print : Bool = false, commandIsLocal : Bool : true) : Int 
	{
		if(print) 
		{
			var message = command;
			
			for(arg in args) 
			{
				if(arg.indexOf(" ") > -1) 
				{
					message += " \"" + arg + "\"";
				} 
				else 
				{
					message += " " + arg;
				}
			}
			Sys.println(message);
		}
		
		command = PathHelper.escape(command);

		if(commandIsLocal)
		{
			if(PlatformHelper.hostPlatform != Platform.WINDOWS)
			{
				commandIsLocal = "./" + command;
			}

		}

		if(safeExecute) 
		{
			if(path != null && path != "" && !FileSystem.exists(FileSystem.fullPath (path)) && !FileSystem.exists(FileSystem.fullPath(new Path(path).dir))) 
			{
				LogHelper.error ("The specified target path \"" + path + "\" does not exist");
				return 1;
			}
			try {
				
				return _runCommand(path, command, args);
				
			} 
			catch (e:Dynamic) {

				if(!ignoreErrors) 
				{
					LogHelper.error("", e);
					return 1;
				}
				
				return 0;
			}
		} 
		else 
		{
			return _runCommand(path, command, args);
		}
		
	}
	
	
	private static function _runCommand(path : String, command : String, args : Array<String>) : Int {
		
		var oldPath = "";
		
		if(path != null && path != "") 
		{
			LogHelper.info("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");
			
			oldPath = Sys.getCwd ();
			Sys.setCwd (path);
		}
		
		var argString = "";
		
		for (arg in args) 
		{
			if(arg.indexOf (" ") > -1) 
			{
				argString += " \"" + arg + "\"";
			} 
			else 
			{
				argString += " " + arg;
			}
			
		}
		
		LogHelper.info ("", " - \x1b[1mRunning command:\x1b[0m " + command + argString);
		
		var result = 0;
		
		if(args != null && args.length > 0) 
		{
			result = Sys.command (command, args);
		}
		else 
		{
			result = Sys.command (command);
		}
		
		if (oldPath != "") 
		{
			Sys.setCwd (oldPath);
		}
		
		if (result != 0) 
		{
			throw ("Error running: " + command + " " + args.join (" ") + " [" + path + "]");
		}
		
		return result;
	}
	
	
	public static function runProcess(path : String, command : String, args : Array <String>, waitForOutput : Bool = true, safeExecute : Bool = true, ignoreErrors : Bool = false, print : Bool = false, commandIsLocal : Bool : true) : String {
		
		if (print) 
		{
			var message = command;
			
			for (arg in args) 
			{
				if (arg.indexOf (" ") > -1) 
				{
					message += " \"" + arg + "\"";
				} 
				else 
				{
					message += " " + arg;
				}
			}
			
			Sys.println (message);
			
		}
		
		command = PathHelper.escape(command);


		if(commandIsLocal)
		{
			if(PlatformHelper.hostPlatform != Platform.WINDOWS)
			{
				commandIsLocal = "./" + command;
			}

		}
		
		if(safeExecute) 
		{
			try {
				
				if(path != null && path != "" && !FileSystem.exists(FileSystem.fullPath (path)) && !FileSystem.exists(FileSystem.fullPath (new Path(path).dir))) 
				{
					LogHelper.error("The specified target path \"" + path + "\" does not exist");
				}
				
				return _runProcess(path, command, args, waitForOutput, ignoreErrors);
				
			} catch (e:Dynamic) {
				
				if(!ignoreErrors) 
				{
					
					LogHelper.error ("", e);
					
				}
				
				return null;
				
			}
			
		} else {
			
			return _runProcess (path, command, args, waitForOutput, ignoreErrors);
			
		}
		
	}
	
	
	private static function _runProcess (path:String, command:String, args:Array<String>, waitForOutput:Bool, ignoreErrors:Bool):String {
		
		var oldPath:String = "";
		if (path != null && path != "") {
			
			LogHelper.info ("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");
			
			oldPath = Sys.getCwd ();
			Sys.setCwd (path);
			
		}
		
		var argString = "";
		
		for (arg in args) {
			
			if (arg.indexOf (" ") > -1) {
				
				argString += " \"" + arg + "\"";
				
			} else {
				
				argString += " " + arg;
				
			}
			
		}
		LogHelper.info ("", " - \x1b[1mRunning process:\x1b[0m " + command + argString);
		
		var output = "";
		var result = 0;
		
		var process = new Process (command, args);
		var buffer = new BytesOutput ();
		
		if (waitForOutput) {
			
			var waiting = true;
			
			while (waiting) {
				
				try  {
					var current = process.stdout.readAll (1024);
					buffer.write (current);
					
					if (current.length == 0) {
						
						waiting = false;
						
					}
					
				} catch (e:Eof) {
					
					waiting = false;
					
				}
				
			}
			
			result = process.exitCode ();
			process.close();
			
			//if (result == 0) {
				
				output = buffer.getBytes ().toString ();
				
				if (output == "") {
					
					var error = process.stderr.readAll ().toString ();
					
					if (ignoreErrors) {
						
						output = error;
						
					} else {
						
						LogHelper.error (error);
						
					}
					
					return null;
					
					/*if (error != "") {
						
						LogHelper.error (error);
						
					}*/
					
				}
				
			//}
			
		}
		
		if (oldPath != "") {
			
			Sys.setCwd (oldPath);
			
		}
		
		return output;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	public static function get_processorCores ():Int {
		
		if (_processorCores < 1) {
			
			var result = null;
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				var env = Sys.getEnv ("NUMBER_OF_PROCESSORS");
				
				if (env != null) {
					
					result = env;
					
				}
				
			} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
				
				result = runProcess ("", "nproc", [], true, true, true);
				
				if (result == null) {
					
					var cpuinfo = runProcess ("", "cat", [ "/proc/cpuinfo" ], true, true, true);
					
					if (cpuinfo != null) {
						
						var split = cpuinfo.split ("processor");
						result = Std.string (split.length - 1);
						
					}
					
				}
				
			} else if (PlatformHelper.hostPlatform == Platform.MAC) {
				
				var cores = ~/Total Number of Cores: (\d+)/;
				var output = runProcess ("", "/usr/sbin/system_profiler", [ "-detailLevel", "full", "SPHardwareDataType" ]);
				
				if (cores.match (output)) {
					
					result = cores.matched (1);
					
				}
				
			}
			
			if (result == null || Std.parseInt (result) < 1) {
				
				_processorCores = 1;
				
			} else {
				
				_processorCores = Std.parseInt (result);
				
			}
			
		}
		
		return _processorCores;
		
	}

	private static function runInstallerWindows(path : String, message : String) : Void
	{
			try {
				Lib.println(message);
				ProcessHelper.runCommand("", "call", [path], false);
				Lib.println("Done");
			} catch (e:Dynamic) {}
	}

	private static function runInstallerLinux(path : String, message : String) : Void
	{
		if(Path.extension(path) == "deb") 
		{
			ProcessHelper.runCommand("", "sudo", ["dpkg", "-i", "--force-architecture", path], false);
		} 
		else 
		{
			Lib.println(message);
			Sys.command("chmod", ["755", path]);
			
			ProcessHelper.runCommand(Path.directory(path), Path.withoutDirectory(path), [], false);
			Lib.println ("Done");
		}
	}

	private static function runInstallerMac(path : String, message : String) : Void
	{	
		if(Path.extension(path) == "") 
		{
			Lib.println(message);
			Sys.command("chmod", ["755", path]);
			ProcessHelper.runCommand ("", path, [], false);
			Lib.println("Done");
		} 
		else if (Path.extension (path) == "dmg") 
		{
			var process = new Process("hdiutil", ["mount", path]);
			var ret = process.stdout.readAll().toString();
			process.exitCode(); //you need this to wait till the process is closed!
			process.close();
			
			var volumePath = "";
			
			if (ret != null && ret != "") 
			{	
				volumePath = StringTools.trim (ret.substr (ret.indexOf ("/Volumes")));
			}
			
			if (volumePath != "" && FileSystem.exists(volumePath)) 
			{
				var apps = [];
				var packages = [];
				var executables = [];
				
				var files:Array <String> = FileSystem.readDirectory(volumePath);
				
				for (file in files) 
				{
					switch (Path.extension(file)) 
					{
						case "app":
							apps.push(file);
						case "pkg", "mpkg":
							packages.push(file);
						case "bin":
							executables.push(file);
					}
				}
				
				var file = "";
				
				if(apps.length == 1) 
				{
					file = apps[0];
				} 
				else if(packages.length == 1) 
				{
					file = packages[0];
				} 
				else if(executables.length == 1) 
				{
					file = executables[0];
				}
				
				if(file != "") 
				{
					Lib.println(message);
					ProcessHelper.runCommand ("", "open", ["-W", volumePath + "/" + file], false);
					Lib.println("Done");
				}
				
				try {
					var process = new Process("hdiutil", [ "unmount", path ]);
					process.exitCode(); //you need this to wait till the process is closed!
					process.close();
				} 
				catch (e:Dynamic) {
				
				}
				
				if (file == "") 
				{
					
					ProcessHelper.runCommand ("", "open", [ path ], false);
					
				}
				
			} else {
				
				ProcessHelper.runCommand ("", "open", [ path ], false);
				
			}
			
		} else {
			
			ProcessHelper.runCommand ("", "open", [ path ], false);
			
		}
	}


	public static function runInstaller(path : String, message : String = "Waiting for process to complete...") : Void 
	{
		if(PlatformHelper.hostPlatform == Platform.WINDOWS) 
		{
			runInstallerWindows(path, message);
		} 
		else if(PlatformHelper.hostPlatform == Platform.LINUX) 
		{
			runInstallerLinux(path, message);
		} 
		else /// MAC
		{
			runInstallerMac(path, message);
		}
	}
	
}