#!/bin/bash

wifi_connected(){
	if [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "disconnected" ]]
	then
		while [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "disconnected" ]]
		do
			sleep 1
		done
	elif [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
	then
		local ssid="$(nmcli connection show --active | grep -i wifi | sed 's/\w*-\w*.*wifi.*//g')"
		notify-send -u low " Wi-Fi connected to SSID $ssid"
		notify-send " Checking for WAN connection via Wi-Fi "
		ping -W 1 -c2 -I wlo1 www.google.com
		case $? in
			0) notify-send -u low " Wi-Fi connected to WAN " ;;
			1) notify-send " Wi-Fi not connected to WAN " ;;
		esac
		while [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
		do
			ping -W 1 -c2 -I wlo1 www.google.com
			wan_check $?
		done
	fi
}

wan_check(){
	local init_ping_stat=$1
	ping -W 1 -c2 -I wlo1 www.google.com
	local current_ping_stat=$?
	if [[ $init_ping_stat -ne $current_ping_stat ]]
	then
		case $current_ping_stat in
			0) notify-send -u low " Wi-Fi connected to WAN " ;;
			1) notify-send " Wi-Fi not connected to WAN " ;;
		esac
	elif [[ $init_ping_stat -eq $current_ping_stat ]]
	then
		while ( [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]] && [[ $init_ping_stat -eq $current_ping_stat ]] )
		do
			ping -W 1 -c2 -I wlo1 www.google.com
			init_ping_stat=$?
			sleep 1
		done
	fi
}

Main(){
	while [[ true ]]
	do
		wifi_connected
	done
}

Main
