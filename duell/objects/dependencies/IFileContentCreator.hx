package duell.objects.dependencies;

interface IFileContentCreator
{
	public function parse( lib:DependencyLibraryObject ) : String;
}