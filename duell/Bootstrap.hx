/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell;

import sys.io.Process;
import sys.io.File;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.Json;

class Bootstrap
{
	private static var python: String = "python";
    public static function main()
    {
		/// import config
		python = Sys.getEnv("DUELL_PYTHON");

		if (python == null)
		{
			python = findPython();
			Sys.putEnv("DUELL_PYTHON", python);
		}

		/// run the tool
		runTheTool();
    }

	private static function findPython(): String
	{
		var execs = ["python3.4", "python3.3", "python3.2", "python"];

		for (exec in execs)
		{
			if (isPythonExecValid(exec))
				return exec;
		}

		Sys.stderr().write(Bytes.ofString(  "Error: Could not find a valid python 3 installation, " +
											"please make sure it is installed properly. " +
											"Executables tried were '" + execs.join(", ") + "'." +
											"If you have a non-standard Python 3 installation, " +
											"set DUELL_PYTHON environment variable to the full " +
											"path of your python3 executable."));

		Sys.exit(-1);

		return null;
	}

	private static function isPythonExecValid(pythonExec: String): Bool
	{
		var p = new Process(pythonExec, ["-V"]);
		var exitCode = p.exitCode();

		if (exitCode == 0)
		{
			var stdout = p.stdout.readAll().toString();
			var splitOutput = stdout.split(" ");

			if (splitOutput[0] == "Python")
			{
				var version = splitOutput[1].split(".");

				if (version.length > 0 && version[0] == "3")
				{
					p.close();
					return true;
				}
			}
		}

		p.close();
		return false;
	}

	private static function runTheTool(): Void
	{
		Sys.command (python, ["_duell.py"].concat(Sys.args()));
	}
}
