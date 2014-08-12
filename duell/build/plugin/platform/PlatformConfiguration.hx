/**
 * @autor rcam
 * @date 04.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.plugin.platform;

/// THIS IS TO BE FILLED OUT BY PARSING THE PROJECT CONFIGURATION

extern class PlatformConfigurationData 
{
	public var PLATFORM_NAME : String;
}

extern class PlatformConfiguration
{
	public static function getData() : PlatformConfigurationData;

	public static function getConfigParsingDefines() : Array<String>;
}