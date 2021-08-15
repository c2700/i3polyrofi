#!/bin/bash

pvt_ipv4="$(ip addr show dev enp4s0 | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
pub_ipv4=""
ipv6="$(ip addr show dev enp4s0 | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /IPv6 - /g;s/.$/& /g')"
ssid="$(nmcli device | grep -i " connected" | grep -i "ether" | awk '{ $1=$2=$3=NULL; sub("^\\s+","");print $0 }')"
status=""
urgency_lvl=""
ping -I enp4s0 -c1 www.google.com &>/dev/null
PING_EXIT_CODE=$?
case $PING_EXIT_CODE in
	0)
		status="connected to WAN"
		pub_ipv4=$(curl ipinfo.io/ip)
		urgency_lvl="-u low"
		;;
	
	# 1)
	# 	status="WAN unreachable"
	# 	urgency_lvl="-u normal"
	# 	;;
	2|1)
		status="No WAN connectivity"
		urgency_lvl="-u normal"
		;;
	*)
		status="WAN error"
		urgency_lvl="-u normal"
		;;
esac

if [[ "$pvt_ipv4" =~ "IPv4" ]]
then
	notify-send -c "Eth" -a "eth" " Ethernet" "  ssid: $ssid\n  $pvt_ipv4\n  $ipv6\n  status: $status"
else
	notify-send -a "eth" -c "Eth" " Ethernet" " not connected to a network\n$status"
fi

