/**
 * @autor rcam
 * @date 30.07.2014.
 * @company Gameduell GmbH
 */
 
package duell.helpers;

import sys.FileSystem;
import duell.helpers.ProcessHelper;

class GitHelper
{
	static public function setRemoteURL(path : String, remoteName : String, url : String) : Int
	{
		var result = ProcessHelper.runCommand(path, "git", ["remote", "set-url", remoteName, url]);

		return result;
	}

    static public function clone(gitURL : String, path : String) : Int
    {
		PathHelper.mkdir(path);

		var pathComponents = path.split("/");
		var folder = pathComponents.pop();
		path = pathComponents.join("/");

		var result = ProcessHelper.runCommand(path, "git", ["clone", gitURL, folder]);

        return result;
    }

    static public function pull(destination : String) : Int
    {
        var result : Int = 0;

        result = ProcessHelper.runCommand(destination, "git", ["pull"]);
        return result;
    }
}
