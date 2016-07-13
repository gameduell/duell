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

package duell.objects;

import Array;
import haxe.io.Path;
import duell.helpers.PathHelper;
import duell.helpers.FileHelper;
import duell.helpers.ConnectionHelper;
import duell.helpers.LogHelper;
import duell.objects.DuellProcess;
import duell.helpers.GitHelper;
import duell.helpers.DuellConfigHelper;

import sys.FileSystem;

using StringTools;

class Haxelib
{
	public var name(default, null) : String;
	public var version(default, null) : String;
	private var path : String = null; ///use getters

	private function new(name : String, version : String = "")
	{
		this.name = name;

		if (version == null)
			version = "";
		this.version = version;
	}

	public static var haxelibCache : Map<String, Map<String, Haxelib> > = new Map<String, Map<String, Haxelib> >();
	public static function getHaxelib(name : String, version : String = "")
	{
		///add to the cache if it is not there
		if (haxelibCache.exists(name))
		{
			var versionMap = haxelibCache.get(name);
			if (!versionMap.exists(version))
			{
				versionMap.set(version, new Haxelib(name, version));
			}
		}
		else
		{
			var versionMap = new Map<String, Haxelib>();
			versionMap.set(version, new Haxelib(name, version));
			haxelibCache.set(name, versionMap);
		}

		///retrieve from the cache
		return haxelibCache.get(name).get(version);
	}

	public function setPath(path : String)
	{
		this.path = path;
	}

	// Checks the existence of the wanted version
	public function exists()
	{
		if (isHaxelibInstalled())
		{
			if (version == "") return true;

			if (isGitVersion()) return true;

			var haxelibListOutput = getHaxelibListOutput();

			var haxelibListOutputSplit = haxelibListOutput.split("\n");
			var haxelibLine = null;
			for (line in haxelibListOutputSplit)
			{
				if (line.startsWith(name))
				{
					haxelibLine = line;
				}
			}

			if (haxelibLine == null)
			{
				throw "Incorrect haxelib list state, couldn't find lib " + name + ".";
			}

			var splitLine = haxelibLine.split(" ");

			for (element in splitLine)
			{
				if (element.indexOf(version) != -1)
				{
					return true;
				}
			}
		}

		return false;
	}

	private function isHaxelibInstalled()
	{
		var output = getHaxelibPathOutput();

		if(output.indexOf("is not installed") != -1)
			return false;
		else
		{
			return true;
		}
	}

	public function getPath() : String
	{
		if(path != null)
			return path;

		if(!isHaxelibInstalled())
		{
			if (version != "")
			{
				throw "Could not find haxelib \"" + name + "\" version \"" + version + "\", does it need to be installed?";
			}
			else
			{
				throw "Could not find haxelib \"" + name + "\", does it need to be installed?";
			}
		}

		var output = getHaxelibPathOutput();

		var lines = output.split ("\n");

		for (i in 1...lines.length) {

			if (lines[i].trim().startsWith('-D'))
			{
				path = lines[i - 1].trim();

				if (isValidLibPath(path, name)) {
					break;
				}
			}

		}

		if (path == "")
		{
			try {
				for (line in lines)
				{
					if (line != "" && line.substr(0, 1) != "-")
					{
						if (FileSystem.exists(line))
						{
							path = line;
							break;
						}
					}
				}
			} catch (e:Dynamic) {}

		}

		return path;
	}

	private function isValidLibPath(libPath:String, libName:String):Bool
	{
		return FileSystem.exists(libPath) && libPath.indexOf(libName) != -1;
	}


	private function getHaxelibPathOutput(): String
	{
		var nameToTry = name;

		var haxePath = Sys.getEnv("HAXEPATH");
		var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["path", nameToTry], {block: true, systemCommand: true, errorMessage: "getting path of library"});

		var output = proc.getCompleteStdout();

