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

package duell.defines;


class DuellDefines
{
	public static var USER_CONFIG_FILENAME = 'duell_user.xml';
	public static var PROJECT_CONFIG_FILENAME = 'duell_project.xml';
	public static var LIB_CONFIG_FILENAME = 'duell_library.xml';
	public static var PLATFORM_CONFIG_FILENAME = 'duell_platform.xml';
	public static var DEFAULT_HXCPP_VERSION = "3.2.193";
    @:deprecated('use duell_api_level define instead')
	public static var HAXE_VERSION = "3.2.0";
    public static var ALLOWED_HAXE_VERSIONS = "3.2.0,3.2.1";
    /**
     * Incremental value unrelated to the git tag version.
     * It is added as a define -D duell_api_level=value for the build of the build plugins.
     * This value changes for example when hxcpp or haxe versions
     * change. It can be used to provide better backwards compatibility.
     **/
    public static var DUELL_API_LEVEL = 413;
}
