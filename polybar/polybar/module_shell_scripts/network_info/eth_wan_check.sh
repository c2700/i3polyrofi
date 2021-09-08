#!/bin/bash

eth_connected(){
	if [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
	then
		notify-send " "
		while [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "unavailable" ]]
		do
			sleep 1
		done
	elif [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
	then
		local ssid="$(nmcli device status | grep -i ether | grep -i "connect" | awk '{ $1=$2=$3=NULL;sub("\\s+","");print $0 }')"
		notify-send -u low "  $ssid"
		notify-send " ?()"
		eth_dev="$(nmcli connection show --active | grep -iv "type" | grep -i "ether" | awk '{ a=0;for(i=1;$i != ethernet;i++) { a=i } print $a}')"
		ping -i 0.5 -W 0.5 -c 2 -I $eth_dev www.google.com &>/dev/null
		case $? in
			0) notify-send " ()" ;;
			1|2) notify-send " ()" ;;
			*) notify-send " ()" ;;
			# *) notify-send " ()" ;;
		esac
		while [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]]
		do
			ping -i 0.5 -W 0.5 -c 2 -I $eth_dev www.google.com &>/dev/null
			wan_check $?
		done
	fi
}

wan_check(){
	local init_ping_stat=$1
	eth_dev="$(nmcli connection show --active | grep -iv "type" | grep -i "ether" | awk '{ a=0;for(i=1;$i != ethernet;i++) { a=i } print $a}')"
	ping -i 0.5 -W 0.5 -c 2 -I $eth_dev www.google.com &>/dev/null
	local current_ping_stat=$?
	echo "init_ping_stat - $init_ping_stat current_ping_stat - $current_ping_stat"
	if [[ $init_ping_stat -ne $current_ping_stat ]]
	then
		case $current_ping_stat in
			0) notify-send " ()" ;;
			1|2) notify-send " ()" ;;
			*) notify-send " (!)" ;;
			# *) notify-send " ()" ;;
		esac
	elif [[ $init_ping_stat -eq $current_ping_stat ]]
	then
		while ( [[ "$(nmcli device status | grep -i "ethernet" | awk '{ print $3 }')" == "connected" ]] && [[ $init_ping_stat -eq $current_ping_stat ]] )
		do
			ping -i 0.5 -W 0.5 google.com -I $eth_dev -c 2 &>/dev/null
			init_ping_stat=$?
			sleep 1
		done
	fi
}

Main(){
	while [[ $DESKTOP_SESSION == "i3" ]]
	do
		eth_connected
	done
	exit
}

Main
