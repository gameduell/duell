/**
 * @autor rcam
 * @date 15.07.2014.
 * @company Gameduell GmbH
 */
package duell.objects;

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.helpers.DuellLibListHelper;
import duell.helpers.GitHelper;
import duell.objects.SemVer;

import duell.objects.Arguments;

import sys.FileSystem;

using StringTools;

enum VersionType
{
	Branch;
	Override;
	Version;
	Unavailable;
}

class DuellLib 
{
	public var name(default, null) : String;
	public var version(default, null) : String;
	public var actualVersion(get, never) : String; //version after checking git
	public var semVer(default, null) : SemVer;
	private var pathCache : String = null; ///use getters
	private var existsCache : Null<Bool> = null; ///use getters

	private var branchForVersionCache : String = null;
	private var commitForVersionCache : String = null;
	private var branchesInRepoCache : Array<String> = null;
	private var compatibleTagCache : String = null;
	private var haxelibPathOutputCache : String = null;

	private var versionType : VersionType = null;

	private static var overrideBranch : String = null; /// "" means no override

	private function new(name : String, version : String = "master")
	{
		this.name = name;

		resetToVersion(version);
	}

	private function getVersionType() : VersionType
	{
		if (versionType != null)
			return versionType;

		if (overrideBranch == null)
		{
			if (Arguments.isSet("-overridebranch"))
			{
				overrideBranch = Arguments.get("-overridebranch");

			}
			else
			{
				overrideBranch = "";
			}
		}

		if (overrideBranch != null && overrideBranch != "")
		{
			if (getBranchList().indexOf(overrideBranch) != -1)
			{
				versionType = Override;

				return versionType;
			}
		}

		if (getBranchList().indexOf(version) != -1)
		{
			versionType = Branch;
			return versionType;
		}

		if (semVer != null)
		{
			versionType = Version;
			return versionType;
		}

		versionType = Unavailable;
		return versionType;
	}

	private function resetToVersion(version : String)
	{
		this.version = version;
		branchForVersionCache = null;
		commitForVersionCache = null;
		branchesInRepoCache = null;
		compatibleTagCache = null;
		versionType = null;

		semVer = SemVer.ofString(version);
	}

	public static var duellLibCache : Map<String, Map<String, DuellLib> > = new Map<String, Map<String, DuellLib> >();
	public static function getDuellLib(name : String, version : String = "master") : DuellLib
	{
		if (version == null || version == "")
			throw 'Empty version is not allowed for $name library!';
		///add to the cache if it is not there
		if (duellLibCache.exists(name))
		{
			var versionMap = duellLibCache.get(name);
			if (!versionMap.exists(version))
			{
				versionMap.set(version, new DuellLib(name, version));
			}
		}
		else
		{
			var versionMap = new Map<String, DuellLib>();
			versionMap.set(version, new DuellLib(name, version));
			duellLibCache.set(name, versionMap);
		}

		///retrieve from the cache
		return duellLibCache.get(name).get(version);
	}

	public function isInstalled() : Bool
	{
		if (existsCache != null && existsCache) /// if it didn't exist before, we always try again.
			return existsCache;

		if (haxelibPathOutputCache == null)
		{
			haxelibPathOutputCache = getHaxelibPathOutput();
		}

		if (haxelibPathOutputCache.indexOf('is not installed') != -1)
			existsCache = false;
 		else 
 			existsCache = true;

 		return existsCache;
	}

	private function getHaxelibPathOutput(): String
	{
    	var haxePath = Sys.getEnv("HAXEPATH");
    	var systemCommand = haxePath != null && haxePath != "" ? false : true;
		var proc = new DuellProcess(haxePath, "haxelib", ["path", name], {block: true, systemCommand: systemCommand, errorMessage: "getting path of library"});
		var output = proc.getCompleteStdout();

		return output.toString();
	}

	public function isPathValid() : Bool
	{
		return FileSystem.exists(getPath());
	}

	public function getPath() : String
	{
		if(pathCache != null)
			return pathCache;

		if (!isInstalled())
		{
			LogHelper.error ('Could not find duellLib \'' + name + '\'.');
		}

		return _getPath();
			
	}

	public function _getPath() : String
	{
		if(pathCache != null)
			return pathCache;

		if (haxelibPathOutputCache == null)
		{
			haxelibPathOutputCache = getHaxelibPathOutput();
		}

		var lines = haxelibPathOutputCache.split ('\n');
			
		for (i in 1...lines.length) {
			
			if (lines[i].trim().startsWith('-D')) 
			{
				pathCache = lines[i - 1].trim();
			}
			
		}

		if (pathCache == '') 
		{
			try {
				for (line in lines) 
				{
					if (line != '' && line.substr(0, 1) != '-') 
					{
						if (FileSystem.exists(line)) 
						{
							pathCache = line;
							break;
						}
					}
				}
			} catch (e:Dynamic) {}
			
		}
		
		return pathCache;
	}

	public function isRepoWithoutLocalChanges() : Bool
	{
		/// check status for local changes
		return GitHelper.isRepoWithoutLocalChanges(getPath());
	}

	private function getCommitForVersion() : Null<String>
	{
		if (commitForVersionCache != null)
			return commitForVersionCache;

		var compatibleTag = getCompatibleTag();

		if (compatibleTag == null)
			return null;

		commitForVersionCache = GitHelper.getCommitForTag(getPath(), compatibleTag);

		return commitForVersionCache;
	}

