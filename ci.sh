#!/bin/bash
set -e

haxelib dev duell .

rm -rf test
mkdir test

cd test

expect -c "
spawn haxelib run duell create unitTestProject -verbose

set timeout -1

expect \"is not currently installed.\"
send \"y\r\"

expect eof
"

expect -c "
spawn haxelib run duell build android -test -verbose

set timeout -1

expect {
	\"is not currently installed.\" {

		send \"y\r\"

		exp_continue
	}
	\"is missing,\" {

		send \"y\r\"

		exp_continue
	}
	\"not up to date\" {

		send \"y\r\"

		exp_continue
	}
}
"



expect -c "
spawn haxelib run duell build html5 -test -verbose

set timeout -1

expect {
	\"is not currently installed.\" {

		send \"y\r\"

		exp_continue
	}
	\"is missing,\" {

		send \"y\r\"

		exp_continue
	}
	\"not up to date\" {

		send \"y\r\"

		exp_continue
	}
}
"


expect -c "
spawn haxelib run duell build flash -test -verbose

set timeout -1

expect {
	\"is not currently installed.\" {

		send \"y\r\"

		exp_continue
	}
	\"is missing,\" {

		send \"y\r\"

		exp_continue
	}
	\"not up to date\" {

		send \"y\r\"

		exp_continue
	}
}
"

expect -c "
spawn haxelib run duell build ios -test -verbose

set timeout -1

expect {
	\"is not currently installed.\" {

		send \"y\r\"

		exp_continue
	}
	\"is missing,\" {

		send \"y\r\"

		exp_continue
	}
	\"not up to date\" {

		send \"y\r\"

		exp_continue
	}
}
"



