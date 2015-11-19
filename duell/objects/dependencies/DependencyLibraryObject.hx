package duell.objects.dependencies;

import duell.objects.dependencies.DependencyConfigFile;
import duell.objects.DuellLib;

class DependencyLibraryObject
{
	private var name(get, null) : String;
	private var configFile(get, null) : DependencyConfigFile;
	private var lib(get, null) : DuellLib;
	private var libraryDependencyObjects : Array<DependencyLibraryObject>;
	
	public function new(configFile : DependencyConfigFile, name : String)
	{
		this.name = name;
		this.configFile = configFile;
		lib = DuellLib.getDuellLib(name);
		libraryDependencyObjects = new Array<DependencyLibraryObject>();
	}

	public function generateOuptutFile(creator : IFileContentCreator)
	{
		creator.parse(this);

		for (dependency in libraryDependencyObjects){
			dependency.generateOuptutFile(creator);
		}

		creator.next();
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

	public function toString() : String
	{
		return "DependencyLibraryObject :: name: " + name + " dependencies: " + libraryDependencyObjects;
	}
}