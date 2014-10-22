/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

using Std;

enum Preview {
	ALPHA;
	BETA;
	RC;	
}

class SemVer 
{
	public var major (default, null) : Null<Int>;
	public var minor (default, null) : Null<Int>;	
	public var patch (default, null) : Null<Int>;
	public var preview (default, null) : Null<Preview>;
	public var previewNum (default, null) : Null<Int>;
	public function new(major, minor, patch, ?preview, ?previewNum) 
	{
		this.major = major;
		this.minor = minor;
		this.patch = patch;
		this.preview = preview;
		this.previewNum = previewNum;

		if ((patch != null && minor == null) || (patch != null && major == null) || (major == null && minor != null))
			throw "Semantic version can't have undetermined minor/major and determined patch/minor. 1.*.1 or *.*.1 is not valid, only 1.1.* or 1.*.*";

		if ((major == null || minor == null || patch == null) && (preview != null || previewNum != null))
			throw "Semantic version can't have undetermined patch/minor/major and specified preview/previewNum";
	}
	
	public function toString():String 
	{
		var ret = '';

		if (major != null)
			ret += '$major';
		else
			ret += '*';

		if (minor != null)
			ret += '.$minor';
		else
			ret += '.*';

		if (patch != null)
			ret += '.$patch';
		else
			ret += '.*';

		if(preview != null) 
		{
			ret += '-' + preview.getName().toLowerCase();
			if (previewNum != null) 
			{
				ret += '.' + previewNum;
			}
		}
		return ret;
	}
	static var parse = ~/^([0-9|\*]+)\.([0-9|\*]+)\.([0-9|\*]+)(-(alpha|beta|rc)(\.([0-9]+))?)?$/;
	
	/// versions that do not respect the regexp will return null
	/// versions that respect the regexp, but are incosistent, will throw an exception 
	static public function ofString(s:String):SemVer 
	{
		if (s == null)
			return null;

		var major = null;
		var minor = null;
		var patch = null;
		var preview = null;
		var previewNum = null;

		if (parse.match(s.toLowerCase()))
		{ 
			if (parse.matched(1) != "*")
				major = parse.matched(1).parseInt();

			if (parse.matched(2) != "*")
				minor = parse.matched(2).parseInt();

			if (parse.matched(3) != "*")
				patch = parse.matched(3).parseInt();

			preview = 	switch parse.matched(5) 
						{
							case 'alpha': ALPHA;
							case 'beta': BETA;
							case 'rc': RC;
							case v if (v == null): null;
							case v: return null;
						};

			previewNum = 	switch parse.matched(7) 
							{
								case v if (v == null): null;
								case v: v.parseInt();
							}
		}
		else
		{
			return null;
		}

		return new SemVer(
			major,
			minor,
			patch,
			preview,
			previewNum
		);
	}
 
	public static function areCompatible(left : SemVer, right : SemVer) : Bool
	{
		if (left.major != right.major)
			return false;

		if (left.minor == null || right.minor == null)
			return true;

		if (left.patch == null || right.patch == null)
			return true;

		return 	left.major == right.major &&
				left.minor == right.minor &&
				left.patch == right.patch &&
				left.preview == right.preview &&
				left.previewNum == right.previewNum;
	}

	public static function getMostSpecific(left : SemVer, right : SemVer) : SemVer
	{
		/// MAJOR
		if (left.major == null)
			return left;

		if (right.major == null)
			return right;

		/// MINOR
		if (left.minor == null)
			return left;

		if (right.minor == null)
			return right;

		/// PATCH
		if (left.patch == null)
			return left;

		if (right.patch == null)
			return right;

		return left;
	}



    private static inline var START_OFFSET = 1000000000;
    private static inline var OFFSET_REDUCTION = 100;
	public static function compare(left : SemVer, right : SemVer) : Int
	{

	    var accumulator = function(ver : SemVer) : Int
	    {
	    	var output = 0;
	    	var offset = START_OFFSET;

	    	if (ver.major == null)
	    	{
	    		output = (offset * OFFSET_REDUCTION) - 1;
	    		return output;
	    	}
	    	else
	    	{
	    		output = offset * ver.major;
	    	}

	    	offset = cast(offset / OFFSET_REDUCTION, Int);

	    	if (ver.minor == null)
	    	{
	    		output += (offset * OFFSET_REDUCTION) - 1;
	    		return output;
	    	}
	    	else
	    	{
	    		output += offset * ver.minor;
	    	}

	    	offset = cast(offset / OFFSET_REDUCTION, Int);

	    	if (ver.patch == null)
	    	{
	    		output += (offset * OFFSET_REDUCTION) - 1;
	    		return output;
	    	}
	    	else
	    	{
	    		output += offset * ver.patch;
	    	}

	    	offset = cast(offset / OFFSET_REDUCTION, Int);

	    	if (ver.preview == null)
	    	{
	    		output += offset * 10; /// release version is higher
	    		return output;
	    	}
	    	if (ver.preview != null)
	    	{
	    		output += offset * ver.preview.getIndex();
	    	}

	    	offset = cast(offset / OFFSET_REDUCTION, Int);
	    	if (ver.previewNum != null)
	    	{
	    		output += offset * ver.previewNum;
	    	}


	    	return output;
	    }

    	var leftAccum = accumulator(left);
   		var rightAccum = accumulator(right);

    	return rightAccum - leftAccum;
	}
}