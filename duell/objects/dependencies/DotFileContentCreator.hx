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
			var lib = subnode.get_lib();
			var label = lib != null ? ' [label="' + lib.version + '"]' : ''; 
			content += '    "' + nodeName + '" -> "' + subnode.get_name() + '"' + label + ';\n';
		}

		for (subnode in subnodes){
			parse(subnode);
		}
	}

	public function getContent() : String
	{
		return "digraph G {\n" + getBaseFormat() + content + "}";
	}

	public function getFilename() : String
	{
		return "dotFile.dot";
	}

	private function getBaseFormat() : String 
	{
		return '    node [fontname=Verdana,fontsize=12]\n' +
 			   '    node [style=filled]\n' +
 			   '    node [fillcolor="#EEEEEE"]\n' +
 			   '    node [color="#EEEEEE"]\n' +
 			   '    edge [color="#31CEF0"]\n';
	}
}