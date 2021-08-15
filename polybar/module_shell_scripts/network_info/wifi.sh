#!/bin/bash

pvt_ipv4="$(ip addr show dev wlo1 | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
ipv6="$(ip addr show dev wlo1 | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /  IPv6 - /g;s/.$/& /g')"
ssid="$(nmcli device | grep -i " connected" | grep -i "wifi" | awk '{ $1=$2=$3=NULL; sub("^\\s+","");print $0 }')"
pub_ipv4=""
status=""

urgency_lvl=""
ping -I wlo1 -c1 www.google.com &>/dev/null
case $? in
	0)
		status="connected to WAN"
		pub_ipv4="$(curl ipinfo.io/ip)"
		urgency_lvl="-u low"
		;;
	# 1)
	# 	status="WAN unreachable"
	# 	urgency_lvl="-u normal"
	# 	;;
	1|2)
		status="No WAN connectivity"
		urgency_lvl="-u normal"
		;;
	*)
		status="WAN error"
		urgency_lvl="-u normal"
		;;
		
esac

if [[ "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send $urgency_lvl -c "wireless_lan" -a "wlan" " wi-fi" "  ssid - $ssid\n  $pvt_ipv4\n$ipv6\n  status: $status"
elif [[ ! "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send $urgency_lvl -c "wireless_lan" -a "wlan" " wi-fi not connected to a network"
fi

