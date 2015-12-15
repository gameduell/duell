package duell.helpers;


import duell.objects.LockedVersion;


class LockedVersionsFileHelper
{
	

	private static var versions = new LockedVersions();

	public static function do(){}

	public static function getLockedVersions( target:String ) : LockedVersion
	{
		return null;
	}

	public static function getLastLockedVersion( target:String ) : LockedVersion
	{
		return null;
	}

	public static function addLockedVersion( version:LockedVersion )
	{
	}
}


import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

import duell.helpers.LogHelper;

class LockedVersions 
{

	private static inline var targetFolder = 'versions';
	private static inline var targetFile = 'publishVersions.xml'

	private var lockedVersions : Array<LockedVersion>;

	public function new()
	{
		lockedVersions = new Array<LockedVersion>();

		initFile();
	}

	private function initFile()
	{
		var targetFolder = Path.join([Sys.getCwd(), targetFolder]);
		if(!FileSystem.exists(targetFolder))
		{
			FileSystem.createDirectory(targetFolder);
		}

		var targetFile = Path.join([targetFolder, targetFile]);
		if(!FileSytem.exists(targetFile))
		{
			var fileOutput = File.write(targetFile, false);
			fileOutput.writeString('<?xml version="1.0" encoding="utf-8"?>\n<builds>\n</builds>');
			fileOutput.close();
		}

		var stringContent = File.getContent(file);
		LogHelper.info('String-content: ' + stringContent);
	}

	private function parse( source:XML )
	{

	}
}