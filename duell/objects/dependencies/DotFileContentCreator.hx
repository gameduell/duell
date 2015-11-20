package duell.objects.dependencies;

class DotFileContentCreator implements IFileContentCreator
{
	private var content = "";

	public function new()
	{}

	public function parse(rootNode : DependencyLibraryObject)
	{
		var subnodes = rootNode.get_libraryDependencyObjects();
		var nodeName = rootNode.get_name();

		if(content.length == 0 && subnodes.length == 0) //if the inital object has no child nodes
		{
			content = nodeName + ';\n    ';
		}

		for (subnode in subnodes)
		{
			content += '    "' + nodeName + '" -> "' + subnode.get_name() + '";\n';
		}

		for (subnode in subnodes){
			parse(subnode);
		}
	}

	public function getContent() : String
	{
		return "digraph G {\n" + content + "}";
	}

	public function getFilename() : String
	{
		return "dotFile.dot";
	}
}