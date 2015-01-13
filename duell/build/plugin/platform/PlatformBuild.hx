/**
 * @autor rcam
 * @date 06.08.2014.
 * @company Gameduell GmbH
 */
package duell.build.plugin.platform;

extern class PlatformBuild
{
	public var requiredSetups : Array<String>;
	public var supportedHostPlatforms : Array<duell.helpers.PlatformHelper.Platform>;

	public function new() : Void;

    public function parse() : Void;
    public function prepareBuild() : Void;
	public function build() : Void;

	public function run() : Void;

	public function test() : Void;

	public function publish() : Void;

	public function fast() : Void;

	public function clean() : Void;
}
