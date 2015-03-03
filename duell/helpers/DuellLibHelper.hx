
package duell.helpers;

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.GitHelper;
import duell.helpers.DuellLibHelper;
import duell.objects.SemVer;
import duell.objects.DuellProcess;

import sys.FileSystem;

using StringTools;

import haxe.Serializer;
import haxe.Unserializer;

typedef DuellLibHelperCaches = {
	existsCache: Array<String>,
	haxelibPathOutputCache: Map<String, String>,
	pathCache: Map<String, String>
}

class DuellLibHelper
{ 
	private static var caches: DuellLibHelperCaches = {
		existsCache: [],
		haxelibPathOutputCache: new Map(),
		pathCache: new Map()
	}

	public static function isInstalled(name: String): Bool
	{
		if (caches.existsCache.indexOf(name) != -1)
		{
			return true;
		}

		var haxelibPathOutput = getHaxelibPathOutput(name);

		if (haxelibPathOutput.indexOf('is not installed') == -1)
		{
 			caches.existsCache.push(name);
 			return true;
		}

 		return false;
	}


	private static function getHaxelibPathOutput(name: String): String
	{
		if (caches.haxelibPathOutputCache.exists(name))
			return caches.haxelibPathOutputCache.get(name);

    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["path", name], {block: true, systemCommand: systemCommand, errorMessage: "getting path of library"});
		var output = proc.getCompleteStdout();
		var stringOutput = output.toString();

		caches.haxelibPathOutputCache.set(name, stringOutput);

		return stringOutput;
	}

	public static function isPathValid(name: String) : Bool
	{
		return FileSystem.exists(getPath(name));
	}

	public static function getPath(name: String) : String
	{
		if (caches.pathCache.exists(name))
			return caches.pathCache.get(name);

		if (!isInstalled(name))
		{
			LogHelper.error ('Could not find duellLib \'' + name + '\'.');
		}

		var haxeLibPathOutput = getHaxelibPathOutput(name);

		var lines = haxeLibPathOutput.split ('\n');
			
		for (i in 1...lines.length) {
			
			if (lines[i].trim().startsWith('-D')) 
			{
				caches.pathCache.set(name, lines[i - 1].trim());
			}
			
		}

		if (caches.pathCache.get(name) == '') 
		{
			try {
				for (line in lines) 
				{
					if (line != '' && line.substr(0, 1) != '-') 
					{
						if (FileSystem.exists(line)) 
						{
							caches.pathCache.set(name, line);
							break;
						}
					}
				}
			} catch (e:Dynamic) {}
			
		}
		
		return caches.pathCache.get(name);
	}

    public static function updateNeeded(name: String) : Bool
    {
        var path = getPath(name);

        return GitHelper.updateNeeded(path);
    }

    public static function update(name: String)
    {
        GitHelper.pull(getPath(name));
    }

    public static function install(name: String)
    {
    	caches.haxelibPathOutputCache.remove(name);

        var duellLibList = DuellLibListHelper.getDuellLibReferenceList();

        if (duellLibList.exists(name))
        {
            duellLibList.get(name).install();
        }
        else
        {
            LogHelper.error('Couldn\'t find the Duell Library reference in the repo list for $name. Can\'t install it.');
        }
    }

    public static function serializeCaches(): String
    {
		var serializer = new Serializer();
		serializer.serialize(caches);

		var s = serializer.toString();
		return s;
    }

    public static function deserializeCaches(cache: String): Void
    {
		caches = new Unserializer(cache).unserialize();
    }
}