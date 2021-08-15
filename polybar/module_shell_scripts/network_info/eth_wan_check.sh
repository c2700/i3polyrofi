#!/bin/bash

eth_connected(){
	clear
	if [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
	then
		notify-send -u low " connected to ssid $ssid "
		until [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
		do
			sleep 1
		done
		local ssid="$(nmcli device status | grep -i "ethernet" | awk '{ $1=$2=$3=NULL;sub("^\\s+","");print $0 }')"
		return 1
	elif [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
	then
		return 0
	fi
	clear
}

wan_check(){
	clear
	local status
	if [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
	then
		notify-send " Ethernet disconnected "
		until [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" != "unavailable" ]]
		do
			sleep 1
		done
	# if [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
	# then
	# 	eth_connected
	# 	status=$?
	# elif [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
	elif [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
	then
		status=0
	fi

	local init_wan_status=$1
	ping -c1 -I enp4s0 google.com &>/dev/null
	local current_wan_status=$?
	# ping -c1 -I enp4s0 google.com > logs/eth_wan_check.log
	while [[ $status -eq 0 ]] && [[ $init_wan_status -eq $current_wan_status ]]
	# until [[ $status -ne 0 ]] && [[ $init_wan_status -ne $current_wan_status ]]
	do
		status=0
	done
	# if [[ $status -eq 0 ]] && [[ $init_wan_status -eq $current_wan_status ]]
	# then
	# 	status=0
	# 	wan_check $init_wan_status
	# if [[ $status -eq 1 ]] && ( [[ $init_wan_status -ne $current_wan_status ]] || [[ $init_wan_status -eq $current_wan_status ]] )
	if [[ $status -eq 1 ]] && ( [[ $init_wan_status -ne $current_wan_status ]] || [[ $init_wan_status -eq $current_wan_status ]] )
	then
		notify-send -u low " Checking WAN connectivity via Ethernet "
		case $current_wan_status in
			0) notify-send -u low " Ethernet connected to WAN " ;;
			1) notify-send " WAN not reachable via Ethernet " ;;
			2) notify-send " Ethernet not connected to WAN " ;;
			*) notify-send " Ethernet WAN error " ;;
		esac
		init_wan_status=$current_wan_status
		wan_check $init_wan_status
	elif [[ $status -eq 0 ]] && [[ $init_wan_status -ne $current_wan_status ]]
	then
		notify-send -u low " Checking WAN connectivity via Ethernet "
		case $current_wan_status in
			0) notify-send -u low " Ethernet connected to WAN " ;;
			1) notify-send " WAN not reachable via Ethernet " ;;
			2) notify-send " Ethernet not connected to WAN " ;;
			*) notify-send " Ethernet WAN error " ;;
		esac
		init_wan_status=$current_wan_status
		# wan_check $init_wan_status
	fi
	clear
}

Main(){
	clear
	eth_connected
	ping -c1 -I enp4s0 google.com &>/dev/null
	# ping -c1 -I enp4s0 google.com > logs/eth_wan_check.log
	# local PING_EXIT_CODE=$?
	while [[ true ]]
	do
		ping -c1 -I enp4s0 google.com &>/dev/null
		wan_check $?
	done
	# clear
}

# set -xvB
Main

