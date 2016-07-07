package python.urllib;

@:pythonImport("urllib.request", "HTTPBasicAuthHandler")
extern class HTTPBasicAuthHandler
{
	public function new(manager: HTTPPasswordMgrWithDefaultRealm);
}
