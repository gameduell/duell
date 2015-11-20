package duell.objects.dependencies;

interface IFileContentCreator
{
	public function parse(lib : DependencyLibraryObject) : Void;
	public function getContent() : String;
	public function getFilename() : String;
}