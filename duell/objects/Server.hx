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

import haxe.io.Path;

import python.Tuple;
import python.Dict;
import python.KwArgs;
import python.flask.Flask;
import python.flask.FlaskLib;
import python.flask.Response;
import python.flask.Request;
import python.flask.ext.CORS;
import python.flask.logging.Logger;
import python.flask.Logging;

import duell.objects.TimeoutChecker;
import haxe.Constraints.Function;


class Server
{
	private var app: Flask;
    private var timeoutChecker: TimeoutChecker;
    private var path: String;

	private var timeout: Int;
	private var port: Int;
	private var block: Bool;
	private var thread: Dynamic;

	public function new(path: String, timeout: Int = 60, port: Int = 3000, block: Bool = false): Void
	{
		this.path = path;
		this.timeout = timeout;
		this.port = port;
		this.block = block;
	}

	public function shutdown(): Void
	{
		if (app != null)
		{
			python.urllib.Request.urlopen("http://localhost:" + port + "/killserver");
		}
	}

    public function GET()
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        return '<?xml version="1.0"?>
    	<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
    	<cross-domain-policy>
    	    <site-control permitted-cross-domain-policies="all"/>
    	    <allow-access-from domain="*" secure="false"/>
    	    <allow-http-request-headers-from domain="*" headers="*" secure="false"/>
    	</cross-domain-policy>
    	';
	}

    public function POST()
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        return "OK";
    }
    public function OPTIONS()
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        return "OK";
    }

    public function KILLSERVER()
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        var func: Void->Void = Request.environ.get('werkzeug.server.shutdown');
        func();
        return "OK";
    }

    public function GETFILE(filename: String)
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        return FlaskLib.send_from_directory(path, filename);
    }

    public function INDEXHTML()
    {
        if (timeoutChecker != null) timeoutChecker.tick();
        return FlaskLib.send_from_directory(path, "index.html");
    }


	public function start(): Void
	{
		thread = ThreadHelper.runInAThread(function()
		{
	        app = new Flask(untyped __name__);
	        new CORS(app);
	        app.route("/", {methods: ["GET"]})(INDEXHTML);
	        app.route("/crossdomain.xml", {methods: ["GET"]})(GET);
	        app.route("/<path:filename>", {methods: ["GET"]})(GETFILE);
	        app.route("/", {methods: ["POST"]})(POST);
	        app.route("/", {methods: ["OPTIONS"]})(OPTIONS);
	        app.route("/killserver")(KILLSERVER);

	        var timedout = false;
			var timeoutChecker = null;
			if (timeout > 0)
			{
		        timeoutChecker = new TimeoutChecker(timeout, function() {
		            try {
						if (app != null)
						{
		                	python.urllib.Request.urlopen("http://localhost:" + port + "/killserver");
						}
		            }
		            catch (error: Dynamic) {
		                trace(error);
		            }
		            timedout = true;
		        });
			}

			if (timeoutChecker != null) timeoutChecker.start();
	        app.run(port);
			app = null;
	        if (timeoutChecker != null) timeoutChecker.finish();
		});

		if (block)
		{
			thread.join();
		}
	}

	public function waitUntilFinished()
	{
		if (thread != null)
			thread.join();
	}
}
