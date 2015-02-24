package duell.versioning;

import duell.helpers.GitHelper;
import duell.helpers.LogHelper;
import duell.objects.SemVer;

enum VersionType
{
	Branch;
	Override;
	Version;
	Unavailable;
}

class GitVers
{
	var dir: String = null;

	/// data that is important to cache
	var branchList: Array<String> = [];
	var tagList: Array<String> = [];

	public var currentVersion (default, null): String;

	public function new(dir: String)
	{
		this.dir = dir;

		/// intermediate data
		GitHelper.fetch(dir);
        branchList = GitHelper.listBranches(dir);
        tagList = GitHelper.listTags(dir);

        currentVersion = getCurrentVersionOfDirectory();
	}

	private function getCurrentVersionOfDirectory(): String
	{
        var currentBranch = GitHelper.getCurrentBranch(dir);
    	var commit = GitHelper.getCurrentCommit(dir);

    	for (tag in tagList)
    	{
    		if (SemVer.ofString(tag) != null)
    		{
    			if (GitHelper.getCommitForTag(dir, tag) == commit)
    				return tag;
    		}
    	}

    	return currentBranch;
	}

	/// override version is for basically checking first that version, and then everything else
	/// its useful for when you want to get all branches of a given name in multiple repos, for developing
	/// a feature that is done across multiple libraries
	public function resolveVersionConflict(requestedVersions: Array<String>, overrideVersion: String = null): String
	{
        /// check override
        if (overrideVersion != null)
        {
        	if (branchList.indexOf(overrideVersion) != -1)
        	{
        		return overrideVersion;
        	}
        }

        /// check for empty version request
		if (requestedVersions.length == 0)
		{
			throw "Cannot solve versioning with empty requested version list for path: " + dir;
		}

		/// filter repeats on requested versions
		requestedVersions = removeDuplicateVersions(requestedVersions);

        /// check branches
        var requestedBranches = determineRequestedBranches(requestedVersions);

        if (requestedBranches.length > 1)
        {
        	throw 'Cannot solve version conflict because more than one branch was requested for the library in path $dir - branches: $requestedVersions';
        }

        if (requestedBranches.length > 0)
        {
        	return requestedBranches[0];
        }

        /// check versions
        var requestedSemanticVersions = determineRequestedSemanticVersions(requestedVersions);

        if (requestedSemanticVersions.length == 0)
        {
        	throw ('Cannot solve version conflict because there are no valid versions or branches for library in path $dir - branches: $requestedVersions');
        }

        /// check compatibility
        var firstSemVer = requestedSemanticVersions[0];
        for (semVer in requestedSemanticVersions)
        {
        	if (!SemVer.areCompatible(firstSemVer, semVer))
        	{
        		throw 'Cannot solve version conflict because the major versions are different. Version ${semVer.toString()} and ${firstSemVer.toString()}. For path $dir';
        	}
        }

        /// get the most specific version, 
        requestedSemanticVersions.sort(SemVer.compare);

        var bestVersion = requestedSemanticVersions[0];
        for (version in requestedSemanticVersions)
        {
        	/// returns the first argument, if they are the same
        	bestVersion = SemVer.getMostSpecific(bestVersion, version);
        }

        return bestVersion.toString();
	}

	public function solveVersion(version:String): String
	{
    	if (branchList.indexOf(version) != -1)
    	{
    		return version;
    	}

    	var semVer = SemVer.ofString(version);

    	if (semVer == null)
    	{
    		throw "version is neither a branch or a semantic version";
    	}

        /// check existing versions
        var existingSemanticVersions = determineExistingSemanticVersions();
        
        existingSemanticVersions.sort(SemVer.compare);

        var usedVersion = null;
        for (existing in existingSemanticVersions)
        {
        	if (SemVer.areCompatible(existing, semVer))
        	{
        		usedVersion = existing;
        		break;
        	}
        }

        if (usedVersion == null)
        {
        	throw 'could not find any version that is compatible with ${semVer.toString()} in existing versions: ' + 
        		   existingSemanticVersions.map(function(s) return s.toString());
        }
        return usedVersion.toString();
	}


	public function needsToChangeVersion(version: String): Bool
	{
		/// BRANCH
		if (branchList.indexOf(version) != -1)
		{
			if (GitHelper.getCurrentBranch(dir) != version)
			{
				return true;
			}

			if (GitHelper.updateNeeded(dir))
			{
				return true;
			}

			return false;
		}

		/// VERSION
		if (tagList.indexOf(version) != -1)
		{
			var commit = GitHelper.getCommitForTag(dir, version);
			if (GitHelper.getCurrentCommit(dir) != commit)
			{
				return false;
			}

			return true;
		}

		throw "version requested for change '" + version + "' is neither a version nor an existing branch";

	}

	/// returns true if something changed, false if the current state is maintained
	public function changeToVersion(version: String): Bool
	{
		currentVersion = version;

		if (branchList.indexOf(version) != -1)
		{
			return handleChangeToBranch(version);
		}

		if (tagList.indexOf(version) != -1)
		{
			return handleChangeToTag(version);
		}

		throw "version requested for change '" + version + "' is neither a version nor an existing branch";
	}

	function handleChangeToBranch(branch: String): Bool
	{
		var changed = false;

		if (GitHelper.getCurrentBranch(dir) != branch)
		{
			if (!GitHelper.isRepoWithoutLocalChanges(dir))
			{
				throw "can't change branch of repo because it has local changes, path: " + dir;
			}

			GitHelper.checkoutBranch(dir, branch);

			changed = true;
		}

		if (GitHelper.updateNeeded(dir))
		{
			if (!GitHelper.isRepoWithoutLocalChanges(dir))
			{
				throw "can't change update repo because it has local changes, path: " + dir;
			}
			GitHelper.pull(dir);

			changed = true;
		}

		return changed;
	}

	function handleChangeToTag(version: String): Bool
	{
		var changed = false;

		var commit = GitHelper.getCommitForTag(dir, version);
		if (GitHelper.getCurrentCommit(dir) != commit)
		{
			if (!GitHelper.isRepoWithoutLocalChanges(dir))
			{
				throw "can't change to tagged commit of repo because it has local changes, path: " + dir;
			}

			GitHelper.checkoutCommit(dir, commit);

			changed = true;
		}

		return changed;
	}

	function determineRequestedSemanticVersions(requestedVersions: Array<String>): Array<SemVer>
	{
		var requestedSemanticVersions = [];
		for (version in requestedVersions)
		{
			var semVer = SemVer.ofString(version);
			if (semVer != null)
			{
				requestedSemanticVersions.push(semVer);
			}
		}
		return requestedSemanticVersions;
	}

	function determineExistingSemanticVersions(): Array<SemVer>
	{
		var existingSemanticVersions = [];
		for (version in tagList)
		{
			var semVer = SemVer.ofString(version);
			if (semVer != null)
			{
				existingSemanticVersions.push(semVer);
			}
		}
		return existingSemanticVersions;
	}

	function determineRequestedBranches(requestedVersions: Array<String>): Array<String>
	{
		var requestedBranches = [];
		for (version in requestedVersions)
		{
			if (branchList.indexOf(version) != -1)
			{
				requestedBranches.push(version);
			}
		}
		return requestedBranches;
	}

	static function removeDuplicateVersions(requestedVersions: Array<String>): Array<String>
	{
		var newList = [];
		for (version in requestedVersions)
		{
			if (newList.indexOf(version) == -1)
			{
				newList.push(version);
			}
		}
		return newList;
	}
}