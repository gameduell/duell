/**
 * @autor kgar
 * @date 24.09.2014.
 * @company Gameduell GmbH
 */
package duell.helpers;
import sys.io.Process;
import duell.helpers.PlatformHelper;
import duell.objects.DuellProcess;

import haxe.io.Path;
import haxe.io.Eof;

class ServerHelper
{
	public function new()
	{
		
	}

	public static function runServer( serverTargetDirectory : String, buildPath : String) : DuellProcess
	{

 	    var serverPrefix : String = "";
 	    var archPrefix : String = "";
		var serverProcess : DuellProcess;

 		var serverDirectory : String = Path.join([buildPath,"bin","node","http-server","http-server"]);
 		var args:Array<String> = [Path.join([buildPath,"bin","node","http-server","http-server"]),serverTargetDirectory,"-p", "3000", "-c-1"];
 		
 		PathHelper.mkdir(serverTargetDirectory);

 	    switch(PlatformHelper.hostPlatform)
		{
			case Platform.WINDOWS : 
				serverPrefix =  "windows";
			case Platform.MAC : 
				serverPrefix =  "mac";
			case Platform.LINUX : 
				 serverPrefix =  "linux";
			default:                

		}
        
 	     switch(PlatformHelper.hostArchitecture)
	 	    {
	 	    	case Architecture.X86 : 
	 	    		archPrefix =  "32";
	 	    	case Architecture.X64 : 
	 	    		archPrefix =  "64";
	 	    	default:                

	 	    }

		if(serverPrefix != "linux")
			archPrefix = "";


		serverProcess = new DuellProcess(Path.join([buildPath,"bin","node"]), "node-"+serverPrefix+archPrefix, args,
										{
											systemCommand : false, 
											timeout : 0, 
											loggingPrefix : "[HTTP SERVER]",
											logOnlyIfVerbose : true
										});

		return serverProcess;
	}
}