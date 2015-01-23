/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package duell.helpers;

import duell.helpers.StringHelper;

import duell.helpers.LogHelper;
import duell.objects.Arguments;

class AskHelper
{
	public static function askYesOrNo(question : String) : Bool 
	{

		while (true) 
		{
			LogHelper.print("\x1b[1m" + question + "\x1b[0m \x1b[3;37m[y/n]\x1b[0m? ");

			if (Arguments.isSet("-yestoall"))
			{
				LogHelper.println("y");
				return true;
			}
			switch(Sys.stdin().readLine()) 
			{
				case "n": return false;
				case "y": return true;
			}
		}

		return null;
	}

	public static function askString(question : String, defaultResponse : String) : String 
	{
		LogHelper.print("\x1b[1m" + question + "\x1b[0m \x1b[3;37m[" + defaultResponse + "]]\x1b[0m? ");

		if (Arguments.isSet("-yestoall"))
		{
			LogHelper.println(defaultResponse);
			return defaultResponse;
		}
		
		var response = Sys.stdin().readLine();
		response = StringHelper.strip(response);

		if(response == "")
			return defaultResponse;

		return response;
	}
}
