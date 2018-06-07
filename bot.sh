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
function mkNickname {
	printf "gameoftukplayer%04d" $((RANDOM%9999))
}

function adbCmd {
	command=""
	case $1 in
	tap)
		# do some magic math
		command="shell input tap $(($2*SCREENWIDTH/1000)) $(($3*SCREENHEIGHT/1000))"
		;;
	text|keyevent)
		command="shell input $@"
		;;
	sleep)
		if [ "$TESTRUN" != "true" ]; then
			sleep $2
		fi
		;;
	backup)
		command="$@"
		;;
	**)
		command="shell $@"
		;;
	esac

	if [ -n "$command" ]; then
		if [ "$TESTRUN" == "true" ]; then
			echo "adb $command"
		else
			adb $command
			sleep 1
		fi
	fi
}

function createAccount {
	if [ "$TESTRUN" != "true" ]; then
		echo -n "Achtung! Dieses Script löscht jetzt die App-Daten des Game of TUK. Mit [Strg + C] abbrechen, mit "
		read -p "[Enter] fortfahren"
	fi

	ID="$(mkId)"
	NICKNAME="$(mkNickname)"

	# go home
	adbCmd keyevent KEYCODE_HOME
	# clear app data
	adbCmd pm clear com.tuk.unisport.gameoftuk.gameoftuk
	# start app
	adbCmd monkey -p com.tuk.unisport.gameoftuk.gameoftuk -c android.intent.category.LAUNCHER 1
	adbCmd sleep 5
	# allow camera access
	adbCmd tap 750 575
	# manually enter id
	adbCmd tap 500 833
	adbCmd text $ID
	adbCmd tap 800 600
	# select fb
	adbCmd tap 500 628
	adbCmd tap 440 714
	adbCmd tap 500 774
	# untick newsletter
	adbCmd tap 200 576
	# input nick name
	#adbCmd tap 500 586
	adbCmd text $NICKNAME
	#adbCmd keyevent 111
	adbCmd tap 500 821
	# let the games begin
	adbCmd tap 500 743
	adbCmd backup -f data/gdmsoftuk_${ID}_${NICKNAME}.ab -apk com.tuk.unisport.gameoftuk.gameoftuk
}

function donkeyRace {
	# go home
	adbCmd keyevent KEYCODE_HOME
	# start app
	adbCmd monkey -p com.tuk.unisport.gameoftuk.gameoftuk -c android.intent.category.LAUNCHER 1
	adbCmd sleep 5
	# init race screen
	adbCmd tap 273 879
	adbCmd tap 410 787 # only the first time...
	# donkey race against computer
	adbCmd tap 722 469
	adbCmd tap 306 521
	adbCmd tap 410 787 # only the first time...
	
	# race 30 times by calling monkeyrunner because `input` is too slow
	java -Xmx512m "-Djava.ext.dirs=lib" -jar lib/monkeyrunner-25.3.1.jar run.py $SCREENWIDTH $SCREENHEIGHT
}

#######################################################################################################################
# The actual script
#######################################################################################################################

case $1 in
createAccount|donkeyRace)
	$1
	;;
**)
	echo "Bitte Aktion als ersten Parameter angeben: createAccount oder donkeyRace."
	;;
esac
