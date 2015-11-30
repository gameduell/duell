package duell.objects.dependencies;

import duell.objects.DuellLib;
import duell.objects.Haxelib;

import sys.FileSystem;
import sys.io.File;

import haxe.io.Path;
import haxe.xml.Fast;

class DependencyConfigFile
{
	
	private var path : String;
	private var fileName : String;
	public var applicationName(default, null) : String;
	public var duellLibs(default, null) : Array<DuellLib>;
	public var haxeLibs(default, null) : Array<Haxelib>;

	public function new (path : String , fileName:String)
	{
		this.path = path;
		this.fileName = fileName;
		duellLibs = new Array<DuellLib>();
		haxeLibs = new Array<Haxelib>();

		parse();
	}

	private function parse()
	{
		var filePath = getAbsolutePath();
		if(!FileSystem.exists(filePath))
		{
			return;
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
						 parseDuellLib(element);

					case "haxelib":
						 parseHaxeLib(element);
				}
			}
		}
		catch(e : Dynamic)
		{
			throw ('Invalid file "$filePath"!');	
		}
	}

	private function parseHaxeLib(e : Fast)
	{
		var name = e.has.name ? e.att.name : "";
		var version = e.has.version ? e.att.version : "";

		haxeLibs.push(Haxelib.getHaxelib(name, version));
	}

	private function parseApp(e : Fast)
	{
		if(e.has.title && e.has.company)
		{
			applicationName = e.att.title;
		}
	}

	private function parseDuellLib(e : Fast)
	{
		var name = e.has.name ? e.att.name : "";
		var version = e.has.version ? e.att.version : "";

		duellLibs.push(DuellLib.getDuellLib(name, version));
	}

	private function getAbsolutePath() : String 
	{
		return Path.join([path, fileName]);
	}

	public function hasHaxeLibs() : Bool
	{
		return haxeLibs.length > 0;
	}
}