/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
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
					process.close();
					
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
