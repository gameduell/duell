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

import duell.objects.SourceLib;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import duell.helpers.PlatformHelper;
import duell.helpers.LogHelper;

class SchemaHelper
{
    private static inline var DUELL_NS = "duell";

    private static inline var SCHEMA_FILE = "schema.xsd";

    private static inline var SCHEMA_FOLDER = "schema";
    private static inline var TEMPLATED_SCHEMA_FILE = "duell_schema.xsd";
    private static inline var COMMON_SCHEMA_FILE = "https://raw.githubusercontent.com/gameduell/duell/master/schema/common_schema.xsd";

    public static function hasDuellNamespace(pathXml: String): Bool
    {
        var data: String = File.getContent(pathXml);
        return data.indexOf('xmlns="$DUELL_NS"') != -1;
    }

    public static function validate(pathXml: String): Void
    {
        if (PlatformHelper.hostPlatform == Platform.WINDOWS)
        {
            LogHelper.info("Currently XML Validation is disabled on Windows pending a bug fix.");
            return;
        }

        var duellPath: String = DuellLibHelper.getPath("duell");
        var toolPath: String = Path.join([duellPath, "bin"]);
        var schemaPath: String = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), SCHEMA_FILE]);

        CommandHelper.runJava(toolPath, ["-jar", "schema_validator.jar", schemaPath, pathXml],
        {
            errorMessage: 'Failed to validate schema for file: $pathXml'
        });
    }

    public static function createSchemaXml(duelllibs: Array<String>, plugins: Array<String>, ?sourcelibs: Array<SourceLib> = null): Void
    {
        var duellPath: String = DuellLibHelper.getPath("duell");
        var schemaPath: String = Path.join([duellPath, SCHEMA_FOLDER, TEMPLATED_SCHEMA_FILE]);

        var librariesWithSchema: Array<{name : String, path : String}> = [];
        var pluginsWithSchema: Array<{name : String, path : String}> = [];

        var librariesWithoutSchema: Array<String> = [];
        var pluginsWithoutSchema: Array<String> = [];

        for (duelllib in duelllibs)
        {
            var duellLibPath: String = DuellLibHelper.getPath(duelllib);
            var duellLibSchemaPath: String = Path.join([duellLibPath, SCHEMA_FILE]);

            if (FileSystem.exists(duellLibSchemaPath))
            {
                librariesWithSchema.push({name: duelllib, path: duellLibSchemaPath});
            }
            else
            {
                librariesWithoutSchema.push(duelllib);
            }
        }

        if (sourcelibs != null)
        {
            for (sourcelib in sourcelibs)
            {
                var sourceLibSchemaPath: String = Path.join([sourcelib.getPath(), SCHEMA_FILE]);

                if (FileSystem.exists(sourceLibSchemaPath))
                {
                    librariesWithSchema.push({name: sourcelib.name, path: sourceLibSchemaPath});
                }
                else
                {
                    librariesWithoutSchema.push(sourcelib.name);
                }
            }
        }

        for (plugin in plugins)
        {
            var duellLibPath: String = DuellLibHelper.getPath(plugin);
            var duellLibSchemaPath: String = Path.join([duellLibPath, SCHEMA_FILE]);

            // exclude duellbuild from the plugin name
            var rawPluginName: String = plugin.substr(10);

            if (FileSystem.exists(duellLibSchemaPath))
            {
                pluginsWithSchema.push({name: rawPluginName, path: duellLibSchemaPath});
            }
            else
            {
                pluginsWithoutSchema.push(rawPluginName);
            }
        }

        var outPath: String = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), SCHEMA_FILE]);

        var template =
        {
            NS: DUELL_NS,
            COMMON_FILE: COMMON_SCHEMA_FILE,
            LIBRARIES_WITH_SCHEMA: librariesWithSchema,
            PLUGINS_WITH_SCHEMA: pluginsWithSchema,
            LIBRARIES_WITHOUT_SCHEMA: librariesWithoutSchema,
            PLUGINS_WITHOUT_SCHEMA: pluginsWithoutSchema
        }

        TemplateHelper.copyTemplateFile(schemaPath, outPath, template, null);
    }
}
