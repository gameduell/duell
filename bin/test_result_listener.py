#!/usr/bin/env python

import sys
import web
import json
import os
from urllib import quote, unquote

urls = ('(.*)', 'urlhandler')

app = web.application(urls, globals())

def rawRequest(env):
    raw_post_data = env['wsgi.input'].read(int(env['CONTENT_LENGTH']))
    post_data = None
    post_data = unquote(raw_post_data)

    if post_data.startswith("data="):
        return post_data[len("data="):]
    else:
        return post_data


class urlhandler:
    def OPTIONS(self, url):
        web.header('Access-Control-Allow-Origin',      '*')
        web.header('Access-Control-Allow-Credentials', 'true')
        web.header('Access-Control-Allow-Headers',
                   'origin, content-type, ' +
                   'accept, Access-Control-Allow-Credentials, ' +
                   'Access-Control-Allow-Origin')
        return ""

    def POST(self, url):
        web.header('Access-Control-Allow-Origin',      '*')
        web.header('Access-Control-Allow-Credentials', 'true')

        s = rawRequest(web.ctx.env)
        if s == "===START===":
            pass
        elif s == "===END===":
            app.stop()
        else:
            print s

        return "OK"

if __name__ == '__main__':
    print "Starting test listener..."
    app.run()
