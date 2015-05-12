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

package duell.objects;

import duell.helpers.DuellConfigHelper;
import duell.helpers.LogHelper;
import duell.helpers.GitHelper;
import duell.helpers.CommandHelper;

import sys.FileSystem;

import haxe.io.Path;

class DuellLibReference
{
	public var name : String;
	public var gitPath : String;
	public var libPath : String;
	public var destinationPath : String;

	public function new(name : String, gitPath : String, libPath : String, destinationPath : String)
	{
		this.name = name;
		this.gitPath = gitPath;
		this.libPath = libPath;
		this.destinationPath = destinationPath;
	}

    public function install()
    {
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        LogHelper.println("Installing lib " + name + "===============================================");
        LogHelper.println("Creating directory : [" + destinationPath + "]");

        var path = Path.join([duellConfigJSON.localLibraryPath, destinationPath]);

		LogHelper.println("Checking out library in directory : [" + destinationPath + "]");
        /// checkout
        if (FileSystem.exists(path))
        {
            if (GitHelper.pull(path) != 0 )
            {
                LogHelper.error("Can't Install library " + name);
            }
        }
        else
        {
            if(GitHelper.clone(gitPath, path) != 0 )
            {
                LogHelper.error("Can't Install library " + name);
            }
        }

        LogHelper.println("Setting repo as haxelib dev");

        CommandHelper.runHaxelib("", ["dev", "duell_" + name, duellConfigJSON.localLibraryPath + "/" + libPath], {errorMessage: "configuring 'haxelib dev' on the downloaded library"});

        LogHelper.info("Done Installing lib " + name +" ==========================================");
    }
}
