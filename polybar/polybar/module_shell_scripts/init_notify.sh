#!/bin/bash

wifi_check(){
	clear
	local wifi_ipaddr="$(ifconfig wlo1 | grep -i "inet " | awk '{ print $2 }')"
	local wifi_connect_state="$(nmcli device status | grep -i "wifi " | awk '{ print $3 }')"
	local ssid="$(iwgetid -r)"
	local wifi_dev="$(nmcli connection show --active | grep -iv "type\|ethernet" |awk '{ a=0;for(i=1;$i != wifi;i++) { a=i }sub("DEVICE","");print $a}')"
	
	[[ "$wifi_connect_state" == "disconnected" ]] && notify-send -c "init_network_state" " "
	if [[ "$wifi_connect_state" == "connected" ]]
	then
		notify-send -u normal -c "init_network_state" " 泌($ssid)?()"
		# notify-send -u normal -c "init_network_state" " ($ssid)?()"
		# ping google.com -c 1 -I wlo1 >logs/init.log
		ping google.com -c 1 -I wlo1 &>/dev/null
		case $? in
			0) notify-send -u low -c "init_network_state" " ($wifi_dev)泌($ssid)()" ;;
			2)
				local network_profile="$(nmcli device | grep -i " connected" | grep -i "wifi" | awk '{ $1=$2=$3=NULL; sub("^\\s+","");print $0 }')"
				notify-send -c "init_network_state" " ($wifi_dev)($ssid)泌. Not connected to WAN" " ssid - $ssid\n network profile - $network_profile" ;;
		esac
	fi
	clear
}

eth_check(){
	clear
	local ethernet_connect_state="$(nmcli device status | grep -i "ether" | awk '{ print $3 }')"

	( [[ "$ethernet_connect_state" == "disconnected" ]] || [[ "$ethernet_connect_state" == "unavailable" ]] ) && notify-send  -c "init_network_state" " "

	if [[ "$ethernet_connect_state" == "connected" ]]
	then
		local ssid="$(nmcli device status | grep -i ether | grep -i "connect" | awk '{ $1=$2=$3=NULL;sub("\\s+","");print $0 }')"
		notify-send -c "init_network_state" " ($ssid)?()"
		# ping google.com -c 1 -I enp4s0 >logs/init.log
		ping google.com -c 1 -I enp4s0 &>/dev/null
		case $? in
			0) notify-send -u low -c "init_network_state" " ($ssid)()" ;;
			1|2)
				connection_profile="$(nmcli device status | grep -i "ethernet" | awk '{ $1=$2=$3=NULL; sub("^\\s*","");print $0}')"
				# ssid="$(nmcli device status | grep -i "ethernet" | awk '{ $1=$2=$3=NULL; sub("^\\s*","");print $0}')"
				notify-send -c "init_network_state" " ($ssid)()"
				# notify-send -c "init_network_state" " ($ssid)()" " connection profile - $connection_profile" 
				;;
		esac
	fi
	clear
}


battery_check(){
	clear
	local charging_state=$(acpi | awk '{ sub(",","");print $3 }')
	local battery_level=$(acpi | awk '{ sub("%,","");print $4 }')
	local battery_level_percent=$(acpi | awk '{ sub("%,","%");print $4 }')
	case $charging_state in
		"Full") 
				[[ $(cat "/sys/class/power_supply/ACAD/online") -eq 1 ]] && notify-send -u low "  Full. Please unplug the charger " 
				[[ $(cat "/sys/class/power_supply/ACAD/online") -eq 0 ]] && notify-send -u low "  Full " 
				;;
		"Charging")
			case $battery_level in
				2[6-9]|[3-7][0-9]) notify-send " Nearly Dead  at $battery_level_percent " ;;
				1|2) notify-send -u critical " Nearly Dead  $battery_level_percent " ;;
				[3-5]) notify-send -u critical " Extremely critical  at $battery_level_percent " ;;
				[6-9]|10) notify-send -u critical " Critical battery  at $battery_level_percent " ;;
				1[1-9]|2[0-5]) notify-send -u critical "  at $battery_level_percent " ;;
				2[6-9]|[3-8][0-9]) notify-send "  at $battery_level_percent " ;;
				*) notify-send "  at $battery_level_percent " ;;
			esac
			;;
		"Discharging")
			case $battery_level in
				1|2) notify-send -u critical " Nearly Dead  at $battery_level_percent. machine will shutdown in a few seconds " ;;
				[3-5]) notify-send -u critical " Extremely critical  $battery_level_percent " ;;
				[6-9]|10) notify-send -u critical " Critical  at $battery_level_percent " ;;
				1[1-9]|2[0-5]) notify-send -u normal "  Low battery $battery_level_percent " ;;
				2[6-9]|[3-7][0-9]) notify-send "  at $battery_level_percent " ;;
				*) notify-send -u normal "  at $battery_level_percent " ;;
			esac
			;;
	esac
	clear
}

battery_check
wifi_check
eth_check
exit

