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

package duell.helpers;

import duell.helpers.AskHelper;

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
			Sys.print("Download complete : " + cur + " bytes in " + time + "s (" + speed + "KB/s)\n");
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
			Sys.print(cur+" bytes\r");
		else
			Sys.print(cur+"/"+max+" ("+Std.int((cur*100.0)/max)+"%)\r");
	}
}

class DownloadHelper
{
	public static function downloadFile(remotePath : String, localPath : String = "", followingLocation : Bool = false) : Void
	{
		/// following location is for showing recursion

		if (localPath == "")
		{
			localPath = Path.withoutDirectory(remotePath);
		}

		if (!followingLocation && FileSystem.exists(localPath))
		{
			var answer = AskHelper.askYesOrNo("File found. Use existing file?");

			if (answer)
			{
				return;
			}

			FileSystem.deleteFile(localPath);
		}

		var out = File.write(localPath, true);
		var progress = new Progress(out);
		var h = new Http(remotePath);

		h.cnxTimeout = 30;

		h.onError = function (e) {
			progress.close();
			FileSystem.deleteFile(localPath);
			throw e;
		};

		if (!followingLocation)
		{
			Sys.println("Downloading " + localPath + "...");
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
