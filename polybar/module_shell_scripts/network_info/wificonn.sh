#!/bin/bash

help(){
	clear
	echo -e "\n usage: ./wificonn.sh <ssid> [-a]"
	echo " <ssid>  ssid to connect to"
	echo -e "     -a  prompt for password\n"
}

wificonn(){
	clear
	local EXIT_CODE
	if [[ "$2" == "-a" ]] || [[ "$2" =~ "-a" ]] || [[ "$2" == "--ask-password" ]] || [[ "$2" =~ "--ask-password" ]]
	then
		nmcli device wifi connect "$1" "$2"
		EXIT_CODE=$?
	elif [[ "$2" == "" ]] || [[ "$2" =~ " " ]] || [[ -z "$2" ]]
	then
		nmcli device wifi connect "$1"
		EXIT_CODE=$?
	fi
	return $EXIT_CODE
}


wan_check(){
	clear
	initial_wan_stat=$1
	ping -c 1 -I wlo1
	wan_stat=$?
	[[ $wan_stat -eq $initial_wan_stat ]] && wan_check
	if [[ $wan_stat -ne $initial_wan_stat ]]
	then
		case $wan_stat in
			0) notify-send "()" ;;
			*) notify-send "()" ;;
		esac
		initial_wan_stat=$wan_stat
		wan_stat $initial_wan_stat
	fi
}

Main(){
	clear
	local ssid_input
	local args
	local EXIT_CODE

	if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]
	then
		help
		exit
	fi
	
	if [[ "$1" == "" ]] || [[ "$1" =~ " " ]] || [[ -z "$1" ]]
	then
		echo "ssid not provided. scanning for connections"
		nmcli device wifi list
		# read -p "ssid to connect to: " ssid_input
		ssid_input="$(read -p "ssid to connect to: ")"
		Main "$ssid_input" "$args"
		# Main
	elif [[ "$1" != "" ]] || [[ ! "$1" =~ " " ]] || [[ -n "$1" ]]
	then
		help
		wificonn "$ssid_input" "$args"
		EXIT_CODE=$?
	# elif [[ "$ssid_input" == "-h" ]]
	fi

	case $EXIT_CODE in
		0)
			local ssid="$(nmcli device status | grep 'wifi' | grep -i ' connected' | awk '{ $1=$2=$3=NULL;sub("^\\s*","");print $0 }')"
			notify-send "  SSID - $ssid "
			ping google.com -c1 -I wlo1
			init_wan_access=$?
			wan_check $initc_wan_access
			;;
		10)
			notify-send " $ssid_input not found " 
			Main "$ssid_input" "$args"
			Main
			;;

		*) notify-send " Failed to connect to $ssid_input " ;;
	esac

}

Main "$1" "$2"

