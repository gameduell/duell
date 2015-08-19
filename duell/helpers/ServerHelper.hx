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

class ServerHelper
{
    static var app: Flask;
    static var timeoutChecker: TimeoutChecker;
    static var serverDir: String;

    public static function GET()
    {
        timeoutChecker.tick();
        return '<?xml version="1.0"?>
    	<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
    	<cross-domain-policy>
    	    <site-control permitted-cross-domain-policies="all"/>
    	    <allow-access-from domain="*" secure="false"/>
    	    <allow-http-request-headers-from domain="*" headers="*" secure="false"/>
    	</cross-domain-policy>
    	';
	}

    public static function POST()
    {
        timeoutChecker.tick();
        return "OK";
    }
    public static function OPTIONS()
    {
        timeoutChecker.tick();
        return "OK";
    }

    public static function KILLSERVER()
    {
        timeoutChecker.tick();
        var func: Void->Void = Request.environ.get('werkzeug.server.shutdown');
        func();
        return "OK";
    }
    public static function GETFILE(filename: String)
    {
         return  FlaskLib.send_from_directory(serverDir , filename);
    }

    public static function runServer(path: String, port: Int,?block: Bool = false)
    {
        serverDir = path;
        if(!block)
        {
            ThreadHelper.runInAThread(function()
            {
                run(port);
            });
        }
        else
        {
            run(port);
        }
    }
    private static function run(port: Int): Void
    {
        app = new Flask(untyped __name__);
        new CORS(app);
        app.route("/crossdomain.xml", {methods: ["GET"]})(GET);
        app.route("/<path:filename>", {methods: ["GET"]})(GETFILE);
        app.route("/", {methods: ["POST"]})(POST);
        app.route("/", {methods: ["OPTIONS"]})(OPTIONS);
        app.route("/killserver")(KILLSERVER);

        var timedout = false;
        timeoutChecker = new TimeoutChecker(30, function() {
            try {
                python.urllib.Request.urlopen("http://localhost:" + port + "/killserver");
            }
            catch (error: Dynamic) {
                trace(error);
            }
            timedout = true;
        });

        timeoutChecker.start();
        app.run(port);
        timeoutChecker.finish();
    }


}
