/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.LogHelper;
import duell.helpers.ProcessHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.GitHelper;

import sys.FileSystem;

using StringTools;

class DuellLib 
{
	public var name(default, null) : String;
	public var version(default, null) : String;
	private var pathCache : String = null; ///use getters
	private var existsCache : Null<Bool> = null; ///use getters

	private function new(name : String, version : String = '')
	{
		this.name = name;
		if (version == null)
			version = "";
		this.version = version;
	}

	public static var duellLibCache : Map<String, Map<String, DuellLib> > = new Map<String, Map<String, DuellLib> >();
	public static function getDuellLib(name : String, version : String = '') : DuellLib
	{
		///add to the cache if it is not there
		if (duellLibCache.exists(name))
		{
			var versionMap = duellLibCache.get(name);
			if (!versionMap.exists(version))
			{
				versionMap.set(version, new DuellLib(name, version));
			}
		}
		else
		{
			var versionMap = new Map<String, DuellLib>();
			versionMap.set(version, new DuellLib(name, version));
			duellLibCache.set(name, versionMap);
		}

		///retrieve from the cache
		return duellLibCache.get(name).get(version);
	}

	public function exists() : Bool
	{
		if (existsCache != null && existsCache) /// if it didn't exist before, we always try again.
			return existsCache;

		var output = '';
	
		output = ProcessHelper.runProcess(Sys.getEnv ('HAXEPATH'), 'haxelib', ['path', name], true, true, true);

		if (output.indexOf('is not installed') != -1)
			existsCache = false;
 		else if (version == "")
 			existsCache = true;

 		/// TODO
 		if (existsCache == null)
 			existsCache = false;
 		/// /TODO

 		return existsCache;
	}

	public function getPath() : String
	{
		if(pathCache != null)
			return pathCache;

		if (!exists())
		{
			LogHelper.error ('Could not find duellLib \'' + name + '\'.');
		}

		return _getPath();
			
	}

	public function _getPath() : String
	{
		if(pathCache != null)
			return pathCache;

		var output = ProcessHelper.runProcess(Sys.getEnv ('HAXEPATH'), 'haxelib', ['path', name], true, true, true);
		var lines = output.split ('\n');
			
		for (i in 1...lines.length) {
			
			if (lines[i].trim() == '-D ' + name) 
			{
				pathCache = lines[i - 1].trim();
			}
			
		}

		if (pathCache == '') 
		{
			try {
				for (line in lines) 
				{
					if (line != '' && line.substr(0, 1) != '-') 
					{
						if (FileSystem.exists(line)) 
						{
							pathCache = line;
							break;
						}
					}
				}
			} catch (e:Dynamic) {}
			
		}
		
		return pathCache;
	}

	public function isRepoOnCorrectVersion()
	{
		/// get current branch / tag
	}

    public function updateNeeded() : Bool
    {
    	if (Sys.args().indexOf("-noupdate") != -1)
    		return false;

        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Checking for updates on lib " + name + "===============================================");

        var path = getPath();

        if (!FileSystem.exists(path))
        {
            LogHelper.error("library " + name + "'s path (" + path + ") is not accessible!");
            return false;
        }

        return GitHelper.updateNeeded(path);
    }

    public function update()
    {
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Updating lib " + name + "===============================================");

        var path = getPath();

        if (!FileSystem.exists(path))
        {
            LogHelper.error("library " + name + "'s path (" + path + ") is not accessible!");
        }

        GitHelper.pull(path);
    }

    public function install()
    {
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
}