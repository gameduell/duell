/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.objects;

import duell.helpers.PathHelper;

import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

class HXCPPConfigXML
{
	private var xml : Fast = null;

	private var configPath : String;
	private function new(configPath : String) : Void
	{
		this.configPath = configPath;
		xml = new Fast(Xml.parse(File.getContent(configPath)).firstElement());
	}

	private static var cache : HXCPPConfigXML;
	public static function getConfig(configPath : String) : HXCPPConfigXML
	{
		if(cache == null)
		{
			cache = new HXCPPConfigXML(configPath);
			return cache;
		}

		if(cache.configPath != configPath)
		{
			cache = new HXCPPConfigXML(configPath);
			return cache;
		}

		return cache;
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
			var bytes = File.getBytes(configPath);

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

}
