#!/bin/bash

battery_check(){

	# clear
	# reset
	sleep 1
	local initial_charging_state="$1"
	local charging_state=$(acpi | awk '{ sub(",","");print $3 }')
	local battery_level=$(acpi | awk '{ sub("%,","");sub("%","");print $4 }')
	local battery_level_percent=$(acpi | awk '{ sub("%,","%");print $4 }')

	until [[ "$(acpi | awk '{ sub(",","");print $3 }')" != $initial_charging_state ]]
	do
		sleep 1
	done

	# if [[ $initial_charging_state == "$(acpi | awk '{ sub(",","");print $3 }')" ]] && [[ $battery_level -gt 25 ]]
	# then
		# battery_check $initial_charging_state
	# fi

	# elif [[ $initial_charging_state != "$(acpi | awk '{ sub(",","");print $3 }')" ]]
	if [[ $initial_charging_state != "$(acpi | awk '{ sub(",","");print $3 }')" ]]
	then
		initial_charging_state="$(acpi | awk '{ sub(",","");print $3 }')"
		charging_state="$initial_charging_state"
	fi

	case $charging_state in
		"Full") 
			notify-send -u low " Battery is Fully Charged. Please unplug the charger "
			battery_check $initial_charging_state
			;;

		"Charging")
				( [[ $battery_level -ge 11 ]] && [[ $battery_level -le 25 ]] ) && notify-send -u normal " Low battery $battery_level_percent and charging "
				( [[ $battery_level -ge 6 ]] && [[ $battery_level -le 10 ]] ) && notify-send -u critical " Critical battery $battery_level_percent and charging "
				( [[ $battery_level -ge 3 ]] && [[ $battery_level -le 5 ]] ) && notify-send -u critical " Extremely critical battery $battery_level_percent and charging "
				( [[ $battery_level -le 2 ]] ) && notify-send -u critical " Nearly Dead battery $battery_level_percent and charging "
				( [[ $battery_level -le 1 ]] ) && notify-send -u critical " Nearly Dead battery $battery_level_percent and charging "
				( [[ $battery_level -gt 25 ]] && [[ $battery_level -lt 60 ]] ) && notify-send -u normal " Battery at $battery_level_percent and charging "
				( [[ $battery_level -gt 61 ]] && [[ $battery_level -lt 99 ]] ) && notify-send -u low " Battery at $battery_level_percent and charging "
			battery_check $initial_charging_state
			;;

		"Discharging")
				( [[ $battery_level -ge 11 ]] && [[ $battery_level -le 25 ]] ) && notify-send -u normal " Low battery $battery_level_percent and discharging "
				( [[ $battery_level -ge 6 ]] && [[ $battery_level -le 10 ]] ) && notify-send -u critical " Critical battery $battery_level_percent and discharging "
				( [[ $battery_level -ge 3 ]] && [[ $battery_level -le 5 ]] ) && notify-send -u critical " Extremely critical battery $battery_level_percent and discharging "
				( [[ $battery_level -le 2 ]] ) && notify-send -u critical " Nearly Dead battery $battery_level_percent, discharging and machine will die in a few seconds "
				( [[ $battery_level -le 1 ]] ) && notify-send -u critical " Nearly Dead battery $battery_level_percent, discharging and machine will die in a few seconds "
				( [[ $battery_level -gt 25 ]] && [[ $battery_level -lt 60 ]] ) && notify-send -u normal " Battery at $battery_level_percent and discharging "
				( [[ $battery_level -gt 61 ]] && [[ $battery_level -lt 99 ]] ) && notify-send -u low " Battery at $battery_level_percent and discharging "
				( [[ $battery_level -eq 100 ]] || [[ $battery_level == "Full" ]] ) && notify-send -u low " Battery full and discharging "
			battery_check $initial_charging_state
			;;
	esac
	# clear
	# reset
}


init_charging_state=$(acpi | awk '{ sub(",","");print $3 }')
battery_check $init_charging_state

