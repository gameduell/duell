/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.DuellConfigHelper;
import duell.helpers.LogHelper;
import duell.helpers.GitHelper;
import duell.helpers.CommandHelper;

import sys.FileSystem;

import haxe.io.Path;

class DuellLibReference 
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

    public function install()
    {
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Installing lib " + name + "===============================================");
        LogHelper.println("Creating directory : [" + destinationPath + "]");

        var path = Path.join([duellConfigJSON.localLibraryPath, destinationPath]);


        /// checkout 
        if (FileSystem.exists(path))
        {
            if (GitHelper.pull(path) != 0 )
            {
                LogHelper.error("Can't Install library " + name);
            }
        }
        else
        {
            if(GitHelper.clone(gitPath, path) != 0 )
            {
                LogHelper.error("Can't Install library " + name);
            }
        }

        LogHelper.println("Setting repo as haxelib dev");

        CommandHelper.runCommand(path, "haxelib", ["dev", name, duellConfigJSON.localLibraryPath + "/" + libPath]);

        LogHelper.info("Done Installing lib " + name +" ==========================================");
    }
}