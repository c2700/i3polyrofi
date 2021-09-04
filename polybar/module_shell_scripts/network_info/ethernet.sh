#!/bin/bash

# set -xBv
eth_dev="$(nmcli connection show --active | grep -iv "type" | grep -i "ether" | awk '{ a=0;for(i=1;$i != ethernet;i++) { a=i } print $a}')"
# if [[ -z "$eth_dev" ]] || [[ $eth_dev == "" ]] || [[ "$eth_dev" =~ "" ]] || [[ $eth_dev == " " ]] || [[ "$eth_dev" =~ " " ]]
if [[ "$eth_dev" == "" ]] || [[ "$eth_dev" == " " ]]
then
	notify-send -a "eth" -c "Eth" " "
	exit
fi
pvt_ipv4="$(ip addr show dev $eth_dev | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
# pub_ipv4="$(ip addr show dev $eth_dev | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
ipv6="$(ip addr show dev $eth_dev | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /IPv6 - /g;s/.$/& /g')"
connection="$(nmcli connection show --active | grep -i "ether" | sed 's/\w*-\w*//g;s/\s*ether.*//g')"
status=""
urgency_lvl=""
ssid="$(nmcli device status | grep -i ether | grep -i "connect" | awk '{ $1=$2=$3=NULL;sub("\\s+","");print $0 }')"

set -xvB
if [[ "$pvt_ipv4" =~ "IPv4" ]]
then
	notify-send -u low -c "Eth" -a "eth" "  ($eth_dev)$ssid " "  $pvt_ipv4\n  $ipv6"
	# notify-send -c "Eth" -a "eth" " Ethernet" "  ssid: $ssid\n  $pvt_ipv4\n  $ipv6\n  status: $status"
# else
# 	notify-send -a "eth" -c "Eth" " "
fi
set +xvB

# notify-send " (?)"
# # curl ipinfo.io/ip --interface $eth_dev &>/dev/null
# ping google.com -W 1 -w 0.9 -c 4 $eth_dev &>/dev/null
# case $? in
# 	0)
# 		pub_ipv4=$(curl ipinfo.io/ip)
# 		notify-send -u low " ()"
# 		# notify-send -u low " Ethernet connected to WAN "
# 		;;
# 	1|2|6|7) notify-send " ()" ;;
# 	*) notify-send " !" ;;
# esac
