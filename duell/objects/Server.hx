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

import duell.helpers.ThreadHelper;

import python.http.server.SimpleHTTPRequestHandler;
import python.socketserver.TCPServer;

import python.Tuple;

import haxe.io.Path;

class Server
{
	private var path: String;
	private var server: TCPServer;
	private var thread: Thread;
	public function new(path: String): Void
	{
		this.path = path;
	}

	public function shutdown(): Void
	{
		server.shutdown();
	}

	public function start(): Void
	{
		thread = ThreadHelper.runInAThread(function(){
			var workingDir = Sys.getCwd();

			Sys.setCwd(path);
			var handler = SimpleHTTPRequestHandler;
			for (key in handler.extensions_map.keys())
			{
				handler.extensions_map.set(key, handler.extensions_map.get(key) + ';charset=UTF-8');
			}

			server = new TCPServer(new Tuple<Dynamic>(["", 3000]), handler);
		    server.serve_forever();

			Sys.setCwd(workingDir);
		});
	}

	public function waitUntilFinished(): Void
	{
		thread.join();
	}
}
