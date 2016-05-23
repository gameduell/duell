package python.urllib;

@:pythonImport("urllib.request", "HTTPPasswordMgrWithDefaultRealm")
extern class HTTPPasswordMgrWithDefaultRealm
{
	public function new();
	public function add_password(realm: Dynamic, topLevelURL: String, usernam: String, password: String): Void;
}