		return output.toString();
	}

	private function getHaxelibListOutput(): String
	{
		var haxePath = Sys.getEnv("HAXEPATH");
		var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["list"], {block: true, systemCommand: true, errorMessage: "getting list of haxelibs"});

		var output = proc.getCompleteStdout();

		return output.toString();
	}

	public function selectVersion()
	{
		if (version == null || version == "")
			return;

		var arguments = [];
		if (isGitVersion())
		{
			var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());
			var path = Path.join([duellConfigJSON.localLibraryPath, "haxelib_" + name]);

			if (!FileSystem.exists(path))
			{
				installGitVersion();
			}

			var versionSplit = version.split(" ");
			versionSplit = versionSplit.filter(function (s) return s != null && s != "");

			if (versionSplit.length < 2 )
			{
				throw 'Invalid version string "$version" on haxelib "$name". Please specify something like "git <url> <branch> <subfolder>"';
			}

			var url = versionSplit[0];
			var branch = versionSplit.length > 1 ? versionSplit[1] : "master";
			var specialPath = versionSplit.length > 2 ? "/" + versionSplit[2] : "";

			GitHelper.setRemoteURL(path, "origin", url);
			if (GitHelper.getCurrentBranch(path) != branch)
			{
				GitHelper.checkoutBranch(path, branch);
			}
			GitHelper.pull(path);

			arguments.push("dev");
	   		arguments.push(name);
			arguments.push(path + specialPath);
		}
		else
		{
			arguments.push("set");
	   		arguments.push(name);
			arguments.push(version);
		}

		var haxePath = Sys.getEnv("HAXEPATH");
		var systemCommand = haxePath != null && haxePath != "" ? false : true;

		var process = new DuellProcess(haxePath, "haxelib", arguments, {systemCommand: systemCommand, errorMessage: "set haxelib version"});

		process.stdin.writeString("y\n");

		process.blockUntilFinished();
	}

	public function uninstall()
	{
		var args = ["remove", name];

		var haxePath = Sys.getEnv("HAXEPATH");
		var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var process = new DuellProcess(haxePath, "haxelib", args, {systemCommand: systemCommand, errorMessage: 'uninstalling the library "$name"', mute: true});

		process.blockUntilFinished();
	}

	public function install()
	{
		if (!ConnectionHelper.isOnline())
			return;

		if (isGitVersion())
		{
			selectVersion();
		}
		else
		{
			var args = ["install", name];
			if (version != "")
				args.push(version);

			var haxePath = Sys.getEnv("HAXEPATH");
			var systemCommand = haxePath != null && haxePath != "" ? false : true;
			var process = new DuellProcess(haxePath, "haxelib", args, {systemCommand: systemCommand, errorMessage: 'installing the library "$name"', mute: true});

			process.stdin.writeString("y\n");

			process.blockUntilFinished();
		}
	}

	public static function solveConflict(left: Haxelib, right: Haxelib): Haxelib
	{
		if (left.isGitVersion() && right.isGitVersion())
		{
			if (left.version != right.version)
				return null;

			return left;
		}

		if (left.isGitVersion())
			return left;

		if (right.isGitVersion())
			return right;

		if (left.version == null || left.version == "")
			return right;

		if (right.version == null || right.version == "")
			return left;

		if (left.version == right.version)
			return left;

		return null;
	}

	public function isGitVersion(): Bool
	{
		return version != null && (version.startsWith("ssh") || version.startsWith("http"));
	}

	private function installGitVersion(): Void
	{
		var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

		var path = Path.join([duellConfigJSON.localLibraryPath, "haxelib_" + name]);

		if (FileSystem.exists(path))
		{
			throw 'Invalid state, folder named haxelib_$name already exists';
		}

		PathHelper.mkdir(path);

		var versionSplit = version.split(" ");
		versionSplit = versionSplit.filter(function (s) return s != null && s != "");

		if (versionSplit.length < 2 )
		{
			throw 'Invalid version string "$version" on haxelib "$name". Please specify something like "git <url> <branch> <subfolder>"';
		}

		var url = versionSplit[0];
		GitHelper.clone(url, path);
	}

	public function toString(): String
	{
		return "haxelib " + name + " version " + version;
	}
}
