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

class HashHelper
{
    static public function getFnv32IntFromIntArray(array: Array<Int>): Int
    {
        var hash:Int = -2128831035;

        for (val in array)
        {
            hash *= 16777619;
            #if python
            hash %= 1073741824;
            #end
            hash ^= val;
        }

        return hash;
    }

    static public function getFnv32IntFromString(string: String): Int
    {
        var hash:Int = -2128831035;

        var fourChars = 0;

        var remainingChars = string.length % 4;
        var fourLength = Std.int((string.length - remainingChars) / 4);

        var val:Int = 0;

        for (i in 0...fourLength)
        {
            hash *= 16777619;

            #if python
            hash %= 1073741824;
            #end

            val ^= string.charCodeAt(i * 4);
            val ^= string.charCodeAt(i * 4 + 1) << 8;
            val ^= string.charCodeAt(i * 4 + 2) << 8;
            val ^= string.charCodeAt(i * 4 + 3) << 8;

            hash ^= val;
        }

        if (remainingChars > 0)
        {
            while (remainingChars > 0)
            {
                val ^= string.charCodeAt(string.length - remainingChars) << remainingChars * 8;
                remainingChars--;
            }
            hash ^= val;
        }

        return hash;
    }

    static inline public function getMD5OfFile(path: String): String
    {
        return getMD5OfFiles([path]);
    }

    static public function getMD5OfFiles(paths: Array<String>): String
    {
        python.Syntax.pythonCode("
        import hashlib

        m = hashlib.md5()
        for path in paths:
            with open(path, 'rb') as fh:
                while True:
                    data = fh.read(8192)
                    if not data:
                        break
                    m.update(data)
        return m.hexdigest()");
        return null;
    }
}
