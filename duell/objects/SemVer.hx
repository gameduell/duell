/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
			if (left.minor < right.minor)
				return false;

			if (left.patch < right.patch)
				return false;
		}
		else
		{
			if (right.minor < left.minor)
				return false;

			if (right.patch < left.patch)
				return false;
		}

		return true;
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

    private static inline var START_OFFSET = 10000000;
    private static inline var OFFSET_REDUCTION = 100;
	public static function compare(left : SemVer, right : SemVer) : Int
	{
	    var accumulator = function(ver : SemVer) : Int
	    {

	    	var output = 0;
	    	var offset = START_OFFSET;

	    	output = offset * ver.major;

	    	offset = Std.int(offset / OFFSET_REDUCTION);

	    	output += offset * ver.minor;

	    	offset = Std.int(offset / OFFSET_REDUCTION);

	    	output += offset * ver.patch;

	    	return output;
	    }

    	var leftAccum = accumulator(left);
   		var rightAccum = accumulator(right);

    	return rightAccum - leftAccum;
	}
}
