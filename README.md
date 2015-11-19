## Description

[![Join the chat at https://gitter.im/gameduell/duell](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gameduell/duell?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The Duell Tool is a command line tool written in [haxe](http://haxe.org/) for setting up, building and running applications on any platform.
It can also be used for other general tasks within app development. It is made in a modular way via plugins,
and each plugin is separate from the tool itself. The tool merges the needed plugin on execution.


The execution of the tool is always "duell" followed by a command such as "build" or "setup" and
then a plugin name like "ios" or "emptyProject". For example, "duell build ios" will run the command
"build" with the "ios" plugin. You can also pass additional parameters to
execution by prefixing with "-", e.g. "duell build ios -verbose".


Getting Started
----------------------------------------------

### Requirements

#### haxe
To install the Duell Tool, make sure that you have the the current [haxe](http://haxe.org/) version installed (http://haxe.org/download/). It comes along with 'haxelib', a library manager which is needed to install the tool.

#### Python
From version 4 the duell tool requires Python 3 to be installed. If the tool can't find it, make sure you have defined DUELL_PYTHON to a python 3 executable.


### Install Duell

After your successful installation of haxe, type `$ haxelib install duell` in your command line. Haxelib will download the Duell Tool sources into the specified haxelib library folder.

### Setup Duell

To setup duell run this
`$ haxelib run duell self_setup`

You will be asked to add a certain library folder for the Duell Tool specific libraries. Accept the predefined path or enter a new one.
Furthermore the setup will ask you for the 'URL to repo list', just confirm the displayed one to get access to all predifined libraries and plugins the tool will come along with. 

Due to your network connection the installation of the duell tool could take a while. After hxccp is installed confirm the 'duell command line installation' question.

Done.

#### Known problems during the setup

* Make sure that the haxelib repository path is **NOT** the same like Duell Tools library path '~/.duell/lib' else the setup will fail.

* On both Linux and Mac systems, the installation of the actual duell executable can fail (because of missing administrator rights). If this happens, the installer will notify you about it. For Macs, the best workaround in that case is creating an alias in your .bash_profile or .profile (Mac) file in your home folder, i.e. alias duell='haxelib run duell_duell'. For Linux systems, the install script always creates a small duell script in /home/<USERNAME>/bin.

* You should avoid using paths with mutated vowels included. This could lead into corrupted config files.


### Testing

Go to your workspace and enter:

`$ duell create emptyProject`

If you are using this command for the first time, the plugin 'emptyProject' is probabyl not installed, so let the tool install it. 
After this plugin was successfully checked out, enter a certain project name for your test project or confirm the predefined name.

`$ cd 'PROJECT_NAME'`

`$ duell build html5`

After the tool updated the project and checked the dependencies the cretain 'duellbuildhtml5' library needs to be checked out from the repository. After the build process you will have an 'Export' folder where you can find the created html5 files '.../PROJECT_NAME/Export/html5/web'.

**Hint:** If you run `$ duell build html5 -browser` the application will run in your default browser. To be confirmed that your application is working, checkout your browser console.


### Commands

To get a list of possible commands run '$ duell' or '$ duell -help'. To get more information for a specific command use '-help' property, e.g. '$ duell create -help'.


### Additional informations

#### Folder structure of '.duell'

Files:
* config.json
Local configuration file which will store the basic configuration. If you open that file, you will see the configured repository paths, last project file, the Duell Tool path to the repository list etc. This file will be automatically kept up to date by using certain commands. 

* duell_user.xml
Automatically created to define user specific xsd and set the namespace.

* schema.xsd
Schema definition.

Folders:
* lib
Main folder to store libraries for the Duell Tool. If the tool needs to checkout a new library or plugin, this is the folder where you will find it.  

* lib_list
Regarding the order and number of your configured repositories, you will find a folder for each of them here. If you have configured the default repository you should see the default repository on position one: '1. git@github.com:gameduell/duell-repository-list.git' ('$ duell repo_list')

The checkout of the first added repository will be located in a folder '.duell/lib_list/1', a second one in '.duell/lib_list/2' etc. The structure of these repository lists needs to be JSON formatted, e.g.:
```javascript
{
	"duell":
	{
		"git_path":"git@github.com:gameduell/duell.git",
		"library_path": "duell",
		"destination_path": "duell"
	},
	"duellbuildhtml5":
	{
		"git_path":"git@github.com:gameduell/duellbuildhtml5.git",
		"library_path": "duellbuildhtml5",
		"destination_path": "duellbuildhtml5"
	},
	...
}
```

## Release Log
### 4.0.0
Now running on Python 3 instead of neko
### 3.0.2
Initial setup for github







