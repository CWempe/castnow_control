#!/bin/bash
################################################################################
#
# /opt/castnow_scripts/castnow_get_state.sh (openhab:openhab, 744)
#
# This script gets the state of the chromecast and the source that is playing.
# In this case "source" means title.
# (e.g. title of a YouTube video, or "Artist - Title" of a song)
#
# by Christoph Wempe
# 2015-11-27
#
################################################################################


# define base directory for castnow_scripts
BASEDIR="$(dirname "$0")"

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


# write the current screen output to file
$SUDOCMD screen -d -R -S $SCREENNAME -p0 -X hardcopy $HARDCOPYFILE

# Read screen output from file with 'cat'
# Use 'echo' to get rid of blank spaces at the beginning and end of each line
# 'cut' to remove "State:" and "Source:"
# Remove dots with 'tr'

CASTSTATE="`echo \`cat $HARDCOPYFILE | grep State  | cut -d : -f 2-\` | tr -d '.'`"
CASTSOURCE="`echo \`cat $HARDCOPYFILE | grep Source | cut -d : -f 2-\``"


# check how many parameter are set
if [ "$#" -gt "0" ]
then 
    # check if the first parameter is "state"
    if [ "$1" == "state" ]
    then 
        echo -E "$CASTSTATE"
    else
        # check if the first parameter is "source"
        if [ "$1" == "source" ]
        then 
            echo -E "$CASTSOURCE"
        else
            echo "Unkwnown parameter: $1"
            exit 1
        fi
    fi
else
    # Print both values if there are more or less than one parameter passed to this script
    echo "State:  $CASTSTATE"
    echo "Source: $CASTSOURCE"
fi


#EOF