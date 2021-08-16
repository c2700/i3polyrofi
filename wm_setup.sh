#!/bin/bash

# search for collect interfaces
ifaces=($(nmcli device show | grep -i "general.device\|general.type" | grep -iv "p2p\|p2p-\|lo$\|loopback" | awk '{ print $2 }'))

wifi_ifaces=()
ethernet_ifaces=()

a=0
for ((i=1; i <= ${#ifaces[@]}; i+2 ))
do
	if [[ ${ifaces[$i]} == "wifi" ]]
	then
		a=$i
		a=$((a-1))
		wifi_ifaces+=("${ifaces[$a]}")
	elif [[ ${ifaces[$i]} == "ethernet" ]]
	then
		a=$i
		a=$((a-1))
		ethernet_ifaces+=("${ifaces[$a]}")
	fi
done
unset ifaces

# loop to select wifi_iface
# set wireless iface
sed '276s/interface = /interface = /g'

# loop to select ether_iface
# set wireless iface
sed '282s/interface = /interface = /g'

# users to setup this dotfile for

# change vars in my scripts


