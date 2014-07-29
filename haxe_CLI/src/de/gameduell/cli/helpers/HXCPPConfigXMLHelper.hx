package de.gameduell.cli.helpers;

import de.gameduell.cli.helpers.PathHelper;

import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

class HXCPPConfigXMLHelper
{
	private var xml : Fast = null;

	private var configPath : String;
	public function new(configPath : String) : Void
	{
		this.configPath = configPath; 
		xml = new Fast(Xml.parse(File.getContent(configPath)).firstElement());
	}

	public function getDefines() :  Map<String, String>
	{
		for(element in xml.elements) {
			switch(element.name)
			{
				case "section":
					if(element.has.id)
					{
						if(element.att.id == "vars")
						{
							return getDefinesFromSectionVars(element);
						}

					}

			}
		}

		return new Map<String, String>();
	}

	public function writeDefines(defines : Map<String, String>)
	{		
		var newContent = "";
		var definesText = "";
		var env = Sys.environment();
		
		for(key in defines.keys()) 
		{
			if(!env.exists(key) || env.get(key) != defines.get(key)) 
			{
				definesText += "		<set name=\"" + key + "\" value=\"" + PathHelper.stripQuotes(defines.get(key)) + "\" />\n";
			}
		}
		
		if(FileSystem.exists(configPath)) 
		{
			var input = File.read(configPath, false);
			var bytes = input.readAll();
			input.close ();
					
			var backup = File.write(configPath + ".bak." + haxe.Timer.stamp(), false);
			backup.writeBytes(bytes, 0, bytes.length);
			backup.close();
					
			var content = bytes.getString(0, bytes.length);
			
			var startIndex = content.indexOf("<section id=\"vars\">");
			var endIndex = content.indexOf("</section>", startIndex);
			
			newContent += content.substr(0, startIndex) + "<section id=\"vars\">\n		\n";
			newContent += definesText;
			newContent += "		\n	" + content.substr(endIndex);
			
		} 
		else 
		{
			newContent += "<xml>\n\n";
			newContent += "	<section id=\"vars\">\n\n";
			newContent += definesText;
			newContent += "	</section>\n\n</xml>";
		}
		
		var output = File.write(configPath, false);
		output.writeString(newContent);
		output.close();
	}

	private function getDefinesFromSectionVars(sectionElement : Fast) 
	{
		var defines = new Map<String, String>();
		for(element in sectionElement.elements)
		{
			switch(element.name)
			{
				case "set":
					if(element.has.name)
					{
						var name = element.att.name;
						var value = "";
						if(element.has.value)
						{
							value = element.att.value;
						}
						defines[name] = value;
					}
			}
		}
		return defines;
	}
	
	public static function getProbableHXCPPConfigLocation() : String
	{
		var env = Sys.environment();

		var home = "";
		
		if (env.exists ("HOME")) 
		{
			home = env.get ("HOME");
		} 
		else if(env.exists ("USERPROFILE")) 
		{
			home = env.get ("USERPROFILE");
		} 
		else 
		{	
			return null;
		}
		
		return home + "/.hxcpp_config.xml";
	}
}
