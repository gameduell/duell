## Description

[![Join the chat at https://gitter.im/gameduell/duell](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gameduell/duell?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The Duell Tool is a command line tool for setting up, building and running applications on any platform.
It can also be used for other general tasks within app development. It is made in a modular way via plugins,
and each plugin is separate from the tool itself. The tool merges the needed plugin on execution.


The execution of the tool is always "duell" followed by a command such as "build" or "setup" and
then a plugin name like "ios" or "emptyProject". For example, "duell build ios" will run the command
"build" with the "ios" plugin. You can also pass additional parameters to
execution by prefixing with "-", e.g. "duell build ios -verbose".


## Release Log
0.0.1
----------------------------------------------
* Initial setup for github

## Getting Started
----------------------------------------------

### Install Duell
In your command line run
`$ haxelib install duell`
### Setup Duell
to setup duell run this
`$ haxelib run duell self_setup`
### Testing
`$ mkdir emptyProject`

`$ cd emptyProject`

`$ duell create emptyProject`

`$ duell build html5`
