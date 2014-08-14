/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;


import sys.io.File;
import sys.FileSystem;

import haxe.Json;

class DuellConfigJSON
{
	///variables in the config, if you change them, do writeToConfig to commit the changes
	public var localLibraryPath : String;
	public var repoListURLs : Array<String>;
	public var configJSON : Dynamic;

	private var configPath : String;
	private function new(configPath : String) : Void
	{
		this.configPath = configPath; 

        var configContent = File.getContent(configPath);
        configJSON = Json.parse(configContent);

		localLibraryPath = configJSON.localLibraryPath;
		repoListURLs = configJSON.repoListURLs;
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

		FileSystem.deleteFile(configPath);
		
		var output = File.write(configPath, false);
		output.writeString(Json.stringify(configJSON));
		output.close();
	}
}
