#!/bin/bash

#######################################################################################################################
# For this script to work, the app com.tuk.unisport.gameoftuk.gameoftuk must be installed on the only connected android
# device which is available to the adb service.
# Other than that, only adb is needed.
#######################################################################################################################


#######################################################################################################################
# Config
#######################################################################################################################

SCREENWIDTH=1080
SCREENHEIGHT=1920
TESTRUN=false # with this on true, the script does not run any commands, only prints them out


#######################################################################################################################
# Methods. You don't need to change anything below for the script to work, but you might have a look at the id and nick
# name generation
#######################################################################################################################

# echos an id of 9 characters of length, starting with a 2
function mkId {
	printf "2%04d%04d" $((RANDOM%9999)) $((RANDOM%9999))
}

# echos a nickname of the scheme "gameoftukplayerX" where X is a 4 digit random number
function mkNick {
	printf "gameoftukplayer%04d" $((RANDOM%9999))
}

function adbCmd {
	if [ "$TESTRUN" == "true" ]; then
		echo "adb $@"
	else
		adb "$@"
		sleep 1
	fi
}


#######################################################################################################################
# The actual script
#######################################################################################################################

# go home
adbCmd shell input keyevent KEYCODE_HOME
# clear app data
adbCmd shell pm clear com.tuk.unisport.gameoftuk.gameoftuk
# start app
adbCmd shell monkey -p com.tuk.unisport.gameoftuk.gameoftuk -c android.intent.category.LAUNCHER 1
sleep 5
# allow camera access
adbCmd shell input tap 804 1104
# manually enter id
adbCmd shell input tap 538 1600
adbCmd shell input text $(mkId)
adbCmd shell input tap 873 1160
# select fb
adbCmd shell input tap 545 1205
adbCmd shell input tap 478 1370
adbCmd shell input tap 545 1486
# untick newsletter
adbCmd shell input tap 217 1106
# input nick name
adbCmd shell input tap 521 1126
adbCmd shell input text $(mkNick)
adbCmd shell input keyevent 111
adbCmd shell input tap 545 1577
# let the games begin
adbCmd shell input tap 545 1427


