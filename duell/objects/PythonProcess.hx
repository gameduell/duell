/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
package duell.objects;

import duell.helpers.PlatformHelper;
import duell.objects.DuellProcess.ProcessOptions;
import haxe.io.Path;

/**   
    @author jxav
 */
class PythonProcess extends DuellProcess
{
    public function new(path: String, args: Array<String>, options: ProcessOptions = null)
    {
        var pythonCommand: String = retrievePythonBinary();

        super(path, pythonCommand, args, options);
    }

    private static function retrievePythonBinary(): String
    {
        var duellLibPath: String = DuellLib.getDuellLib("duell").getPath();

        return switch (PlatformHelper.hostPlatform)
        {
            case Platform.MAC: Path.join([duellLibPath, "bin", "mac", "python2.7.9", "bin", "python"]);
            case _: "python";
        };
    }
}
