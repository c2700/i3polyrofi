#!/bin/bash

echo "" > /tmp/polybar1.log

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default main_configlocation ~/.config/polybar/config
# polybar topbar &
# polybar bottombar &

# echo "Polybar launched..."

LaunchBar(){
	MONITOR=$m polybar topbar -c /home/blank/.config/polybar/main_config 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=$m polybar bottombar -c /home/blank/.config/polybar/main_config 2>&1 | tee -a /tmp/polybar1.log & disown
}

# if type "xrandr"
# then
	for m in $(xrandr --query | grep -i " connected" | cut -d" " -f1)
	do
		LaunchBar
	done
# else
# 		LaunchBar
# fi

# Monitors=$(xrandr --query | grep -iv disconnected | grep -i connected | awk '{ print $1 }')
# if [[ ${#Monitors[@]} -gt 1 ]]
# then
# 	for m in ${Monitors[@]}
# 	do
# 		LaunchBar
# 	done
# elif [[ ${#Monitors[@]} -eq 1 ]]
# 	LaunchBar
# fi

