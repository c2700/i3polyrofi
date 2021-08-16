#!/bin/bash

wifi_dev="$(nmcli connection show --active | grep -iv "type\|ethernet" |awk '{ a=0;for(i=1;$i != wifi;i++) { a=i }sub("DEVICE","");print $a}')"

pvt_ipv4="$(ip addr show dev $wifi_dev | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
ipv6="$(ip addr show dev $wifi_dev | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /  IPv6 - /g;s/.$/& /g')"
# ssid="$(nmcli device | grep -i " connected" | grep -i "wifi" | awk '{ $1=$2=$3=NULL; sub("^\\s+","");print $0 }')"
ssid="$(nmcli connection show --a | grep -i wifi | sed 's/\w*-\w*//g;s/\s*wifi.*//g')"
pub_ipv4=""
status=""

if [[ "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send -u low $urgency_lvl -c "wireless_lan" -a "wlan" " wi-fi" "  ssid - $ssid\n  $pvt_ipv4\n$ipv6  "
elif [[ ! "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send $urgency_lvl -c "wireless_lan" -a "wlan" " Wi-Fi not connected to a network"
fi

notify-send " checking WAN state via Wi-Fi "
curl ipinfo.io/ip --interface $wifi_dev &>/dev/null
case $? in
	0)
		pub_ipv4="$(curl ipinfo.io/ip)"
		notify-send -u low " Wi-Fi connected to WAN "
		;;
	# 1)
	# 	status="WAN unreachable"
	# 	urgency_lvl="-u normal"
	# 	;;
	# 1|2)
	6|7) notify-send " No WAN connectivity " ;;
	*) notify-send " WAN error " ;;
		
esac

