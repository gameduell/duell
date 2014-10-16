/**
 * @autor rcam
 * @date 24.09.2014.
 * @company Gameduell GmbH
 */
package duell.helpers;

import duell.helpers.PlatformHelper;
import duell.objects.DuellLib;

import duell.objects.DuellProcess;

import haxe.io.BytesOutput;
import haxe.io.Path;
import haxe.io.Eof;
import haxe.io.Bytes;
import haxe.Timer;

import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

import neko.vm.Thread;

class TestHelper
{
	public static function runListenerServer(timeout : Float, port : Int, resultOutputPath : String)
	{
		var duellLibPath = DuellLib.getDuellLib("duell").getPath();
		var testProcess = new DuellProcess(
										Path.join([duellLibPath, "bin"]),
										"python", 
										["test_result_listener.py", "" + port], 
										{
											systemCommand : true, 
											timeout : timeout, 
											loggingPrefix : "[TestListener]",
											block : true
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