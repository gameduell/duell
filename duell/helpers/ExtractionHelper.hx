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

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

import python.zipfile.ZipFile;

class ExtractionHelper
{
	public static function extractFile(sourceZIP : String, targetPath : String, ignoreRootFolder : String = "") : Void
	{
		Sys.println("Extracting " + sourceZIP + "... ");

		var extension = Path.extension(sourceZIP);

		if (extension != "zip")
		{
			var arguments = "xvzf";

			if (extension == "bz2" || extension == "tbz2")
			{
				arguments = "xvjf";
			}

			if (ignoreRootFolder != "")
			{
				if (ignoreRootFolder == "*")
				{
					for(file in FileSystem.readDirectory(targetPath))
					{
						if(FileSystem.isDirectory(targetPath + "/" + file))
						{
							ignoreRootFolder = file;
						}
					}
				}

				CommandHelper.runCommand("", "tar", [arguments, sourceZIP], {errorMessage: "extracting file"});

				for (file in FileSystem.readDirectory(ignoreRootFolder))
				{
					CommandHelper.runCommand("", "cp", [ "-Rf", Path.join([ignoreRootFolder, file]), targetPath], {errorMessage: "copying files to the target directory of the extraction"});
				}

				CommandHelper.runCommand("", "rm", [ "-rf", ignoreRootFolder], {errorMessage: "deleting extracted folder"});
			}
			else
			{
				CommandHelper.runCommand("", "tar", [arguments, sourceZIP, "-C", targetPath], {errorMessage: "extracting file"});
			}

			CommandHelper.runCommand("", "chmod", ["-R", "755", targetPath], {errorMessage: "setting permissions"});
		}
		else
		{
			var zipFile = new ZipFile(sourceZIP);
			zipFile.extractall(targetPath);
			if (ignoreRootFolder != "")
			{
				if (ignoreRootFolder == "*")
				{
					for(file in FileSystem.readDirectory(targetPath))
					{
						if(FileSystem.isDirectory(Path.join([targetPath,file])))
						{
							ignoreRootFolder = file;
						}
					}
				}

				FileHelper.recursiveCopyFiles(Path.join([targetPath,ignoreRootFolder]), targetPath);

				CommandHelper.runCommand("", "rm", [ "-rf", Path.join([targetPath,ignoreRootFolder])], {errorMessage: "deleting extracted folder"});
			}


		}

		Sys.println("Done");
	}
}
