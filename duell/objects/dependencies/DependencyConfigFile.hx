package duell.objects.dependencies;

import duell.objects.DuellLib;

import sys.FileSystem;
import sys.io.File;

import haxe.io.Path;
import haxe.xml.Fast;


class DependencyConfigFile
{
	
	private var path : String;
	private var fileName : String;
	private var applicationName(get, null) : String;
	private var duellLibs(get, null) : Array<DuellLib>;

	public function new (path : String , fileName:String)
	{
		this.path = path;
		this.fileName = fileName;
		duellLibs = new Array<DuellLib>();

		parse();
	}

	private function parse()
	{
		var filePath = getAbsolutePath();
		if(!FileSystem.exists(filePath))
		{
			throw ('File "$filePath" does not exist!');
		}

		var fileContent:String = File.getContent(filePath);
		try
		{
			var fileXmlContent : Xml = Xml.parse(fileContent);
			var content : Fast = new Fast(fileXmlContent.firstElement());
			for (element in content.elements)
			{
				switch(element.name){
					case "app":
						 parseApp(element);

					case "duelllib":
						 parseLibraryElement(element);
				}
			}
		}
		catch(e : Dynamic)
		{
			throw ('Invalid file "$filePath"!');	
		}
	}

	private function parseApp(e : Fast)
	{
		if(e.has.title && e.has.company)
		{
			applicationName = e.att.title;
		}
	}

	private function parseLibraryElement(e : Fast)
	{
		var name = e.has.name ? e.att.name : "";
		var version = e.has.version ? e.att.version : "";

		duellLibs.push(DuellLib.getDuellLib(name, version));
	}

	private function getAbsolutePath() : String 
	{
		return Path.join([path, fileName]);
	}

	public function get_applicationName() : String
	{
		return applicationName;
	}

	public function get_duellLibs() : Array<DuellLib>
	{
		return duellLibs;
	}
}