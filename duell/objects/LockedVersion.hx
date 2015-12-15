package duell.objects;

Enum LibType
{
	HAXELIB;
	DUELLLIB;
}

Enum LibChangeType
{
	VERSION;
	COMMITHASH;
}

typedef LockedLib = {
	name : String,
	type : LibType,
	version : String,
	commitHash : String
}

typedef Update = {
	name : LibChangeType,
	oldValue : String;
	newValue : String
}

class LockedVersion
{
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
		updates = new Map<String, Array<Update>>;
	}

	public function addUsedLib( lib:LockedLib )
	{
		usedLibs.set( lib.name, lib );
	}

	public function addUpdatedLib( change:Update )
	{
		if(!updates.exists( change.name ))
		{
			updates.set(change.name, new Array<Update>());
		}

		list = updates.get( change.name );
		list.push( change );
	}

}