/**
 * @autor rcam
 * @date 07.08.2014.
 * @company Gameduell GmbH
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
			var optionalDefines = value.indexOf("||") != -1 ? value.split("||") : value.split("[or]");

            andDefines.map(function (str) return str.trim());
            andDefines = andDefines.filter(function (str) return str != "");

			optionalDefines.map(function (str) return str.trim());
			optionalDefines = optionalDefines.filter(function (str) return str != "");

            if (optionalDefines.length > 1 && andDefines.length > 1)
            {
                LogHelper.error('Chaining of [and] and [or] defines is not supported in element: "$value"');
                return null;
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
