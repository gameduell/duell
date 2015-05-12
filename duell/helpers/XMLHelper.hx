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

import haxe.xml.Fast;

using StringTools;

class XMLHelper
{
	public static function isValidElement(element : Fast, validatingConditions : Array<String>) : Bool
	{
        var processValue = function(value : String) : Array<Array<String>>
        {
            var andDefines = value.split("[and]");
            // if "||" is present, then attempt to use it for the splitting. Otherwise, default to splitting by "[or]"
			var optionalDefines = value.indexOf("||") != -1 ? value.split("||") : value.split("[or]");

            andDefines.map(function (str) return str.trim());
            andDefines = andDefines.filter(function (str) return str != "");

			optionalDefines.map(function (str) return str.trim());
			optionalDefines = optionalDefines.filter(function (str) return str != "");

            if (optionalDefines.length > 1 && andDefines.length > 1)
            {
                throw 'Chaining of [and] and [or] defines is not supported in element: "$value"';
            }

            var result = [];

            if (andDefines.length > 1)
            {
                result.push(andDefines);
            }
            else
            {
                for (requiredDefinesString in optionalDefines)
                {
                    var requiredDefines = requiredDefinesString.split(" ");
                    requiredDefines.map(function (str) return str.trim());
                    requiredDefines = requiredDefines.filter(function (str) return str != "");

                    if (requiredDefines.length != 0)
                        result.push(requiredDefines);
                }
            }

			return result;
        }

		var evaluateValue = function(optionalDefines : Array<Array<String>>) : Bool
		{
			var matchOptional = false;

			for (requiredDefines in optionalDefines)
			{
				var matchRequired = true;

				for (required in requiredDefines)
				{
					if (validatingConditions.indexOf(required) == -1)
					{
						matchRequired = false;
						break;
					}
				}

				if (matchRequired)
				{
					matchOptional = true;
					break;
				}
			}

			return matchOptional;
		}

		var unlessValid = true;
		var ifValid = true;

		if (element.has.resolve("if"))
		{
			var ifValueProcessed = processValue(element.att.resolve("if"));

			if (ifValueProcessed.length != 0)
	        	ifValid = evaluateValue(ifValueProcessed);
		}

		if (element.has.resolve("unless"))
		{
			var unlessValueProcessed = processValue(element.att.resolve("unless"));

			if (unlessValueProcessed.length != 0)
	        	unlessValid = !evaluateValue(unlessValueProcessed);
		}

		return ifValid && unlessValid;
	}
}
