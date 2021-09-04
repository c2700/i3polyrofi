#!/bin/bash

wifi_dev="$(nmcli connection show --active | grep -iv "type\|ethernet" |awk '{ a=0;for(i=1;$i != wifi;i++) { a=i }sub("DEVICE","");print $a}')"

pvt_ipv4="$(ip addr show dev $wifi_dev | grep -i "inet " | awk '{ print $1" "$2 }' | sed 's/inet /pvt IPv4 - /g;s/.$/& /g')"
ipv6="$(ip addr show dev $wifi_dev | grep -i "inet6 " | awk '{ print $1" "$2 }' | sed 's/inet6 /  IPv6 - /g;s/.$/& /g')"
ssid="$(iwgetid -r)"
pub_ipv4=""
status=""

wifi_dev="$(nmcli device | grep -i connected | grep -i "wifi " | awk '{ print $1 }')"
if [[ "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send -u low $urgency_lvl -c "wireless_lan" -a "wlan" "  ($wifi_dev)$ssid" "  $pvt_ipv4\n$ipv6  "
elif [[ ! "$pvt_ipv4" =~ "pvt IPv4" ]]
then
	notify-send $urgency_lvl -c "wireless_lan" -a "wlan" " "
fi

# notify-send " ?()"
# # # notify-send " checking WAN state via Wi-Fi "
# # # curl ipinfo.io/ip --interface $wifi_dev &>/dev/null
# ping -W 1 -c2 -i 0.5 -I $wifi_dev www.google.com
# case $? in
# 	0)
# 		pub_ipv4="$(curl ipinfo.io/ip)"
# 		notify-send -u low " ()"
# 		# notify-send -u low " Wi-Fi connected to WAN "
# 		;;
# 	# # 1|2)
# 	# # 	notify-send " ()" ;;
# 	# # 6|7) notify-send " No WAN connectivity " ;;
# 	6|7) notify-send " ()" ;;
# 	*) notify-send " (!)" ;;
# 	# # *) notify-send " WAN Error " ;;		
# esac

