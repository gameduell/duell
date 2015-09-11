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

package duell.helpers;

import duell.helpers.PlatformHelper;

import sys.io.Process;

enum Platform
{
	ANDROID;
	BLACKBERRY;
	FIREFOXOS;
	FLASH;
	HTML5;
	IOS;
	LINUX;
	MAC;
	TIZEN;
	WINDOWS;
	WEBOS;
	EMSCRIPTEN;
	MACANE;
}

enum Architecture
{
	ARMV5;
	ARMV6;
	ARMV7;
	X86;
	X64;
}

class PlatformHelper
{
	public static var hostArchitecture(get_hostArchitecture, null) : Architecture;
	public static var hostPlatform(get_hostPlatform, null) : Platform;

	private static var _hostArchitecture : Architecture;
	private static var _hostPlatform : Platform;

	private static function get_hostArchitecture() : Architecture
	{
		if (_hostArchitecture == null)
		{
			switch (hostPlatform)
			{
				case WINDOWS:

					var architecture = Sys.getEnv("PROCESSOR_ARCHITEW6432");
					if(architecture != null && architecture.indexOf("64") > -1)
					{
						_hostArchitecture = Architecture.X64;
					}
					else
					{
						_hostArchitecture = Architecture.X86;
					}

				case LINUX, MAC:

					var process = new Process("uname", [ "-m" ]);
					var output = process.stdout.readAll().toString();
					var error = process.stderr.readAll().toString();
					process.exitCode();
					//process.close();

					if (output.indexOf ("64") > -1)
					{
						_hostArchitecture = Architecture.X64;

					}
					else
					{
						_hostArchitecture = Architecture.X86;
					}

				default:

					_hostArchitecture = Architecture.ARMV6;

			}

			LogHelper.info("", " - \x1b[1mDetected host architecture:\x1b[0m " + StringHelper.formatEnum(_hostArchitecture));
		}

		return _hostArchitecture;
	}


	private static function get_hostPlatform() : Platform
	{
		if (_hostPlatform == null)
		{
			var systemName = Sys.systemName();

			if (new EReg("window", "i").match(systemName))
			{
				_hostPlatform = Platform.WINDOWS;
			}
			else if (new EReg("linux", "i").match(systemName))
			{
				_hostPlatform = Platform.LINUX;
			}
			else if (new EReg("mac", "i").match(systemName))
			{
				_hostPlatform = Platform.MAC;
			}

			var platformName : String = StringHelper.formatEnum(_hostPlatform);
			LogHelper.info("", " - \x1b[1mDetected host platform:\x1b[0m " + platformName);
		}

		return _hostPlatform;
	}


}
