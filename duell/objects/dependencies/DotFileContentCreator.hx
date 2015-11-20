package duell.objects.dependencies;


class DotFileContentCreator implements IFileContentCreator
{

	private var content : String;
	private var isNext = true;

	public function new()
	{}

	public function parse(lib : DependencyLibraryObject)
	{
		var name = lib.get_name().split(" ").join("_");

		if(isNext && content == null)
		{
			content = "    " + name;
		}
		else if (isNext)
		{
			content += ";\n    " + name;
		}
		else
		{
			content += " -> " + name;
		}

		isNext = false;
	}

	public function next()
	{
		isNext = true;
	}

	public function getContent() : String
	{
		return "digraph G {\n" + content + ";\n}";
	}

	public function getFilename() : String
	{
		return "dotFile.dot";
	}
}