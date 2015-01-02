/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.GitHelper;
import duell.helpers.DuellLibHelper;
import duell.objects.SemVer;

import sys.FileSystem;

using StringTools;

class DuellLib 
{
	public var name(default, null) : String;
	public var version(default, null) : String;

	private function new(name : String, version : String = "master")
	{
		this.name = name;
		this.version = version;
	}

	public static var duellLibCache : Map<String, Map<String, DuellLib> > = new Map<String, Map<String, DuellLib> >();
	public static function getDuellLib(name : String, version : String = "master") : DuellLib
	{
		if (version == null || version == "")
			throw 'Empty version is not allowed for $name library!';
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

	public function isInstalled(): Bool
	{
    	return DuellLibHelper.isPathValid(name);
	}

	public function isPathValid() : Bool
	{
    	return DuellLibHelper.isPathValid(name);
	}

	public function getPath(): String
	{
    	return DuellLibHelper.getPath(name);
	}

    public function updateNeeded() : Bool
    {
    	return DuellLibHelper.updateNeeded(name);
    }

    public function update()
    {
    	return DuellLibHelper.update(name);
    }

    public function install()
    {
    	return DuellLibHelper.install(name);
    }


}