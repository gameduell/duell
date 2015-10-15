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

import duell.helpers.ConnectionHelper;
import duell.helpers.LogHelper;
import duell.objects.DuellProcess;

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

	public function exists()
	{
		var output = getHaxelibPathOutput();

		if(output.indexOf("is not installed") != -1)
			return false;
		else
			return true;
	}

	public function getPath() : String
	{
		if(path != null)
			return path;

		if(!exists())
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

	private function getHaxelibPathOutput(): String
	{
		var nameToTry = name;

    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["path", nameToTry], {block: true, systemCommand: true, errorMessage: "getting path of library"});

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
	    	arguments.push("git");
	   		arguments.push(name);
	    	arguments = arguments.concat(version.split(" "));
    	}
    	else
    	{
	    	arguments.push("set");
	   		arguments.push(name);
	    	arguments.push(version);

            uninstall(); /// BUG FIX, to ensure the version is there, because exists is not working for versions
			install();   /// BUG FIX the BUG FIX because it will hang when trying to install a haxelib version which was already there.
                         /// Therefore we simply remove the haxelib before.
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
    	if (isGitVersion())
    	{
    		selectVersion();
    	}
    	else if (ConnectionHelper.isOnline())
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

    public function toString(): String
    {
    	return "haxelib " + name + " version " + version;
    }
}
