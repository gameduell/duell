/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
package duell.helpers;

import duell.objects.DuellProcess;

/**   
   @author jxav
 */
@:keepInit
class BuildTagHelper
{
    public static function tag(): String
    {
        var timestamp: String = DateTools.format(Date.now(), "%Y-%m-%d_%H-%M-%S");

        var process = new DuellProcess(null,
            "git",
            ["log", "--oneline", "--max-count=1"],
            {
                systemCommand : true,
                block : true,
                shutdownOnError : true,
                errorMessage: "getting commit hash"
            });

        var revision: String = process.getCompleteStdout().toString().split(" ")[0];

        var tag: String = '${timestamp}__Rev_$revision';

        return tag;
    }
}
