/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.LogHelper;

using Std;

enum Preview {
	ALPHA;
	BETA;
	RC;	
}

class SemVer 
{
	public var major (default, null) : Int;
	public var minor (default, null) : Int;	
	public var patch (default, null) : Int;
	public var plus (default, null) : Bool;
	public function new(major, minor, patch, plus) 
	{
		this.major = major;
		this.minor = minor;
		this.patch = patch;
		this.plus = plus;

		if (this.major == null)
		{
			this.major = 0;
			this.plus = true;
			LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*");
		}

		if (this.minor == null)
		{
			this.minor = 0;
			this.plus = true;
			LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*");
		}

		if (this.patch == null)
		{
			this.patch = 0;
			this.plus = true;
			LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*");
		}
	}
	
	public function toString():String 
	{
		var ret = '';

		ret += '$major';

		ret += '.$minor';

		ret += '.$patch';

		if (plus)
		{
			ret += '+';
		}

		return ret;
	}
	static var parse = ~/^([0-9|\*]+)\.([0-9|\*]+)\.([0-9|\*]+)(\+)?$/;
	
	/// versions that do not respect the regexp will return null
	/// versions that respect the regexp, but are incosistent, will throw an exception 
	static public function ofString(s:String):SemVer 
	{
		if (s == null)
			return null;

		var major = null;
		var minor = null;
		var patch = null;
		var plus = false;

		if (parse.match(s.toLowerCase()))
		{ 
			if (parse.matched(1) != "*")
				major = parse.matched(1).parseInt();

			if (parse.matched(2) != "*")
				minor = parse.matched(2).parseInt();

			if (parse.matched(3) != "*")
				patch = parse.matched(3).parseInt();

			plus = 	switch parse.matched(4) 
							{
								case v if (v == null): false;
								case v: true;
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
			plus
		);
	}
 
	public static function areCompatible(left : SemVer, right : SemVer) : Bool
	{
		/// this is always false, even if both are "plus"
		if (left.major != right.major)
			return false;

		/// check if
		if (!left.plus && !right.plus)
			return left.minor == right.minor && left.patch == right.patch;

		/// this is always true if the major is the same
		if (left.plus && right.plus)
			return true;

		if (!left.plus)
		{
			if (left.minor > right.minor)
				return true;

			if (left.patch >= right.patch)
				return true;
		}
		else
		{
			if (right.minor > left.minor)
				return true;

			if (right.patch >= left.patch)
				return true;
		}

		return false;
	}

	public static function getMostSpecific(left : SemVer, right : SemVer) : SemVer
	{
		if (left.plus)
			return right;
		if (right.plus)
			return left;

		/// they are the same, so return the left
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

	    	output = offset * ver.major;

	    	offset = cast(offset / OFFSET_REDUCTION, Int);

	    	output += offset * ver.minor;

	    	offset = cast(offset / OFFSET_REDUCTION, Int);

	    	output += offset * ver.patch;

	    	return output;
	    }

    	var leftAccum = accumulator(left);
   		var rightAccum = accumulator(right);

    	return rightAccum - leftAccum;
	}
}