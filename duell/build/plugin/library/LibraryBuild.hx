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
	

	/// in this step you are supposed to add additional things to the main configuration
	public function postParse() : Void; 

	/// in this phase you should generate the derived data from parsing
	public function postPostParse() : Void;

	public function preBuild() : Void;
	public function postBuild() : Void;

	public function fast() : Void;

	public function clean() : Void;
}