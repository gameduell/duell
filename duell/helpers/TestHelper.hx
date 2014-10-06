/**
 * @autor rcam
 * @date 24.09.2014.
 * @company Gameduell GmbH
 */
package duell.helpers;

import sys.io.Process;

import duell.helpers.PlatformHelper;
import duell.objects.DuellLib;

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
 	    var serverPrefix : String = "";
 	    var archPrefix : String = "";
		var testProcess : Process;

		var duellLibPath = DuellLib.getDuellLib("duell").getPath();

 		var testerDirectory : String = Path.join([duellLibPath, "bin", "test_result_listener.py"]);
 		var args = [Path.join([duellLibPath, "bin", "test_result_listener.py"]), "" + port];

 		LogHelper.info("Launching test listener", 'Launching test listener with command "python ${args.join(" ")}"');
 		testProcess = new Process("python", args);


		var buffer = new BytesOutput();

		var threadPoke = false; /// every time the thread lives it will "poke" this boolean
		var threadFinished = false;
		var continueToProcessThread = true;

		var thread : Thread = null;
		thread = Thread.create(
			function()
			{
				while(continueToProcessThread)
				{
					try
					{
						var newMessage = testProcess.stdout.readLine();
						trace("from thread:" + newMessage);
						thread.sendMessage(newMessage);
						if(newMessage.length == 0)
						{
							break;
						}
						else
						{
							buffer.writeString(newMessage + "\n");
							threadPoke = true;
						}
					}
					catch (e:Eof) 
					{
						break;
					}
				}

				threadFinished = true;
			}
		);

		while (!threadFinished) 
		{
			threadPoke = false;
			Sys.sleep(timeout);

			if(!threadPoke)
			{
				continueToProcessThread = false;
				testProcess.kill();
				throw "Test listener timed out output so far was:\n" + buffer.getBytes();
			}
		}
		
		var result = testProcess.exitCode();
		testProcess.close();

		var bytes = buffer.getBytes();

		if (result != 0)
		{
			throw "Test listener failed with error code:" + result + ", output:\n" + bytes;
		}
		else
		{
		    var fout = File.write(resultOutputPath, false );

		    fout.write(bytes);

		    fout.close();
		}
	}
}