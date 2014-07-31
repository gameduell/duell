/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

class DuellLib 
{
	public var name : String;
	public var gitPath : String;
	public var libPath : String;
	public var destinationPath : String;

	public function new(name : String, gitPath : String, libPath : String, destinationPath : String)
	{
		this.name = name;
		this.gitPath = gitPath;
		this.libPath = libPath;
		this.destinationPath = destinationPath;
	}
}