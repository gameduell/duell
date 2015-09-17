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

import python.urllib.Request;

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


		Request.urlretrieve(remotePath, localPath, function(blocknr, blocksize, size){
			var current = blocknr*blocksize;
			Sys.print(Std.string(current)+"/"+Std.string(size)+" ("+Std.int((current*100.0)/size)+"%)\r");
		});
	}
}
