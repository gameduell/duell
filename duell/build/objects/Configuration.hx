/**
 * @autor rcam
 * @date 04.08.2014.
 * @company Gameduell GmbH
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
	TEMPLATE_FUNCTIONS : Dynamic
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
					LIBRARY : [],

					NDLLS : [],

					TEMPLATE_FUNCTIONS :
					{
						toJSON: function(_, s) return haxe.Json.stringify(s),
						upper: function (_, s) return s.toUpperCase (),
						replace: function (_, s, sub, by) return StringTools.replace(s, sub, by)
					}
		};
	}
}
