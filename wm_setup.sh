#!/bin/bash

# set wireless iface
wifi_iface=("$(nmcli device | grep -i "wifi" | grep -iv "p2p" | awk '{ print $1 }')")
if [[ ${#wifi_iface[@]} -eq 1 ]]
then
	cat polybar/main_config | sed '270s/interface = /interface = $wifi_iface/g'
	# sed '270s/interface = /interface = $wifi_iface/g'
	echo "Wi-Fi card set to $wifi_iface"
	unset wifi_iface
# loop to select wifi_iface
elif [[ ${#wifi_iface[@]} -gt 1 ]]
then
	a=1
	for i in ${wifi_iface[@]}
	do
		echo " $a) $i"
		a=$((a+1))
	done
	echo ""
	read -p "select wireless interface: " selected_iface
	selected_iface=$((selected_iface-1))
 	cat polybar/main_config | sed '270s/interface = /interface = ${wifi_iface[$selected_iface]}/g'
	echo "Wi-Fi card set to $wifi_iface"
	unset a selected_iface wifi_iface
fi

# loop to select 
ether_iface=("$(nmcli device | grep -i "ethernet" | grep -iv "p2p" | awk '{ print $1 }')")
if [[ ${#ether_iface[@]} -eq 1 ]]
then
	cat polybar/main_config | sed '282s/interface = /interface = $ether_iface/g'
	echo "Ethernet card set to ${ether_iface[0]}"
	unset ether_iface
# set ether_iface iface
elif [[ ${#ether_iface[@]} -gt 1 ]]
then
	a=1
	for i in ${ether_iface[@]}
	do
		echo " $a) $i"
		a=$((a+1))
	done
	echo ""
	read -p "select ethernet interface: " selected_iface
	selected_iface=$((selected_iface-1))
	cat polybar/main_config | sed '282s/interface = /interface = ${ether_iface[$selected_iface]}/g'
	echo "Ethernet card set to $ether_iface"
	unset a selected_iface ether_iface
fi

# cat i3/config | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
# cat polybar/launch.sh | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
# cat polybar/main_config | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
# cat dunst/dunstrc | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'

sed -i i3/config 's/"home\/blank","home\/$(whoami)")/g'
sed -i polybar/launch.sh 's/"home\/blank","home\/$(whoami)"/g'
sed -i polybar/main_config 's/"home\/blank","home\/$(whoami)"/g'
sed -i dunst/dunstrc 's/"home\/blank","home\/$(whoami)"/g'

echo "cp -rfv polybar i3 rofi -t \"/home/$(whoami)/.config\""