	public function getCompatibleTag() : String
	{
		if (compatibleTagCache != null)
			return compatibleTagCache;

		if (GitHelper.getCurrentBranch(getPath()) != "master")
			throw "Wrong branch to check version tags";

		/// get all tags
		var tagList : Array<String> = GitHelper.listTags(getPath());
		/// turn them to semantic versions
		var semanticVersionList : Array<SemVer> = tagList.map(function(tag) return SemVer.ofString(tag));
		/// filter invalid versions
		semanticVersionList = semanticVersionList.filter(function(semVer) return semVer != null);
		/// sort
		semanticVersionList.sort(SemVer.compare);

		var compatibleVersion = null;

		for (ver in semanticVersionList)
		{
			if (SemVer.areCompatible(ver, semVer))
			{
				compatibleVersion = ver;
				break;
			}
		}

		if (compatibleVersion == null)
		{
			return null;
		}

		compatibleTagCache = compatibleVersion.toString();

		return compatibleTagCache;
	}

	public function isRepoOnCorrectBranch() : Bool
	{	
		switch (getVersionType())
		{
			case (Version):
				return GitHelper.getCurrentBranch(getPath()) == "master";
			case (Branch):
				return GitHelper.getCurrentBranch(getPath()) == version;
			case (Override):
				return GitHelper.getCurrentBranch(getPath()) == overrideBranch;
			case (Unavailable):
				return false;
		}
	}

	public function isRepoOnCorrectCommit() : Bool
	{	
		switch (getVersionType())
		{
			case (Version):
				return getCommitForVersion() == GitHelper.getCurrentCommit(getPath());
			case (Branch):
				return true;
			case (Override):
				return true;
			case (Unavailable):
				return true;
		}
	}

	public function isPossibleToShiftToTheCorrectBranch() : Bool
	{
		switch (getVersionType())
		{
			case (Version):
				return getBranchList().indexOf("master") != -1;
			case (Branch):
				return getBranchList().indexOf(version) != -1;
			case (Override):
				return getBranchList().indexOf(overrideBranch) != -1;
			case (Unavailable):
				return false;
		}
	}

	private function getBranchList() : Array<String>
	{
		if (branchesInRepoCache == null)
		{
			GitHelper.fetch(getPath());
			branchesInRepoCache = GitHelper.listBranches(getPath());
		}

		return branchesInRepoCache;
	}

	public function isPossibleToShiftToTheCorrectCommit() : Bool
	{
		switch (getVersionType())
		{
			case (Version):
				return getCommitForVersion() != null;
			case (Branch):
				return true;
			case (Override):
				return true;
			case (Unavailable):
				return false;
		}
	}

	public function shiftRepoToCorrectCommit()
	{
		switch (getVersionType())
		{
			case (Version):
				GitHelper.checkoutCommit(getPath(), getCommitForVersion());
			default:
		}
	}

	public function shiftRepoToCorrectBranch()
	{
		switch (getVersionType())
		{
			case (Version):
				GitHelper.checkoutBranch(getPath(), "master");
			case (Branch):
				GitHelper.checkoutBranch(getPath(), version);
			case (Override):
				GitHelper.checkoutBranch(getPath(), overrideBranch);
			case (Unavailable):
		}
	}

	public function get_actualVersion() : String
	{
		if (Arguments.isSet("-ignoreversioning"))
			return "local";

		switch (getVersionType())
		{
			case (Version):
				/// actual version might be called without having checked the compatible tag
				/// this is a problem because we might have not shifted to the master branch yet
				if (compatibleTagCache == null)
					return version;
				else
					return getCompatibleTag();
			case (Branch):
				return version;
			case (Override):
				return overrideBranch;
			case (Unavailable):
				return "<UNAVAILABLE>";
		}

	}

    public function updateNeeded() : Bool
    {
    	if (!isRepoOnCorrectCommit())
    	{
    		throw "updateNeeded called on a bad state. This should never happen, contact the developers.";
    	}

    	if (getVersionType() == Version)
    		return false;

        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        var path = getPath();

        return GitHelper.updateNeeded(getPath());
    }

    public function update()
    {
        var duellConfigJSON = DuellConfigJSON.getConfig(DuellConfigHelper.getDuellConfigFileLocation());

        GitHelper.pull(getPath());
    }

    public function install()
    {
    	haxelibPathOutputCache = null;

        var duellLibList = DuellLibListHelper.getDuellLibReferenceList();

        if (duellLibList.exists(name))
        {
            duellLibList.get(name).install();
        }
        else
        {
            LogHelper.error('Couldn\'t find the Duell Library reference in the repo list for $name. Can\'t install it.');
        }
    }

	public function resolveConflict(duellLib : DuellLib) : Bool
	{

		var currentVersionType = getVersionType();

		/// check if current DuellLib is a override, if it is, keep it
		/// if one is override the other is aswell.
		if (currentVersionType == Override) 
			return true;

		var newVersionType = duellLib.getVersionType();

		/// check if current DuellLib is a Branch, if it is, keep it
		if (currentVersionType == Branch && newVersionType != Branch)
			return true;

		/// if the current duelllib is a semantic version, change to the other. 
		if (currentVersionType == Version && newVersionType == Branch)
		{
			resetToVersion(duellLib.version);
			return true;
		}

		/// both are branches
		if (currentVersionType == Branch && newVersionType == Branch)
		{
			var currentBranch = version;
			var newBranch = duellLib.version;
			return currentBranch != newBranch;
		}

		/// should always yield true
		if (currentVersionType == Version && newVersionType == Version) 
		{
			/// check version compatibility and keep the most specific
			if (SemVer.areCompatible(semVer, duellLib.semVer))
			{
				var mostSpecific = SemVer.getMostSpecific(semVer, duellLib.semVer);

				if (mostSpecific == duellLib.semVer)
					resetToVersion(duellLib.version);

				return true;
			}
		}

		return false;
	}
}