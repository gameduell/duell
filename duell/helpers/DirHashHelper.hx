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

import duell.objects.DuellProcess;
import duell.objects.DuellLib;
import duell.helpers.PlatformHelper;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using duell.helpers.HashHelper;
using StringTools;

class DirHashHelper
{

	public static function getHashOfDirectory(path: String, filters: Array<EReg> = null): Int
	{
		var process: DuellProcess;

		if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
		    var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();
			// ls binary is bundled for windows
			process = new DuellProcess(Path.join([duellLibPath, "bin"]), "ls.exe", ["-lp", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}
		else
		{
			process = new DuellProcess(null, "ls", ["-lp", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}

		var output = process.getCompleteStdout().toString();

		/// splits by newline
		var outputSplit = output.split("\n");

		/// remove total line
		outputSplit.shift();

		/// remove empty newlines
		outputSplit = outputSplit.filter(function(s) return s != "");

		/// cleanup
		outputSplit = outputSplit.map(function(s) return s.trim());

		/// remove directories
		outputSplit = outputSplit.filter(function(s) return s.charAt(s.length - 1) != "/");

		if (filters == null)
			filters = [];

		var outputSplitFiltered:Array<String> = outputSplit.filter(function(s) {
			for (filter in filters)
			{
				if (filter.match(s))
					return false;
			}
			return true;
		});

		/// extract parts that matter
		outputSplitFiltered = outputSplitFiltered.map(
					extractSizeModificationDateAndFileName);

		output = outputSplitFiltered.join("\n");

		return output.getFnv32IntFromString();
	}

	public static function getHashOfDirectoryRecursively(path: String, filters: Array<EReg> = null): Int
	{
		var process: DuellProcess;

		if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
		    var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();
			// ls binary is bundled for windows
			process = new DuellProcess(Path.join([duellLibPath, "bin"]), "ls.exe", ["-lpR", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}
		else
		{
			process = new DuellProcess(null, "ls", ["-lpR", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}

		var output = process.getCompleteStdout().toString();

		/// splits by newline
		var outputSplit = output.split("\n");

		/// remove total line
		outputSplit.shift();

		/// remove empty newlines
		outputSplit = outputSplit.filter(function(s) return s != "");

		/// cleanup
		outputSplit = outputSplit.map(function(s) return s.trim());

		/// remove directories
		outputSplit = outputSplit.filter(function(s) return s.charAt(s.length - 1) != "/" || s.charAt(s.length - 1) != ":" || s.startsWith("total"));

		if (filters == null)
			filters = [];

		var outputSplitFiltered:Array<String> = outputSplit.filter(function(s) {
			for (filter in filters)
			{
				if (filter.match(s))
					return false;
			}
			return true;
		});

		/// extract parts that matter
		outputSplitFiltered = outputSplitFiltered.map(
					extractSizeModificationDateAndFileName);

		output = outputSplitFiltered.join("\n");
		return output.getFnv32IntFromString();
	}

	/// cache start range as ls output should have the same structure on the same machine
	private static var startRangeForCuttingOutput: Null<Int> = null;
	private static function extractSizeModificationDateAndFileName(lsOutputLine: String): String
	{
		/*
		 *	This code tries to extract only the size, date of modification and
		 *  filename from the ls output.
		 *  Since the ls output is not very reliable, we attempt to find the
		 *  hour of modification section, and then check if there is a filesize
		 *  3 columns behind. This is a very rough solution, but it should work..
		 *  If it doesn't work, we will just list the filenames and request the size
		 *  and modification date manually.
		 */

		var findDateRegex = ~/^[0-9][0-9]:[0-9][0-9]$/i;
		var findSizeRegex = ~/^[0-9]+$/i;

		var fileInfoList:Array<String> = lsOutputLine.split(" ");

		fileInfoList = fileInfoList.filter(function(s) return s != "");

		/// try to find the date column
		if (startRangeForCuttingOutput == null)
		{
			if (fileInfoList.length > 3) /// highly unlikely to not be
			{
				for (i in (3...fileInfoList.length))
				{
					if (findDateRegex.match(fileInfoList[i]) && 	/// check if this is the date
						findSizeRegex.match(fileInfoList[i - 3]))	/// check if 2 behind looked like a size
					{
						startRangeForCuttingOutput = i - 3;
						break;
					}
				}
			}
		}

		/// if we couldn't find the range, then don't split at all.
		if (startRangeForCuttingOutput != null)
		{
			fileInfoList = fileInfoList.splice(startRangeForCuttingOutput, fileInfoList.length - startRangeForCuttingOutput);
		}

		return fileInfoList.join(" ");
	}

	public static function getCachedHash(hashPath:String): Int
	{
		if (FileSystem.exists(hashPath))
		{
			var hash: String = File.getContent(hashPath);

			return Std.parseInt(hash);
		}
		return 0;
	}

	public static function saveHash(hash: Int, hashPath:String): Void
	{
		if (FileSystem.exists(hashPath))
		{
			FileSystem.deleteFile(hashPath);
		}

		File.saveContent(hashPath, Std.string(hash));
	}



}
