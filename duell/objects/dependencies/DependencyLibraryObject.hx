package duell.objects.dependencies;

import duell.objects.dependencies.DependencyConfigFile;
import duell.objects.DuellLib;

class DependencyLibraryObject
{
	private var name(get, null) : String;
	private var configFile(get, null) : DependencyConfigFile;
	private var lib(get, null) : DuellLib;
	private var libraryDependencyObjects(get, null) : Array<DependencyLibraryObject>;
	
	public function new(configFile : DependencyConfigFile, name : String, ?version : String = "master")
	{
		this.name = name;
		this.configFile = configFile;
		lib = DuellLib.getDuellLib(name, version);
		libraryDependencyObjects = new Array<DependencyLibraryObject>();
	}

	public function addDependency(libraryObject : DependencyLibraryObject)
	{
		libraryDependencyObjects.push(libraryObject);
	}

	public function get_name() : String
	{
		return name;
	}

	public function get_lib() : DuellLib
	{
		return lib;
	}

	public function get_configFile() : DependencyConfigFile
	{
		return configFile;
	}

	public function get_libraryDependencyObjects() : Array<DependencyLibraryObject>
	{
		return libraryDependencyObjects;
	}

	public function toString() : String
	{
		return "DependencyLibraryObject :: name: " + name + " dependencies: " + libraryDependencyObjects;
	}
}