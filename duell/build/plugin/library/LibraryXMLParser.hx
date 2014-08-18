/**
 * @autor rcam
 * @date 18.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.plugin.platform;

import haxe.xml.Fast;

extern class LibraryXMLParser
{
	public static function parse(xml : Fast, parsingConditions : Array<String>) : Void;
}