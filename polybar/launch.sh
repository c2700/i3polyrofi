#!/bin/bash

echo "" > /tmp/polybar1.log

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

LaunchBar(){
	MONITOR=$m polybar topbar -c /home/blank/.config/polybar/config 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=$m polybar bottombar -c /home/blank/.config/polybar/config 2>&1 | tee -a /tmp/polybar1.log & disown
}

for m in $(xrandr --query | grep -i " connected" | cut -d" " -f1)
do
	LaunchBar
done

