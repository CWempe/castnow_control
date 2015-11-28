#!/bin/bash
################################################################################
#
# /opt/castnow_scripts/castnow_watchdog.sh (openhab:openhab, 744)
#
# This script checks the connection of a running castnow screen
# and restarts or starts the program if necessary.
#
# To periodically running this script, define it in cron or execute it via watch
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




# check if castnow is still running
# ps all | grep -v "grep" | grep -q "node $CASTNOW"
$SUDOCMD screen -ls | grep -q "$SCREENNAME"

if [ "`echo $?`" -ne "0" ]
then
  echo "castnow is not running anymore!"
  echo ""
  echo "Restarting castnow..."
  $SUDOCMD screen -d -m -S $SCREENNAME $CASTNOW $CASTNOWPARAM
else
  echo "castnow is still running"

  # check current state
  $BASEDIR/castnow_get_state.sh | grep -q "Closed"

  # if state is closed, quit screen
  # screen will be started next run automatically
  if [ "`echo $?`" -eq "0" ]
  then
    echo "State is closed. Quit screen..."
    $SUDOCMD screen -X -S $SCREENNAME quit
    echo "$SUDOCMD screen -X -S $SCREENNAME quit"
  fi

fi

#EOF