# castnow_control
Some scripts to integrate and control castnow via openHAB.

# Requirements
Install `screen` via your pakage manager. (e.g. `sudo apt-get install screen`)
Get `castnow` from GitHub: https://github.com/xat/castnow

# Install
Clone this repository or copy the files to your system (e.g. `/opt/castnow_control`)
Copy or rename the default configuration from `castnow_scripts.cfg.default`to `castnow_scripts.cfg`and define your own values.
Chown the folder and files to the same user that will run the scripts. (e.g. `openhab`)
Create a cronjob for `castnow_watchdog.sh`or execute it via `watch`.
Let the watchdog run every few seconds (depending on the available performance of your system).

# Integrating in openHAB
comming soon ...

# What do the scripts do?
## `castnow_get_state.sh`
This script reads the output from castnow and returns the `Status` and/or the `Source` (e.g. title of video).

## `castnow_send_command.sh`
This script send commands (e.g. play/pause, mute, stop, Vol+, ...) to castnow.

## `castnow_watchdog.sh`
This script (re)starts castnow if it is not running or lost connection to your Chromecast device.

# How it works
Because castnow only runs in the foreground in the command line we need a way to put it back in the background and let it run as some kind of deamon.
That is way these scripts use `screen`.
To get the current state we take a `hardcopy`of the screen/castnow output, save it to a file and parse it.
We use the `-X stuff`function of `screen`to send keypresses to castnow.

# Limitations/to-do
- open/start streams via castnow
- support multiple Chromecast devices at the same time
