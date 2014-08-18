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

	public function preParse(args : Array<String>) : Void;
	public function postParse(args : Array<String>) : Void;
	public function preBuild(args : Array<String>) : Void;
	public function postBuild(args : Array<String>) : Void;
}
