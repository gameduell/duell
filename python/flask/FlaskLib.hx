package python.flask;
@:pythonImport("flask")
extern class FlaskLib {
    static function send_from_directory(directory: String, file: String): Dynamic;
}
