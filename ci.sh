#!/bin/bash
set -e

rm -rf test
mkdir test

cd test

haxelib run duell_duell create unitTestProject -verbose -yestoall

#because the unitTestProject sample has a specified duell tool version
sed -i '' 's/supported-duell-tool version=".*"/supported-duell-tool version="master"/g' duell_project.xml

haxelib run duell_duell update -verbose -yestoall

haxelib run duell_duell build html5 -test -verbose -D jenkins -yestoall

haxelib run duell_duell build ios -simulator -test -verbose -D jenkins -yestoall

haxelib run duell_duell build android -emulator -x86 -test -verbose -D jenkins -yestoall
