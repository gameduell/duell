package duell.versioning.locking;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

import duell.helpers.LogHelper;
import duell.helpers.GitHelper;
import duell.objects.Haxelib;
import duell.objects.DuellLib;
import duell.versioning.objects.LockedVersion;
import duell.versioning.locking.file.ILockingFileParser;
import duell.versioning.locking.file.LockingFileXMLParser;

typedef LockedLibraries = {
	duelllibs : Array<DuellLib>,
	haxelibs : Array<Haxelib>
}

class LockedVersionsHelper
{
	private static inline var DEFAULT_FOLDER = 'versions';
	private static inline var DEFAULT_FILE = 'lockedVersions.xml';

	private static var versionMap = new Map<String, LockedVersions>();

	public static function getLastLockedVersion( path:String ) : LockedLibraries 
	{
		path = path == '' ? Path.join([Sys.getCwd(), DEFAULT_FOLDER, DEFAULT_FILE]) : path;

		if(!versionMap.exists( path ))
		{
			var versions = new LockedVersions(new LockingFileXMLParser(), path);
			versions.loadAndParseFile();

			versionMap.set( path, versions );
		}

		var versions = versionMap.get( path );

		return versions.getLastLockedLibraries();
	}

	public static function addLockedVersion( duelllibs:Array<DuellLib>, haxelibs:Array<Haxelib>, path:String='' )
	{
		path = path == '' ? Path.join([Sys.getCwd(), DEFAULT_FOLDER, DEFAULT_FILE]) : path;

		if(!versionMap.exists( path ))
		{
			var versions = new LockedVersions(new LockingFileXMLParser(), path);
			versions.setupFileSystem();
			versions.loadAndParseFile();

			versionMap.set(path, versions);
		}

		var versions = versionMap.get( path );
		versions.addLibraries( duelllibs, haxelibs );
	}
}


class LockedVersions 
{
	private static inline var NUMBER_MAX_TRACKED_VERSIONS : Int = 5;

	public var lockedVersions(default, null) : Array<LockedVersion>;
	private var parser : ILockingFileParser;
	private var path : String;

	public function new( parser:ILockingFileParser, path:String )
	{
		lockedVersions = new Array<LockedVersion>();
		this.parser = parser;
		this.path = path;
	}

	public function setupFileSystem()
	{
		var dir = Path.directory( path );
		if(!FileSystem.exists( dir ))
		{
			FileSystem.createDirectory( dir );
		}
	}

	public function loadAndParseFile()
	{
		if(FileSystem.exists( path ))
		{
			var stringContent = File.getContent( path );
			lockedVersions = parser.parseFile( stringContent );
		}
		else
		{
			LogHelper.exitWithFormattedError("File does not exist: '" + path + "'");
		}
	}

	public function getLastLockedVersion() : LockedVersion
	{
		var version : LockedVersion = null;
		for ( lv in lockedVersions )
		{
			version = version != null ? lv.ts > version.ts ? lv : version : lv;
		}

		return version;
	}

	public function addLibraries( duell:Array<DuellLib>, haxe:Array<Haxelib> )
	{
		var lastLockedVersion = getLastLockedVersion();
		var now = Date.now();
		var currentVersion = new LockedVersion( now.getTime() );

		//create used libs
		for ( dLib in duell )
		{
			var currentCommit = GitHelper.getCurrentCommit( dLib.getPath() );
			var lockedLib = {name:dLib.name, type:'duelllib', version:dLib.version, commitHash:currentCommit};
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

		checkNumberTrackedVersions();

		saveFile();
	}

	public function getLastLockedLibraries() : LockedLibraries
	{
		var libraries = getLastLockedVersion();
		var usedLibraries = libraries != null ? libraries.usedLibs : new Map<String, LockedLib>();

		var dLibs = new Array<DuellLib>();
    	var hLibs = new Array<Haxelib>();

    	for ( key in usedLibraries.keys() )
    	{
    		var lockedLib = usedLibraries.get( key );
    		switch( lockedLib.type )
    		{
    			case 'duelllib':
    				 dLibs.push(DuellLib.getDuellLib(lockedLib.name, lockedLib.version, lockedLib.commitHash)); 
    			case 'haxelib':
    				 hLibs.push(Haxelib.getHaxelib(lockedLib.name, lockedLib.version));
			}
    	}

    	return { duelllibs:dLibs, haxelibs:hLibs };
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

	private function checkNumberTrackedVersions()
	{
		var num = lockedVersions.length - NUMBER_MAX_TRACKED_VERSIONS;
		if( num > 0 )
		{
			lockedVersions.splice(0, num);
		}
	}

	private function saveFile()
	{
		var content = parser.createFileContent( lockedVersions );

		var fileOutput = File.write(path, false);
		fileOutput.writeString( content );
		fileOutput.close();
		
		LogHelper.info(parser.createFileContent( lockedVersions ));
	}
}