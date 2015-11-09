## Description

[![Join the chat at https://gitter.im/gameduell/duell](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gameduell/duell?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The Duell Tool is a command line tool written in [haxe](http://haxe.org/) for setting up, building and running applications on any platform.
It can also be used for other general tasks within app development. It is made in a modular way via plugins,
and each plugin is separate from the tool itself. The tool merges the needed plugin on execution.


The execution of the tool is always "duell" followed by a command such as "build" or "setup" and
then a plugin name like "ios" or "emptyProject". For example, "duell build ios" will run the command
"build" with the "ios" plugin. You can also pass additional parameters to
execution by prefixing with "-", e.g. "duell build ios -verbose".


## Release Log
4.0.0
----------------------------------------------
* Now running on Python 3 instead of neko
----------------------------------------------
3.2.0
----------------------------------------------
* Initial setup for github


Getting Started
----------------------------------------------

### Requirements

#### haxe
To install the Duell Tool, make sure that you have the the current [haxe](http://haxe.org/) version installed. [http://haxe.org/download/](http://haxe.org/download/) It comes along with 'haxelib', a library manager which is needed to install the tool.

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

* If you're installing on a Linux system, one extra step is required: Google Protobuf is included in our Haxe setup but the setup somehow fails to make protoc executable. Do this with chmod +x  /home/<USERNAME>/.duell/lib/serialization/protobuffers/tools/protoc/linux/protoc

* You should avoid using paths with mutated vowels included. This could lead into corrupted config files.


### Testing

Go to your workspace and enter:

`$ duell create emptyProject`

If you are using this command for the first time, the plugin 'emptyProject' is probabyl not installed, so let the tool install it. 
After this plugin was successfully checked out, enter a certain project name for your test project or confirm the predefined name.

Switch to that folder afterwards.
`$ cd 'PROJECT_NAME'`

`$ duell build html5`

After the tool updated the project and checked the dependencies the cretain 'duellbuildhtml5' library needs to be checked out from the repository. After the build process you will have an 'Export' folder in your project '.../PROJECT_NAME/Export'. You will find the html5 files in '.../PROJECT_NAME/Export/html5/web'.

**Hint:** If you run `$ duell build html5 -browser` the application will run in your default browser. You should be able to checkout a dummy trace inside your browser console.

