/**
 * @autor rcam
 * @date 18.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.plugin.platform;

extern class LibraryBuild
{
	public var requiredSetups : Array<String>;

	public function new() : Void;

//	public function preParse() : Void; // First we need to parse before we can get Library plugins
	public function postParse() : Void;

	public function preBuild() : Void;
	public function postBuild() : Void;

	public function fast() : Void;
}