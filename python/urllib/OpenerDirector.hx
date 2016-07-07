package python.urllib;

@:pythonImport("urllib.request", "OpenerDirector")
extern class OpenerDirector
{
	public function open(url: String): Void;
}
