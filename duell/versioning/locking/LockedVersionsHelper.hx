package duell.versioning.locking;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

import duell.helpers.LogHelper;
import duell.objects.Haxelib;
import duell.objects.DuellLib;
import duell.versioning.objects.LockedVersion;
import duell.versioning.locking.file.ILockingFileParser;
import duell.versioning.locking.file.LockingFileXMLParser;

class LockedVersionsHelper
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

	public static function addLockedVersion( duelllibs:Array<DuellLib>, haxelibs:Array<Haxelib> )
	{
		getVersions().create( duelllibs, haxelibs );
	}
}


class LockedVersions 
{
	private static inline var targetFolder = 'versions';
	private static inline var targetFile = 'lockedVersions.xml';

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
		if(FileSystem.exists(targetFilePath))
		{
			var stringContent = File.getContent(targetFilePath);
			lockedVersions = parser.parseFile( stringContent );
		}
	}

	private function getLastLockedVersion() : LockedVersion
	{
		var version : LockedVersion = null;
		for ( lv in lockedVersions )
		{
			version = version != null ? lv.ts > version.ts ? lv : version : lv;
		}

		return version;
	}

	public function create( duell:Array<DuellLib>, haxe:Array<Haxelib> )
	{
		var lastLockedVersion = getLastLockedVersion();
		var now = Date.now();
		var currentVersion = new LockedVersion( now.getTime() );

		//create used libs
		for ( dLib in duell )
		{
			var lockedLib = {name:dLib.name, type:'duelllib', version:dLib.version, commitHash:''};
			currentVersion.addUsedLib( lockedLib );	
		}

		for ( hLib in haxe )
		{
			var lockedLib = {name:hLib.name, type:'haxelib', version:hLib.version, commitHash:''};
			currentVersion.addUsedLib( lockedLib );	
		}

		lockedVersions.push( currentVersion );

		//check differences
		checkUpdates( lastLockedVersion, currentVersion );

		saveFile();
	}

	private function checkUpdates( oldVersion:LockedVersion, newVersion:LockedVersion )
	{
		if( oldVersion == null )
			return;

		for ( newLib in newVersion.usedLibs )
		{
			if(!oldVersion.usedLibs.exists( newLib.name ))
			{
				var update = {name:NEW_LIB, oldValue:'0.0.0', newValue:newLib.version};
				newVersion.addUpdatedLib( newLib.name, update );
				continue;
			}

			var oldLib = oldVersion.usedLibs.get( newLib.name );
			if( oldLib.version != newLib.version )
			{
				var update = {name:VERSION, oldValue:oldLib.version, newValue:newLib.version};
				newVersion.addUpdatedLib( newLib.name, update );
			}

			if( oldLib.commitHash != newLib.commitHash )
			{
				var update = {name:COMMITHASH, oldValue:oldLib.commitHash, newValue:newLib.commitHash};
				newVersion.addUpdatedLib( newLib.name, update );	
			}
		}

		for ( oldLib in oldVersion.usedLibs )
		{
			if(!newVersion.usedLibs.exists( oldLib.name ))
			{
				var update = {name:REMOVED_LIB, oldValue:oldLib.version, newValue:'0.0.0'};
				newVersion.addUpdatedLib( oldLib.name, update );
			}
		}
	}

	private function saveFile()
	{
		var content = parser.createFileContent( lockedVersions );

		var targetFilePath = Path.join([targetFolder, targetFile]);
		var fileOutput = File.write(targetFilePath, false);
		fileOutput.writeString( content );
		fileOutput.close();
		
		LogHelper.info(parser.createFileContent(lockedVersions));	
	}
}