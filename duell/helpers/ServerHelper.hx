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
import duell.objects.DuellProcess;

import haxe.io.Path;

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
											loggingPrefix : "[HTTP SERVER]",
                                            errorMessage: "running http server"
										});

		return serverProcess;
	}
}