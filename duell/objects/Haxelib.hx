/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
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
				LogHelper.error ("Could not find haxelib \"" + name + "\" version \"" + version + "\", does it need to be installed?");
			} 
			else 
			{
				LogHelper.error ("Could not find haxelib \"" + name + "\", does it need to be installed?");
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
		if(version != "")
			nameToTry += ":" + version;

    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["path", nameToTry], {block: true, systemCommand: true, errorMessage: "getting path of library"});

		var output = proc.getCompleteStdout();

		return output.toString();
	}

    public function update()
    {
        CommandHelper.runHaxelib("", ["update", name], {errorMessage: 'updating the library "$name"'});
    }

    public function install()
    {
    	var args = ["install", name];
    	if (version != "")
    		args.push(version);
        CommandHelper.runHaxelib("", args, {errorMessage: 'installing the library "$name"'});
    }
}