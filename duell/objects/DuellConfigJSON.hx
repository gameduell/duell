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

import sys.io.File;
import sys.FileSystem;

import haxe.Json;

class DuellConfigJSON
{
	///variables in the config, if you change them, do writeToConfig to commit the changes
	public var localLibraryPath : String;
	public var repoListURLs : Array<String>;
	public var setupsCompleted : Array<String>;
	public var lastProjectFile : String;
	public var lastProjectTime : String;
	public var configJSON : Dynamic;

	private var configPath : String;
	private function new(configPath : String) : Void
	{
		this.configPath = configPath; 

        var configContent = File.getContent(configPath);
        configJSON = Json.parse(configContent);

		localLibraryPath = configJSON.localLibraryPath;

		if (localLibraryPath != null)
			localLibraryPath = PathHelper.unescape(localLibraryPath); /// ~ paths are not very nice to sys.FileSystem

		repoListURLs = configJSON.repoListURLs;

		if (repoListURLs == null)
			repoListURLs = [];

		setupsCompleted = configJSON.setupsCompleted;

		if (setupsCompleted == null)
			setupsCompleted = [];

		lastProjectFile = configJSON.lastProjectFile;

		lastProjectTime = configJSON.lastProjectTime;
	}

	private static var cache : DuellConfigJSON;
	public static function getConfig(configPath : String) : DuellConfigJSON
	{
		if(cache == null)
		{
			cache = new DuellConfigJSON(configPath);
			return cache;
		}

		if(cache.configPath != configPath)
		{
			cache = new DuellConfigJSON(configPath);
			return cache;
		}

		return cache;
	}

	public function writeToConfig()
	{		
		configJSON.localLibraryPath = localLibraryPath;
		configJSON.repoListURLs = repoListURLs;
		configJSON.setupsCompleted = setupsCompleted;
		configJSON.lastProjectTime = lastProjectTime;
		configJSON.lastProjectFile = lastProjectFile;

		FileSystem.deleteFile(configPath);
		
		var output = File.write(configPath, false);
		output.writeString(Json.stringify(configJSON));
		output.close();
	}
}
