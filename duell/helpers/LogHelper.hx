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
 
package duell.helpers;

import duell.helpers.PlatformHelper;
import duell.objects.Arguments;

import neko.Lib;
import haxe.io.Bytes;
import sys.io.Process;

class LogHelper 
{		
	public static var enableColor(get, null): Bool;
	public static var mute(get, null): Bool;
	public static var verbose(get, null): Bool;
	
	private static var colorCodes : EReg = ~/\x1b\[[^m]+m/g;
	private static var colorSupported : Null<Bool> = null;
	private static var sentWarnings : Map<String, Bool> = new Map<String, Bool>();

	public static inline var RED = "\x1b[31;1m";
	public static inline var YELLOW = "\x1b[33;1m";
	public static inline var NORMAL = "\x1b[0m";
	public static inline var BOLD = "\x1b[1m";
	public static inline var UNDERLINE = "\x1b[4m";

	public static function get_enableColor(): Bool
	{
		return !Arguments.isSet("-nocolor");
	}

	public static function get_mute(): Bool
	{
		return Arguments.isSet("-mute");
	}

	public static function get_verbose(): Bool
	{
		return Arguments.isSet("-verbose");
	}
	
	public static function error(message : String, verboseMessage : String = "", e : Dynamic = null) : Void 
	{	
		if (message != "" && !mute)
		{
			var output;
			if(verbose && verboseMessage != "") 
			{	
				output = "\x1b[31;1mError:\x1b[0m\x1b[1m " + verboseMessage + "\x1b[0m\n";	
			} 
			else
			{	
				output = "\x1b[31;1mError:\x1b[0m \x1b[1m" + message + "\x1b[0m\n";	
			}
			
			Sys.stderr().write(Bytes.ofString(stripColor(output)));
		}
		
		Sys.exit(-1);
	}
	
	public static function info(message : String, verboseMessage : String = "") : Void 
	{
		if (!mute) 
		{
			if (verbose && verboseMessage != "") 
			{
				println (verboseMessage);
			} 
			else if (message != "") 
			{
				println (message);
			}
		}
	}

	public static function print(message : String) : Void 
	{	
		Sys.print(stripColor(message));	
	}
	
	public static function println(message : String) : Void 
	{
		Sys.println(stripColor(message));
	}
	
	public static function warn(message : String, verboseMessage : String = "", allowRepeat : Bool = false) : Void 
	{
		if(!mute) 
		{
			var output = "";
			
			if (verbose && verboseMessage != "")
			{
				output = "\x1b[33;1mWarning:\x1b[0m \x1b[1m" + verboseMessage + "\x1b[0m";
				
			} 
			else if (message != "")
			{
				output = "\x1b[33;1mWarning:\x1b[0m \x1b[1m" + message + "\x1b[0m";
			}
			
			if (!allowRepeat && sentWarnings.exists(output)) 
				return;
			
			sentWarnings.set (output, true);
			println (output);
		}
	}

	private static function stripColor(output : String) : String 
	{	
		if (colorSupported == null) 
		{
			if (PlatformHelper.hostPlatform != Platform.WINDOWS) 
			{
				var result = -1;
				
				try {
					var process = new Process("tput", [ "colors" ]);
					result = process.exitCode();
					process.close();
				
				} catch (e:Dynamic) {};
				
				colorSupported = (result == 0);
			} 
			else 
			{
				colorSupported = (Sys.getEnv("ANSICON") != null);
			}
			
		}

		if (enableColor && colorSupported) 
			return output;
		else 
		{
			try {
				return colorCodes.replace(output, "");
			} catch (e:Dynamic) {
				trace("error on color replace");
				return output;
			};
		}
	}
}
