/**
 * @autor rcam
 * @date 24.09.2014.
 * @company Gameduell GmbH
 */
package duell.helpers;

import duell.objects.DuellLib;
import duell.objects.DuellProcess;
import duell.objects.PythonProcess;

import haxe.io.Path;
import haxe.io.Bytes;

import sys.io.File;
import sys.io.FileOutput;

class TestHelper
{
	public static function runListenerServer(timeout : Float, port : Int, resultOutputPath : String)
	{
		var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();

		var testProcess: DuellProcess = new PythonProcess(
										Path.join([duellLibPath, "bin"]),
										["test_result_listener.py", "" + port], 
										{
											systemCommand : true, 
											timeout : timeout, 
											loggingPrefix : "[TestListener]",
											block : true,
                                            errorMessage: "running test listener server"
										});

		if (testProcess.exitCode() != 0)
		{
			if (testProcess.isTimedout())
			{
				throw "Test listener timedout, output:\n" + testProcess.getCompleteStdout() + "\nstderr:\n" + testProcess.getCompleteStderr();

			}
			else
			{
				throw "Test listener failed with error code:" + testProcess.exitCode() + ", output:\n" + testProcess.readCurrentStdout() + "\nstderr:\n" + testProcess.getCompleteStderr();
			}
		}
		else
		{
			var bytes = testProcess.getCompleteStdout();

			var testResults = "test results:\n" + bytes.toString();
			LogHelper.info(testResults, "");
			
		    var fout = File.write(resultOutputPath, false);

		    fout.write(bytes);

		    fout.close();
		}
	}
}