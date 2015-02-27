#!/bin/bash
set -e

rm -rf ~/.duell

mkdir ~/.duell
mkdir ~/.duell/haxelib
haxelib setup ~/.duell/haxelib

neko run.n self_setup -verbose -yestoall

haxelib run duell setup mac -v 1.0.0 -verbose -yestoall

haxelib run duell setup flash -v 1.0.0 -verbose -yestoall

haxelib run duell setup android -v 1.0.0 -verbose -yestoall