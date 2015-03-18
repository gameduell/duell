#!/bin/bash
set -e

rm -rf test
mkdir test

cd test

haxelib run duell create unitTestProject -verbose -yestoall

sed -i '' 's/supported-duell-tool version=".*"/supported-duell-tool version="master"/g' duell_project.xml

haxelib run duell update -verbose -yestoall

haxelib run duell build android -test -verbose -D jenkins -yestoall

haxelib run duell build html5 -test -verbose -D jenkins -yestoall

haxelib run duell build flash -test -verbose -D jenkins -yestoall

haxelib run duell build ios -test -verbose -D jenkins -yestoall