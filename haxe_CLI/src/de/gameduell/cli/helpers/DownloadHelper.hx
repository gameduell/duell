/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package de.gameduell.cli.helpers;

import de.gameduell.cli.helpers.AskHelper;

import neko.Lib;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import haxe.Http;

class Progress extends haxe.io.Output 
{
	var o : haxe.io.Output;
	var cur : Int;
	var max : Int;
	var start : Float;

	public function new(o) 
	{
		this.o = o;
		cur = 0;
		start = haxe.Timer.stamp();
	}


	override function writeByte(c) 
	{
		o.writeByte(c);
		bytes(1);
	}

	override function writeBytes(s, p, l) 
	{
		var r = o.writeBytes(s,p,l);
		bytes(r);
		return r;
	}

	override function close() 
	{
		super.close();
		o.close();
		var time = haxe.Timer.stamp() - start;
		var speed = (cur / time) / 1024;
		time = Std.int(time * 10) / 10;
		speed = Std.int(speed * 10) / 10;
		
		// When the path is a redirect, we don't want to display that the download completed
		
		if (cur > 400) 
		{
			Lib.print("Download complete : " + cur + " bytes in " + time + "s (" + speed + "KB/s)\n");	
		}
	}

	override function prepare(m) 
	{
		max = m;
	}

	private function bytes(n) 
	{
		cur += n;
		if( max == null )
			Lib.print(cur+" bytes\r");
		else
			Lib.print(cur+"/"+max+" ("+Std.int((cur*100.0)/max)+"%)\r");
	}
}

class DownloadHelper
{
	public static function downloadFile(remotePath : String, localPath : String = "", followingLocation : Bool = false) : Void
	{
		if (localPath == "") 
		{
			localPath = Path.withoutDirectory(remotePath);
		}
		
		if (!followingLocation && FileSystem.exists(localPath)) 
		{
			var answer = AskHelper.askYesOrNo("File found. Use existing file?");
			
			if (answer != No) 
			{
				return;
			}
		}
		trace("Starting Download...");
		var out = File.write(localPath, true);
		var progress = new Progress(out);
		var h = new Http(remotePath);
		
		trace("Download Started...");
		h.cnxTimeout = 30;
		
		h.onError = function (e) {

			trace("Error!", e);
			progress.close();
			FileSystem.deleteFile(localPath);
			throw e;
		};
		
		if (!followingLocation) 
		{
			Lib.println("Downloading " + localPath + "...");
		}
		
		h.customRequest (false, progress);
		
		if (h.responseHeaders != null && h.responseHeaders.exists("Location")) 
		{	
			var location = h.responseHeaders.get("Location");
			
			if (location != remotePath) 
			{	
				downloadFile (location, localPath, true);	
			}
		}
	}
}
