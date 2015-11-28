#!/bin/bash
################################################################################
#
# /opt/castnow_scripts/castnow_send_command.sh (openhab:openhab, 744)
#
# This script sends commands to the running castnow screen to control
# the connected Chromecast device.
# 
# Use: ./castnow_send_command.sh <command>
#
# by Christoph Wempe
# 2015-11-27
#
################################################################################


# define base directory for castnow_scripts
BASEDIR="$(dirname "$0")"

# Import configuration
#source $BASEDIR/castnow_scripts.cfg

# Import configuration
if [ -f "$BASEDIR/castnow_scripts.cfg" ]
then
    source $BASEDIR/castnow_scripts.cfg
else
    if [ -f "$BASEDIR/castnow_scripts.cfg.default" ]
    then
        source $BASEDIR/castnow_scripts.cfg.default
    else
        echo "Cannot find configuration file ($BASEDIR/castnow_scripts.cfg[.default])!"
        exit 1
    fi
fi




# command to send the defined input to the screen
SCREENCMD="$SUDOCMD screen -S $SCREENNAME -X stuff"

####echo "$SCREENCMD"

# print erro if the amount of passed parameters is not 1
if [ "$#" -ne "1" ]
then 
    echo "Specify one command!"
    echo "Supported: pause, play, stop, mute, unmute, up, down, right, left, quit"
    exit 1
else
    COMMAND="$1"
fi


case $COMMAND in

    # control playback
    pause|play)
        $SCREENCMD " "
        ;;
    stop)
        $SCREENCMD "s"
        ;;

    # Volume (un)mute
    mute|unmute)
        $SCREENCMD "m"
        ;;
    # Volume up/down
    up)
        $SCREENCMD "^[^[[A"
        ;;
    down)
        $SCREENCMD "^[^[[B"
        ;;

    # Seek forward
    right)
        $SCREENCMD "^[^[[C"
        ;;
    # Seek backward
    left)
        $SCREENCMD "^[^[[D"
        ;;

    # Next in playlist
    # does not work
    next)
         # $SCREENCMD "n"
        echo "'next' does not work!"
        ;;

    # Quit castnow
    quit)
        $SCREENCMD "quit"
        ;;
    *)
        echo "Unkwnown parameter: $1"
        ;;
esac

#EOF