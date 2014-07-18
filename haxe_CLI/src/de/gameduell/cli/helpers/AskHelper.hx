/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */

package de.gameduell.cli.helpers;

import de.gameduell.cli.helpers.StringHelper;

enum Answer 
{
	Yes;
	No;
}

class AskHelper
{
	public static function askYesOrNo(question : String) : Answer 
	{
		while (true) 
		{
			Sys.print("\x1b[1m" + question + "\x1b[0m \x1b[3;37m[y/n]\x1b[0m ?");
			
			switch(Sys.stdin().readLine()) 
			{
				case "n": return No;
				case "y": return Yes;
			}
		}

		return null;
	}

	public static function askString(question : String, defaultResponse : String) : String 
	{
		Sys.print("\x1b[1m" + question + "\x1b[0m \x1b[3;37m[" + defaultResponse + "]]\x1b[0m ?");

		var response = Sys.stdin().readLine();
		response = StringHelper.strip(response);

		if(response == "")
			return defaultResponse;

		return response;
	}
}
