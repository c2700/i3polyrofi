#!/bin/bash

eth_connected(){
	if [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
	then
		notify-send " Ethernet not connected "
		while [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
		do
			sleep 1
		done
	elif [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
	then
		local ssid="$(nmcli device status | grep -i ether | grep -i "connect" | awk '{ $1=$2=$3=NULL;sub("\\s+","");print $0 }')"
		notify-send -u low " Ethernet connected "
		notify-send " Checking for WAN connection via Ethernet "
		ping -W 1 -c2 -I enp4s0 www.google.com
		case $? in
			0) notify-send " Ethernet connected to WAN " ;;
			1) notify-send " Ethernet not connected to WAN " ;;
		esac
		while [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
		do
			ping -W 1 -c2 -I enp4s0 www.google.com
			wan_check $?
		done
	fi
}

wan_check(){
	local init_ping_stat=$1
	ping -W 1 -c2 -I enp4s0 www.google.com
	local current_ping_stat=$?
	if [[ $init_ping_stat -ne $current_ping_stat ]]
	then
		case $current_ping_stat in
			0) notify-send " Ethernet connected to WAN " ;;
			1) notify-send " Ethernet not connected to WAN " ;;
		esac
	elif [[ $init_ping_stat -eq $current_ping_stat ]]
	then
		while ( [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]] && [[ $init_ping_stat -eq $current_ping_stat ]] )
		do
			ping -W 1 -c2 -I enp4s0 www.google.com
			init_ping_stat=$?
			sleep 1
		done
	fi
}

Main(){
	while [[ true ]]
	do
		eth_connected
	done
}

Main

