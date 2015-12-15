package duell.versioning.objects;

enum LibChangeType
{
	VERSION;
	COMMITHASH;
}

typedef LockedLib = {
	name : String,
	type : String,
	version : String,
	commitHash : String
}

typedef Update = {
	name : LibChangeType,
	oldValue : String,
	newValue : String
}

class LockedVersion
{

	public static function getLibChangeType( value:String ) : LibChangeType
	{
		switch( value ){
			case 'version' : return VERSION;
			case 'commithash' : return COMMITHASH;
		}

		return null;
	}

	public var id(default, null) : String;
	public var ts(default, null) : Float;
	public var target(default, null) : String;
	public var usedLibs : Map<String, LockedLib>;
	public var updates : Map<String, Array<Update>>;

	public function new( id:String, ts:Float, target:String )
	{
		this.id = id;
		this.ts = ts;
		this.target = target;

		usedLibs = new Map<String, LockedLib>();
		updates = new Map<String, Array<Update>>();
	}

	public function addUsedLib( lib:LockedLib )
	{
		usedLibs.set( lib.name, lib );
	}

	public function addUpdatedLib( libName:String, change:Update )
	{
		if(!updates.exists( libName ))
		{
			updates.set(libName, new Array<Update>());
		}

		var list = updates.get( libName );
		list.push( change );
	}

}