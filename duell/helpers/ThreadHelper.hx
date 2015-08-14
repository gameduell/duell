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

import duell.helpers.LogHelper;

@:pythonImport("threading", "Thread")
extern class Thread
{
	public function new(group: Null<Int> = null, target: Void->Void): Void;
	public function start(): Void;
	public function join(): Void;
	public var daemon: Bool;
}

@:pythonImport("threading", "Lock")
extern class Lock
{
	public function acquire(blocking: Bool = true): Void;
	public function release(): Void;
}

@:pythonImport("threading")
extern class Threading
{
	public static function Lock(): Lock;
}

typedef Mutex = Lock;

class ThreadHelper
{
    static public function runInAThread(func: Void->Void): Thread
    {
		var thread = new Thread(function() {
			try {
				func();
			}
			catch(e: Dynamic)
			{
				LogHelper.exitWithFormattedError("Error in thread:" + Std.string(e));
			}
		});
		thread.daemon = true;
		thread.start();

		return thread;
    }

	static public function getMutex(): Mutex
	{
		return Threading.Lock();
	}
}
