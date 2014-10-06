#!/bin/bash

rm -rf ~/.duell

haxelib setup ~/.duell/haxelib

expect -c "
spawn neko run.n -verbose  
set timeout -1

expect \"You are missing the initial setup.\"
send \"y\r\"

expect \"Path to store repos from libraries?\"
send \"\r\"


expect \"URL to repo list?\"
send \"\r\"

expect \"Do you want to install the \\\"duell\\\" command?\"
send \"n\r\"

expect eof
"

expect -c "
spawn haxelib run duell setup mac -verbose
set timeout -1

expect \"A library for setup of mac environment is not currently installed.\"
send \"y\r\"

expect eof
"
expect -c "
spawn haxelib run duell setup flash -verbose
set timeout -1

expect \"A library for setup of flash environment is not currently installed.\"
send \"y\r\"

expect \"Download and install the Adobe AIR SDK\"
send \"y\r\"
expect \"Air SDK Location\"
send \"\r\"

expect {
	\"File found\" {

		send \"n\r\"

		exp_continue
	}

	\"Go to the flash website\" {

		send \"n\r\"

		exp_continue
	}

	\"Download and install the Flash Debugger\" {

		send \"n\r\"

		exp_continue
	}
}
"



expect -c "
spawn haxelib run duell setup android -verbose

set timeout -1

expect \"A library for setup of android environment is not currently installed.\"
send \"y\r\"

expect \"Download the android SDK\"
send \"y\r\"
expect \"Android SDK Location\"
send \"\r\"

expect {
	\"File found\" {

		send \"n\r\"

		exp_continue
	}
	\"necessary Android packages\" {

		send \"y\r\"
	}
}

expect {
	\"accept the license\" {

		send \"y\r\"

		exp_continue
	}

	\"Download the android NDK\" {

		send \"y\r\"
	}
}

expect \"Android NDK Location\"
send \"\r\"

expect {
	\"File found\" {

		send \"n\r\"

		exp_continue
	}

	\"Download Apache Ant\" {

		send \"y\r\"
	}
}

expect \"Apache Ant Location\"
send \"\r\"

expect {
	\"File found\" {

		send \"n\r\"

		exp_continue
	}

}
"

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
}
"

