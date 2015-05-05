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

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.GitHelper;
import duell.helpers.DuellLibHelper;
import duell.objects.SemVer;

import sys.FileSystem;

using StringTools;

class DuellLib 
{
	public var name(default, null) : String;
	public var version(default, null) : String;

	private function new(name : String, version : String = "master")
	{
		this.name = name;
		this.version = version;
	}

	private static var duellLibCache : Map<String, Map<String, DuellLib> > = new Map<String, Map<String, DuellLib> >();
	public static function getDuellLib(name : String, version : String = "master") : DuellLib
	{
		if (version == null || version == "")
			throw 'Empty version is not allowed for $name library!';
		///add to the cache if it is not there
		if (duellLibCache.exists(name))
		{
			var versionMap = duellLibCache.get(name);
			if (!versionMap.exists(version))
			{
				versionMap.set(version, new DuellLib(name, version));
			}
		}
		else
		{
			var versionMap = new Map<String, DuellLib>();
			versionMap.set(version, new DuellLib(name, version));
			duellLibCache.set(name, versionMap);
		}

		///retrieve from the cache
		return duellLibCache.get(name).get(version);
	}

	public function isInstalled(): Bool
	{
    	return DuellLibHelper.isPathValid(name);
	}

	public function isPathValid() : Bool
	{
    	return DuellLibHelper.isPathValid(name);
	}

	public function getPath(): String
	{
    	return DuellLibHelper.getPath(name);
	}

    public function updateNeeded() : Bool
    {
    	return DuellLibHelper.updateNeeded(name);
    }

    public function update()
    {
    	return DuellLibHelper.update(name);
    }

    public function install()
    {
    	return DuellLibHelper.install(name);
    }


}