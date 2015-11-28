# castnow_control
Some scripts to integrate and control castnow via openHAB.

# Requirements
Install `screen` via your pakage manager. (e.g. `sudo apt-get install screen`)

Get `castnow` from GitHub: https://github.com/xat/castnow

Here is how it is done on Rasbian Jessie on RaspberryPi.

Add the repository for `nodejs`
```
curl -sL https://deb.nodesource.com/setup | sudo bash -
```
Install `nodejs` and `screen`.
```
sudo apt-get install nodejs screen
```
Install castnow
```
sudo npm install castnow -g
```


# Install
Clone this repository or copy the files to your system (e.g. `/opt/castnow_control`)

Copy or rename the default configuration from `castnow_scripts.cfg.default`to `castnow_scripts.cfg`and define your own values.

Chown the folder and files to the same user that will run the scripts. (e.g. `openhab`)
```
cd /opt
sudo git clone https://github.com/CWempe/castnow_control.git
cd castnow_control
cp castnow_scripts.cfg.default castnow_scripts.cfg
chown -R openhab:openhab /opt/castnow_control
```

Create a cronjob for `castnow_watchdog.sh`or execute it via `watch`.

Let the watchdog run every few seconds (depending on the available performance of your system).

# Integrating in openHAB
## chromecast.items
```
String  CastState       "Status [%s]"   { exec="<[/opt/castnow_control/castnow_get_state.sh state:1000:]" }
String  CastSource      "Title [%s]"    { exec="<[/opt/castnow_control/castnow_get_state.sh source:1000:]" }

String  CastDown        "Volume -"      {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh down]"     "autoupdate"="false"}
String  CastUp          "Volume +"      {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh up]"       "autoupdate"="false"}
String  CastMute        "Mute"          {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh mute]"     "autoupdate"="false"}

String  CastPause       "Pause"         {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh pause]"    "autoupdate"="false"}
String  CastStop        "Stop"  {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh stop]"     "autoupdate"="false"}
String  CastLeft        "Seek backwards"        {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh left]"     "autoupdate"="false"}
String  CastRight       "Seek forward"          {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh right]"    "autoupdate"="false"}

String  CastQuit        "Quit"  {exec=">[TOGGLE:/opt/castnow_control/castnow_send_command.sh quit]"     "autoupdate"="false"}
```

## chromecast.sitemap
```
sitemap chromecast label="Chromecast"
{
    Frame label="State" {
        Text    item=CastState
        Text    item=CastSource
    }
    Frame label="Control" {
        Switch  item=CastDown
        Switch  item=CastUp
        Switch  item=CastMute

        Switch  item=CastPause
        Switch  item=CastStop
        Switch  item=CastLeft
        Switch  item=CastRight

        Switch  item=CastQuit
    }
}
```

# What do the scripts do?
## castnow_get_state.sh
This script reads the output from castnow and returns the `Status` and/or the `Source` (e.g. title of video).

## castnow_send_command.sh
This script send commands (e.g. play/pause, mute, stop, Vol+, ...) to castnow.

## castnow_watchdog.sh
This script (re)starts castnow if it is not running or lost connection to your Chromecast device.

# How it works
Because castnow only runs in the foreground in the command line we need a way to put it back in the background and let it run as some kind of deamon.

That is way these scripts use `screen`.

To get the current state we take a `hardcopy`of the screen/castnow output, save it to a file and parse it.

We use the `-X stuff`function of `screen`to send keypresses to castnow.

# Limitations/to-do
- open/start streams via castnow
- support multiple Chromecast devices at the same time
