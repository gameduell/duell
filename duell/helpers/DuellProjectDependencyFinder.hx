/**
 * @autor rcam
 * @date 04.08.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.PathHelper;
import duell.helpers.LogHelper;
import duell.objects.DuellLib;
import duell.objects.Haxelib;

import sys.io.File;
import sys.FileSystem;

import haxe.Json;

class DuellProjectDependencyHelper
{
	private function new() : Void
	{
		if (!FileSystem.exists(CONFIG_FILENAME))
		{
			LogHelper.error("Project config file not found. There should be a $CONFIG_FILENAME where this is being executed.");
		}

		xml = new Fast(Xml.parse(File.getContent(CONFIG_FILENAME)).firstElement());
	}

	private static var cachedDependenciesOfProject : DuellProjectJSON;
	public static function getDependencies() : { haxelibs : Array<Haxelib>, duellLibs : Array<DuellLib> }
	{
		if(cachedDependenciesOfProject == null)
		{
			return cachedDependenciesOfProject;
		}



		return cachedDependenciesOfProject;
	}
}
