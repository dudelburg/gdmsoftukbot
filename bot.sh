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


#######################################################################################################################
# The actual script
#######################################################################################################################

echo "Hallo, Welt."

