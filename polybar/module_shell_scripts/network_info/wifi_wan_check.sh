#!/bin/bash

wifi_connected(){
		until [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
	do
		sleep 1
	done

	if [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
	then
		return 0
	fi
}

wan_check(){
	local status
	if [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "disconnected" ]]
	then
		wifi_connected
		status=$?
	elif [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
	then
		status=0
	fi

	local init_wan_status=$1
	# ping -c2 -I wlo1 google.com > logs/wifi_wan_check.log
	ping -c2 -I wlo1 google.com &>/dev/null
	local current_wan_status=$?
	while [[ $status -eq 0 ]] && [[ $init_wan_status -eq $current_wan_status ]]
	do
		status=0
		sleep 1
	done
	if [[ $status -eq 1 ]] && ( [[ $init_wan_status -ne $current_wan_status ]] || [[ $init_wan_status -eq $current_wan_status ]] )
	then
		notify-send -u low " Checking WAN connectivity via Wi-Fi "
		case $current_wan_status in
			0) notify-send -u low " Wi-Fi connected to WAN " ;;
			1) notify-send -u normal " WAN not reachable via Wi-Fi " ;;
			2) notify-send -u normal " Wi-Fi not connected to WAN " ;;
			*) notify-send -u normal " Wi-Fi WAN error " ;;
		esac
		init_wan_status=$current_wan_status
		sleep 1
		# wan_check $init_wan_status
	elif [[ $status -eq 0 ]] && [[ $init_wan_status -ne $current_wan_status ]]
	then
		notify-send " Checking WAN connectivity via Wi-Fi "
		case $current_wan_status in
			0) notify-send -u low " Wi-Fi connected to WAN " ;;
			1) notify-send -u normal " WAN not reachable via Wi-Fi " ;;
			2) notify-send -u normal " Wi-Fi not connected to WAN " ;;
			*) notify-send -u normal " Wi-Fi WAN error " ;;
		esac
		init_wan_status=$current_wan_status
		sleep 1
		# wan_check $init_wan_status
	fi
}

Main(){
	wifi_connected
	# ping -c2 -I wlo1 google.com > logs/wifi_wan_check.log
	# ping -c2 -I wlo1 google.com &>/dev/null
	while [[ true ]]
	do
		ping -c2 -I wlo1 google.com &>/dev/null
		wan_check $?
	done
}

Main

