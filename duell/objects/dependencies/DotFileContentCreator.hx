package duell.objects.dependencies;

class DotFileContentCreator implements IFileContentCreator
{
	private var duellLibContent = "";
	private var haxeLibsContent = "";

	public function new()
	{}

	public function parseDuellLibs(rootNode : DependencyLibraryObject)
	{
		var subnodes = rootNode.get_libraryDependencyObjects();
		var nodeName = rootNode.get_name();

		if(duellLibContent.length == 0 && subnodes.length == 0) //if the inital object has no child nodes
		{
			duellLibContent = nodeName + ';\n    ';
		}

		for (subnode in subnodes)
		{
			var lib = subnode.get_lib();
			var label = lib != null ? ' [label="' + lib.version + '", fontsize=10]' : ''; 
			duellLibContent += '    "' + nodeName + '" -> "' + subnode.get_name() + '"' + label + ';\n';
		}

		for (subnode in subnodes){
			parseDuellLibs(subnode);
		}
	}

	public function parseHaxeLibs(rootNode : DependencyLibraryObject) : Void
	{
		var config = rootNode.get_configFile();
		if(config.hasHaxeLibs())
		{
			var haxeLibs = config.get_haxeLibs();
			for (lib in haxeLibs){
				var label = ' [label="' + lib.version + '", fontcolor="#999999", fontsize=10]';
				haxeLibsContent += '   "' + rootNode.get_name() + '" -> "' + lib.name + '"' + label + ';\n';
			}
		}

		var subNodes = rootNode.get_libraryDependencyObjects();
		for (subNode in subNodes)
		{
			parseHaxeLibs(subNode);
		}
	}

	private function getDuellLibContent() : String
	{
		if(duellLibContent.length > 0){
			return getBaseFormat() + duellLibContent;
		}

		return "";
	}

	private function getHaxeLibsContent() : String
	{
		if(haxeLibsContent.length > 0)
		{
			return getHaxelibsFormat() + haxeLibsContent;
		}

		return "";
	}

	/*
	* function getContent
	* @returnType String
	* 
	* Returns the generated output for a dot renderer
	* Generell attributes:
	*   - size: in inches width,height => 10.3,5.3 will set max values to 1024px 
	*   - ranksep: vertical distance between nodes in inches
	*   - nodesep: horizontal distance between nodes
	*   - overlap: allow overlapping of nodes
	*   - start: determine the initial layout of nodes
	*/
	public function getContent() : String
	{
		return 'digraph G {\n' + 
			   '    graph [size="10.3,5.3", ranksep=0.5, nodesep=0.1, overlap=false, start=1]' + 
			    getDuellLibContent() +
			    getHaxeLibsContent() + 
			   '}';
	}

	public function getFilename() : String
	{
		return "dotFile.dot";
	}

	private function getBaseFormat() : String 
	{
		return '    node [fontname=Verdana,fontsize=12]\n' +
 			   '    node [style=filled]\n' +
 			   '    node [fillcolor="#FC861C44"]\n' +
 			   '    node [color="#FC332244"]\n' +
 			   '    edge [color="#FC861C"]\n';
	}

	private function getHaxelibsFormat() : String
	{
		return '    node [fontname=Verdana,fontsize=12, fontcolor="#999999"]\n' +
 			   '    node [style=filled]\n' +
 			   '    node [fillcolor="#EEEEEE"]\n' +
 			   '    node [color="#AAAAAA"]\n' +
 			   '    edge [color="#AAAAAA"]\n';
	}
}