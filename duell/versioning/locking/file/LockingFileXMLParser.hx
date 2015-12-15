package duell.versioning.locking.file;

import haxe.xml.Fast;
import duell.helpers.LogHelper;
import duell.versioning.objects.LockedVersion;

/**
 * Class LockingFileXMLParser
 * 
 * File creates and parses xml files of the content listed below.
 *
 * <builds>
 * 	<build id="12345" date="123456789" target="android">
 * 		<libs>
 * 			<duelllib name="NAME1" version="1.0.0" commitHash="" />
 * 			<duelllib name="NAME2" version="2.0.0" commitHash="" />
 * 		</libs>
 * 		<updates>
 * 			<update name="NAME1">
 * 				<version oldValue="0.0.0" newValue="1.0.0" />
 * 			</update>
 * 			
 *			<update name="NAME2">
 * 				<commitHash oldValue="45asdf874asdfasf4asd5fas7f1gsh7d4" newValue="4578asdfbsvy656asdfasdfas" />
 * 			</update>
 * 		</updates>
 *	</build>
 * </builds>
**/
class LockingFileXMLParser implements ILockingFileParser
{
	
	private var builds : Array<LockedVersion>;

	public function new(){}

	public function getInitialInput() : String 
	{
		return '<?xml version="1.0" encoding="utf-8"?>\n<builds>\n</builds>';
	}

	public function parseFile( stringContent:String ) : Array<LockedVersion>
	{
		if( stringContent == null || stringContent.length == 0 )
			return new Array<LockedVersion>();

		builds = new Array<LockedVersion>();
		var xmlContent = new Fast(Xml.parse( stringContent ).firstElement());
		parse( xmlContent );

		return builds;
	}

	private function parse( source:Fast )
	{
		for (element in source.elements)
		{
			switch ( element.name )
			{
				case 'build':
					 parseBuild( element );
			}
		}
	}

	private function parseBuild( element:Fast )
	{
		var id = element.has.id ? element.att.id : '';
		var ts = element.has.date ? element.att.date : '0';
		var target = element.has.target ? element.att.target : 'none';

		var build = new LockedVersion( id, Std.parseFloat(ts), target );

		LogHelper.info("First build: " + id + " " + ts + " " + target);
		
		for ( child in element.elements ){
			switch( child.name )
			{
				case 'libs':
					 parseLibs( build, child );

				case 'updates':
					 parseChanges( build, child );
			}
		}

		builds.push( build );
	}

	private function parseLibs( currentBuild:LockedVersion, element:Fast )
	{
		for ( e in element.elements )
		{
			var type = e.name;
			var name = e.has.name ? e.att.name : '';
			var version = e.has.version ? e.att.version : "0.0.0";
			var commitHash = e.has.commitHash ? e.att.commitHash : '';

			currentBuild.addUsedLib( {type:type, name:name, version:version, commitHash:commitHash} );
		}
	}

	private function parseChanges( currentBuild:LockedVersion, element:Fast )
	{
		for ( l in element.elements )
		{
			var libname = l.has.name ? l.att.name : '';
			
			for ( c in l.elements )
			{
				var changeType = c.name;
				var oldValue = c.has.oldValue ? c.att.oldValue : '';
				var newValue = c.has.newValue ? c.att.newValue : '';

				currentBuild.addUpdatedLib( libname, {name:LockedVersion.getLibChangeType( changeType ), oldValue:oldValue, newValue:newValue });
			}
		}
	}

	public function createFileContent( objects:Array<LockedVersion> ) : String
	{
		var result = '';
		var buildResult : String;
		for ( i in 0...objects.length )
		{
			var b = objects[i];
			var libs = getLibsContent( b.usedLibs );
			var changes = getUpdatedContent( b.updates );

			buildResult = '  <build id="' + b.id + '" date="' + b.ts + '" target="' + b.target + '" >\n';
			buildResult += '    <libs>\n' + libs + '    </libs>\n';
			buildResult += '    <updates>\n' + changes + '    </updates>\n';
			buildResult += '  </build>\n';

			result += buildResult;
		}

		return '<?xml version="1.0" encoding="utf-8"?>\n<builds>\n' + result + '</builds>';
	}

	private function getLibsContent( libs:Map<String, LockedLib> ) : String
	{
		var result : String = '';

		for ( key in libs.keys() )
		{
			var lib = libs.get( key );
			result += '      <'+ lib.type + ' name="' + lib.name + '" version="' + lib.version + '" ' + (lib.commitHash != "" ? 'commithash="' + lib.commitHash + '" ' : '') + '/>\n';
		}

		return result;
	}

	private function getUpdatedContent( updates:Map<String, Array<Update>> ) : String
	{
		var result : String = '';

		for ( key in updates.keys() )
		{
			var changes = updates.get( key );
			var changeList : String = "";
			for ( u in changes )
			{
				changeList += '        <' + u.name + ' oldValue="' + u.oldValue + '" newValue="' + u.newValue + '" />\n';
			}

			result += '      <update name="' + key + '">\n' + changeList + '      </update>\n';
		}

		return result;
	}
}