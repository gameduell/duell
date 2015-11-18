package duell.objects.dependencies;

import duell.objects.DuellLib;

enum LibraryType
{
	DUELLLIB;
	HAXELIB;
}

class DependencyLibraryObject
{
	private var lib : DuellLib;
	private var type : LibraryType;
	private var dependencies : Array<DependencyLibraryObject>;

	public function new(name : String, version : String = "master")
	{
		lib = DuellLib.getDuellLib(name, version);
		type = LibraryType.DUELLLIB;
		dependencies = new Array<DependencyLibraryObject>();
	}

	public function generateOuptutFile( creator:IFileContentCreator ) : String
	{
		//TODO clue
		return "todo!!";
	}

	public function toString() : String
	{
		return "\nDependencyLibraryObject\n name:" + lib.name + "\n version:" + lib.version;
	}

	public function get_lib() : DuellLib
	{
		return lib;
	}

	public function get_dependencies() : Array<DependencyLibraryObject>
	{
		return dependencies;
	}

	public function set_dependencies(value : Array<DependencyLibraryObject>) 
	{
		this.dependencies = value;
	}
}