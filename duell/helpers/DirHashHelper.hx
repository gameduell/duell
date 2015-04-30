/**
 * @autor rcam
 * @date 29.04.2015.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.objects.DuellProcess;
import duell.objects.DuellLib;
import duell.helpers.PlatformHelper;
import haxe.io.Path;

using duell.helpers.HashHelper;

class DirHashHelper
{

	public static function getHashOfDirectory(path: String): Int
	{
		var process: DuellProcess;

		if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		{
		    var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();
			// ls binary is bundled for windows
			process = new DuellProcess(Path.join([duellLibPath, "bin"]), "ls.exe", ["-Rl", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}
		else
		{
			process = new DuellProcess(null, "ls", ["-Rl", path],
			{
				systemCommand : true,
				block : true,
				shutdownOnError : true,
				errorMessage: "hashing folder structure"
			});
		}

		return process.getCompleteStdout().toString().getFnv32IntFromString();
	}
}
