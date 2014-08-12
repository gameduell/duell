/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.build.helpers;

import duell.build.objects.Configuration;

import duell.helpers.PlatformHelper;
import duell.helpers.LogHelper;
import duell.helpers.FileHelper;
import duell.helpers.PathHelper;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

import haxe.Template;

class TemplateHelper
{
	public static function copyTemplateFile(source:String, destination:String, onlyIfNewer : Bool = true) : Void 
	{	
		if (FileHelper.isText(source))
		{				
			LogHelper.info ("", " - \x1b[1mCopying template file:\x1b[0m " + source + " \x1b[3;37m->\x1b[0m " + destination);
				
			var fileContents:String = File.getContent(source);
			var template:Template = new Template(fileContents);
			var result:String = template.execute(Configuration.getData(), 
												 Configuration.getData().TEMPLATE_FUNCTIONS);
			
			try {
				
				var fileOutput : FileOutput = File.write(destination, true);
				fileOutput.writeString(result);
				fileOutput.close();
				
			} catch (e:Dynamic) {
				
				LogHelper.error ("Cannot write to file \"" + destination + "\"");
				
			}
		}
		else
		{
			if (!onlyIfNewer || FileHelper.isNewer(source, destination))
			{
				File.copy(source, destination);
			}
		}
	}

	public static function recursiveCopyTemplatedFiles(source:String, destination:String) 
	{	
		PathHelper.mkdir(destination);
		
		var files:Array <String> = null;
		
		try 
		{
			files = FileSystem.readDirectory(source);
		} 
		catch (e:Dynamic) 
		{
			LogHelper.error("Could not find source directory \"" + source + "\"");
		}
		
		for (file in files) 
		{
			if (file.substr(0, 1) != ".") /// hidden file
			{
				var itemDestination:String = destination + "/" + file;
				var itemSource:String = source + "/" + file;
				
				if (FileSystem.isDirectory(itemSource)) 
				{
					recursiveCopyTemplatedFiles(itemSource, itemDestination);
				} 
				else 
				{
					copyTemplateFile(itemSource, itemDestination);
				}
				
			}
			
		}
		
	}
}
