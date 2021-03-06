package duell.versioning.locking.file;

import duell.versioning.objects.LockedVersion;

interface ILockingFileParser
{
	function parseFile( stringContent:String ) : Array<LockedVersion>;
	function createFileContent( objects:Array<LockedVersion> ) : String;
}