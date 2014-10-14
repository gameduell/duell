/**
 * @autor rcam
 * @date 30.07.2014.
 * @company Gameduell GmbH
 */
 
package duell.helpers;

import duell.objects.DuellProcess;

class GitHelper
{
	static public function setRemoteURL(path : String, remoteName : String, url : String) : Int
	{
        var gitProcess = new DuellProcess(
                                        path,
                                        "git", 
                                        ["remote", "set-url", remoteName, url], 
                                        {
                                            systemCommand : true, 
                                            loggingPrefix : "[Git]"
                                        });
        gitProcess.blockUntilFinished();

		return gitProcess.exitCode();
	}

    static public function clone(gitURL : String, path : String) : Int
    {
		PathHelper.mkdir(path);

		var pathComponents = path.split("/");
		var folder = pathComponents.pop();
		path = pathComponents.join("/");

        var gitProcess = new DuellProcess(
                                        path,
                                        "git", 
                                        ["clone", gitURL, folder], 
                                        {
                                            systemCommand : true, 
                                            loggingPrefix : "[Git]"
                                        });
        gitProcess.blockUntilFinished();

        return gitProcess.exitCode();
    }

    static public function pull(destination : String) : Int
    {
        var gitProcess = new DuellProcess(
                                        destination,
                                        "git", 
                                        ["pull"], 
                                        {
                                            systemCommand : true, 
                                            loggingPrefix : "[Git]"
                                        });
        gitProcess.blockUntilFinished();

        return gitProcess.exitCode();
    }

    static public function updateNeeded(destination : String) : Bool
    {
        var result : String = "";

        var gitProcess = new DuellProcess(
                                        destination,
                                        "git", 
                                        ["remote", "update"], 
                                        {
                                            systemCommand : true,
                                            loggingPrefix : "[Git]"
                                        });
        gitProcess.blockUntilFinished();

        gitProcess = new DuellProcess(
                                        destination,
                                        "git", 
                                        ["status", "-b", "master", "--porcelain"], 
                                        {
                                            systemCommand : true,
                                            loggingPrefix : "[Git]"
                                        });
        gitProcess.blockUntilFinished();
        var output = gitProcess.getCompleteStdout().toString();

        if (output.indexOf("behind") != -1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
