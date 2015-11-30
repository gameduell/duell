package duell.objects.dependencies;

interface IFileContentCreator
{
	public function parseDuellLibs(lib : DependencyLibraryObject) : Void;
	public function parseHaxeLibs(lib : DependencyLibraryObject) : Void;
	public function getContent() : String;
	public function getFilename() : String;
}