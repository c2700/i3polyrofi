#!/bin/bash

wifi_dev="$(nmcli connection show --active | grep -iv "type" | grep -i "wifi" | awk '{ a=0;for(i=1;$i != ethernet;i++) { a=i } print $a}')"
wifi_connected(){
	if [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "disconnected" ]]
	then
		notify-send " "
		while [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "disconnected" ]]
		do
			sleep 1
		done
	elif [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
	then
		local ssid="$(iwgetid -r)"
		# notify-send -u low " ($wifi_dev)$ssid"
		./wifi.sh
		notify-send " ?()"
		ping www.google.com -i 0.5 -W 1 -c2 -I $wifi_dev &>/dev/null
		
		curl ipinfo.io/ip --interface $wifi_dev &>/dev/null
		case $? in
			0) notify-send -u low " ()" ;;
			1|2) notify-send " ()" ;;
		esac
		
		while [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]]
		do
			# curl ipinfo.io/ip --interface $wifi_dev &>/dev/null
			# curl ipinfo.io/ip --interface $wifi_dev
			ping www.google.com -i 0.5 -W 1 -c2 -I $wifi_dev &>/dev/null
			wan_check $?
		done
	fi
}

wan_check(){
	local init_ping_stat=$1
	local ssid="$(iwgetid -r)"
	
	# curl --url ipinfo.io/ip --interface $wifi_dev &>/dev/null
	# curl --url ipinfo.io/ip --interface $wifi_dev
	ping www.google.com -i 0.5 -W 1 -c2 -I $wifi_dev &>/dev/null
	local current_ping_stat=$?
	
	if [[ $init_ping_stat -ne $current_ping_stat ]]
	then
		# echo "$init_ping_stat - init_ping_stat | current_ping_stat - $current_ping_stat"
		case $current_ping_stat in
			0) notify-send -u low " ()" ;;
			1) notify-send " ()" ;;
		esac
	elif [[ $init_ping_stat -eq $current_ping_stat ]]
	then
		while ( [[ "$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')" == "connected" ]] && [[ $init_ping_stat -eq $current_ping_stat ]] )
		do
			
			# curl --url ipinfo.io/ip --interface $wifi_dev &>/dev/null
			# curl --url ipinfo.io/ip --interface $wifi_dev
			ping www.google.com -i 0.5 -W 1 -c2 -I $wifi_dev &>/dev/null
			init_ping_stat=$?
			sleep 1
			
		done
	fi
}

Main(){
	while [[ $DESKTOP_SESSION == "i3" ]]
	do
		wifi_connected
	done
	exit
}


Main
