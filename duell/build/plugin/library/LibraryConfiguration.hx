/**
 * @autor rcam
 * @date 04.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.plugin.library;

extern class LibraryConfigurationData {}

extern class LibraryConfiguration
{
	public static function getData() : LibraryConfigurationData;

	/// doesn't make sense to have this because the xml would have to be parsed, in order to find the defines for all libraries.
	//public static function getConfigParsingDefines() : Array<String>;
}