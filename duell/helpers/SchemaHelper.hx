/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
package duell.helpers;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

/**   
    @author jxav
 */
class SchemaHelper
{
    private static inline var DUELL_NS = "duell";

    private static inline var SCHEMA_FILE = "schema.xsd";
    private static inline var TEMPLATED_SCHEMA_FILE = "duell_schema.xsd";

    public static function hasDuellNamespace(pathXml: String): Bool
    {
        var data: String = File.getContent(pathXml);
        return data.indexOf('xmlns="$DUELL_NS"') != -1;
    }

    public static function validate(pathXml: String): Void
    {
        var duellPath: String = DuellLibHelper.getPath("duell");
        var toolPath: String = Path.join([duellPath, "bin"]);
        var schemaPath: String = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), SCHEMA_FILE]);

        CommandHelper.runJava(toolPath, ["-jar", "schema_validator.jar", schemaPath, pathXml],
        {
            errorMessage: 'Failed to validate schema for file: $pathXml'
        });
    }

    public static function createSchemaXml(duelllibs: Array<String>, plugins: Array<String>): Void
    {
        var duellPath: String = DuellLibHelper.getPath("duell");
        var schemaPath: String = Path.join([duellPath, "schema", TEMPLATED_SCHEMA_FILE]);

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
            LIBRARIES_WITH_SCHEMA: librariesWithSchema,
            PLUGINS_WITH_SCHEMA: pluginsWithSchema,
            LIBRARIES_WITHOUT_SCHEMA: librariesWithoutSchema,
            PLUGINS_WITHOUT_SCHEMA: pluginsWithoutSchema
        }

        TemplateHelper.copyTemplateFile(schemaPath, outPath, template, null);
    }
}
