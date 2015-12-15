package duell.helpers;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

import duell.helpers.LogHelper;
import duell.versioning.objects.LockedVersion;
import duell.versioning.locking.file.ILockingFileParser;
import duell.versioning.locking.file.LockingFileXMLParser;

class LockedVersionsFileHelper
{

	private static var versions : LockedVersions;

	private static function getVersions() : LockedVersions
	{
		if(versions == null)
			versions = new LockedVersions( new LockingFileXMLParser() );

		return versions;
	}

	public static function doIt(){
		getVersions();
	}

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


class LockedVersions 
{
	private static inline var targetFolder = 'versions';
	private static inline var targetFile = 'publishVersions.xml';

	private var lockedVersions : Array<LockedVersion>;
	private var parser : ILockingFileParser;

	public function new( parser:ILockingFileParser )
	{
		lockedVersions = new Array<LockedVersion>();
		this.parser = parser;

		initFile();
	}

	private function initFile()
	{
		var targetFolder = Path.join([Sys.getCwd(), targetFolder]);
		if(!FileSystem.exists(targetFolder))
		{
			FileSystem.createDirectory(targetFolder);
		}

		var targetFilePath = Path.join([targetFolder, targetFile]);
		if(!FileSystem.exists(targetFilePath))
		{
			var fileOutput = File.write(targetFilePath, false);
			fileOutput.writeString(parser.getInitialInput());
			fileOutput.close();
		}

		var stringContent = File.getContent(targetFilePath);
		lockedVersions = parser.parseFile( stringContent );

		LogHelper.info(parser.createFileContent(lockedVersions));
	}
}