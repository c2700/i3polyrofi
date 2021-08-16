#!/bin/bash

eth_dev="$(nmcli connection show --active | grep -iv "type\|wifi"  |awk '{ a=0;for(i=1;$i != ethernet;i++) { a=i }sub("DEVICE","");print $a}')"
pvt_ipv4="$(ip addr show dev $eth_dev | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
pub_ipv4=""
ipv6="$(ip addr show dev $eth_dev | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /IPv6 - /g;s/.$/& /g')"
connection="$(nmcli connection show --active | grep -i "ether" | sed 's/\w*-\w*//g;s/\s*ether.*//g')"
status=""
urgency_lvl=""

if [[ "$pvt_ipv4" =~ "IPv4" ]]
then
	notify-send -u low -c "Eth" -a "eth" " Ethernet" "  connection: $connection\n  $pvt_ipv4\n  $ipv6  "
	# notify-send -c "Eth" -a "eth" " Ethernet" "  ssid: $ssid\n  $pvt_ipv4\n  $ipv6\n  status: $status"
else
	notify-send -a "eth" -c "Eth" " Ethernet" " not connected to a network\n$status "
fi
notify-send " checking WAN state via ethernet "

curl ipinfo.io/ip --interface $eth_dev &>/dev/null
case $? in
	0)
		pub_ipv4=$(curl ipinfo.io/ip)
		notify-send -u low " Wi=Fi connected to WAN "
		;;
	6|7) notify-send " Ethernet not connected to WAN " ;;
	*) notify-send " WAN error " ;;
esac


