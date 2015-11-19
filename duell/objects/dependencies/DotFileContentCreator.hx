package duell.objects.dependencies;


class DotFileContentCreator implements IFileContentCreator
{

	private var content : String;
	private var isNext = true;

	public function new()
	{}

	public function parse(lib : DependencyLibraryObject)
	{
		var name = lib.get_name();//Continue

		if(isNext && content == null)
		{
			content = "    " + lib.get_name();
		}
		else if (isNext)
		{
			content += ";\n    " + lib.get_name();
		}
		else
		{
			content += " -> " + lib.get_name();
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
}