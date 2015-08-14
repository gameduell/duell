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

package duell.build.objects;

import duell.build.plugin.platform.PlatformConfiguration;

typedef ConfigurationData = {
	APP : {
		TITLE : String,
		FILE : String,
		VERSION : String,
		PACKAGE : String,
		COMPANY : String,
		BUILD_NUMBER : String
	},
	HAXE_COMPILE_ARGS : Array<String>,

	DEPENDENCIES : {
		DUELLLIBS : Array<{name : String, version : String}>,
		HAXELIBS : Array<{name : String, version : String}>
	},

	OUTPUT : String,
	PUBLISH : String,
	SOURCES : Array<String>,
	MAIN : String,
	PLATFORM : PlatformConfigurationData,

	LIBRARY : Dynamic,  /* anonymous structure that looks like, e.g.:
						{
							GRAPHICS : duell.build.plugin.library.LibraryConfigurationData,
							FILESYSTEM : duell.build.plugin.library.LibraryConfigurationData
						}
						*/

	NDLLS : Array<{NAME : String, BIN_PATH : String, BUILD_FILE_PATH : String, REGISTER_STATICS : Bool, DEBUG_SUFFIX : Bool}>,

	/// functions to be used during template processing on the macro parameter
	TEMPLATE_FUNCTIONS : Dynamic,

	TEST_PORT: Int
};

class Configuration
{

	private static var _configuration : ConfigurationData = null;
	public static function getData() : ConfigurationData
	{
		if (_configuration == null)
			_configuration = getDefaultConfig();
		return _configuration;
	}

	private static var _parsingDefines : Array<String> = ["duell"];
	public static function getConfigParsingDefines() : Array<String>
	{
		return _parsingDefines;
	}

	public static function addParsingDefine(define : String) : Void
	{
		_parsingDefines.push(define);
	}

	private static function getDefaultConfig() : ConfigurationData
	{
		return {
					APP : {
						TITLE : "Test Project",
						FILE : "TestProject",
						VERSION : "0.0.1",
						PACKAGE : "com.test.proj",
						COMPANY : "Test Company",
						BUILD_NUMBER : "1"
					},
					HAXE_COMPILE_ARGS : [],

					DEPENDENCIES : {
						DUELLLIBS : [],
						HAXELIBS : []
					},


					OUTPUT : haxe.io.Path.join([Sys.getCwd(), "Export"]),
					PUBLISH: haxe.io.Path.join([Sys.getCwd(), "Publish"]),
					SOURCES : [],
					MAIN : "Main",
					PLATFORM : PlatformConfiguration.getData(),
					LIBRARY : {},

					NDLLS : [],

					TEMPLATE_FUNCTIONS :
					{
						toJSON: function(_, s) return haxe.Json.stringify(s),
						upper: function (_, s) return s.toUpperCase (),
						replace: function (_, s, sub, by) return StringTools.replace(s, sub, by)
					},

					TEST_PORT: 8181
		};
	}
}
