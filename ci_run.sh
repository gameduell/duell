#!/bin/bash
set -e

trap onexit 1 2 3 15 ERR

function onexit() {
    echo "Problem occured, exit code: $?"
    exit $exit_status
}

while getopts :i:a:h: option; do
    case "${option}" in
        i) IOSPATH=${OPTARG};;
        a) ANDPATH=${OPTARG};;
        h) HTML5PATH=${OPTARG};;
        \?) echo "Invalid option: -$OPTARG" >&2
    esac
done

cd test
cd unitTestProject

if [ "${IOSPATH}" != "" ]
then
    printf '\n'
    printf ' ---------- run IOS unittests ----------'
    printf '\n'
    haxelib run duell_duell run unittest -ios -verbose -simulator -path $IOSPATH
fi

if [ "${ANDPATH}" != "" ]
then
    printf '\n'
    printf ' ---------- run ANDROID unittests ----------'
    printf '\n'
    haxelib run duell_duell run unittest -android -x86 -verbose -wipeemulator -path $ANDPATH
fi

if [ "${HTML5PATH}" != "" ]
then
    printf '\n'
    printf ' ---------- run HTML unittests ----------'
    printf '\n'
    haxelib run duell_duell run unittest -html5 -verbose -path $HTML5PATH
fi