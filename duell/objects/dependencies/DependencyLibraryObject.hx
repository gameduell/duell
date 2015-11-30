package duell.objects.dependencies;

import duell.objects.dependencies.DependencyConfigFile;
import duell.objects.DuellLib;

class DependencyLibraryObject
{
	public var name(default, null) : String;
	public var configFile(default, null) : DependencyConfigFile;
	public var lib(default, null) : DuellLib;
	public var libraryDependencyObjects(default, null) : Array<DependencyLibraryObject>;
	
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

	public function toString() : String
	{
		return "DependencyLibraryObject :: name: " + name + " dependencies: " + libraryDependencyObjects;
	}
}