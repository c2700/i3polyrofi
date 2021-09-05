#!/bin/bash

set -xvB

battery_lvl_notify(){
	local m_battery_level_percent=$(acpi | awk '{ sub("%,","%");print $4 }')
	local current_battery_level=$(acpi | awk '{ sub("%,","");sub("%","");print $4 }')
	battery_levels=(1 2 3 5 10 20 30 40 50 60 70 80 90 99)
	local notified_battery_lvl
	local index

	for i in ${#battery_levels[@]}
	do
		if [[ ${battery_levels[$i]} -eq $current_battery_level ]]
		then
			notified_battery_lvl=${battery_levels[$i]}
			index=$i
		fi
	done

	# if [[ $notified_battery_lvl -ge $current_battery_level ]] && [[ $notified_battery_lvl -lt ${battery_levels[$index]} ]]
	# if [[ $notified_battery_lvl -ge $current_battery_level ]] && [[ $notified_battery_lvl -lt ${battery_levels[$index]} ]]

	if [[ $notified_battery_lvl -eq $current_battery_level ]] || [[ $notified_battery_lvl -ge $current_battery_level ]] || [[ $notified_battery_lvl -le $current_battery_level ]]
	then
		case $current_battery_level in
			1) notify-send -u critical "  at $m_battery_level_percent. battery almost empty. machine will shutdown in a few seconds " ;;
			2) notify-send -u critical "  at $m_battery_level_percent. extremely critical battery " ;;
			3) notify-send -u critical "  at $m_battery_level_percent. critical critical battery " ;;
			5) notify-send -u critical "  at $m_battery_level_percent. critical battery " ;;
			10) notify-send -u critical "  at $m_battery_level_percent - low battery " ;;
			20) notify-send -u critical "  at $m_battery_level_percent " ;;
			30) notify-send -u normal "  at $m_battery_level_percent " ;;
			40) notify-send -u normal "  at $m_battery_level_percent " ;;
			50) notify-send -u normal "  at $m_battery_level_percent " ;;
			60) notify-send -u normal "  at $m_battery_level_percent " ;;
			70) notify-send -u normal "  at $m_battery_level_percent " ;;
			80) notify-send -u normal "  at $m_battery_level_percent " ;;
			90) notify-send -u low "  at $m_battery_level_percent " ;;
			99) notify-send -u low "  at $m_battery_level_percent " ;;
		esac
	fi
	
	# index=$((index-1))
	# until [[ $notified_battery_lvl -ge $current_battery_level ]] && [[ $notified_battery_lvl -lt ${battery_levels[$index]} ]]
	# do
	# 	sleep 1
	# done

	battery_check $initial_charging_state
	unset m_battery_level_percent current_battery_level notified_battery_lvl battery_levels index
}

battery_check(){
	local battery_level=$(acpi | awk '{ sub("%,","");sub("%","");print $4 }')
	local battery_level_percent=$(acpi | awk '{ sub("%,","%");print $4 }')
	local initial_charging_state="$1"
	local charging_state="$(acpi | awk '{ sub(",","");print $3 }')"

	# echo "func: unchanged {\$1-$1 : initial_charging_state-$initial_charging_state} -> charging_state-$charging_state"
	while [[ "$initial_charging_state" == "$(acpi | awk '{ sub(",","");print $3 }')" ]]
	# until [[ "$initial_charging_state" != "$(acpi | awk '{ sub(",","");print $3 }')" ]]
	do
		echo "nice"
	done
	charging_state="$(acpi | awk '{ sub(",","");print $3 }')"
	# echo "func: changed - initial_charging_state-$initial_charging_state -> charging_state-$charging_state"

	# if [[ "$(acpi | awk '{ sub(",","");print $3 }')" != "$initial_charging_state" ]]
	# if [[ "$charging_state" != "$initial_charging_state" ]]
	if [[ "$charging_state" == "$initial_charging_state" ]]
	then
		case $charging_state in
			"Full")
				[[ $(cat "/sys/class/power_supply/ACAD/online") -eq 1 ]] && notify-send -u low "  Full. Please unplug the charger " 
				[[ $(cat "/sys/class/power_supply/ACAD/online") -eq 0 ]] && notify-send -u low "  Full " 
				unset battery_level battery_level_percent initial_charging_state charging_state
				;;
			# "Full") notify-send -u low "  - Full. Please unplug the charger " ;;
			"Charging")
					( [[ $battery_level -eq 1 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -eq 2 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 3 ]] && [[ $battery_level -le 5 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 6 ]] && [[ $battery_level -le 10 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 11 ]] && [[ $battery_level -le 19 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 20 ]] && [[ $battery_level -le 29 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 30 ]] && [[ $battery_level -le 39 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 40 ]] && [[ $battery_level -le 49 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 50 ]] && [[ $battery_level -le 59 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 60 ]] && [[ $battery_level -le 69 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 70 ]] && [[ $battery_level -le 79 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 80 ]] && [[ $battery_level -le 89 ]] ) && notify-send -u low "  at $battery_level_percent "
					( [[ $battery_level -ge 90 ]] && [[ $battery_level -le 99 ]] ) && notify-send -u low "  at $battery_level_percent "
					[[ $battery_level -eq 100 ]] && notify-send -u low "  - Full. Please unplug the charger "
					unset battery_level battery_level_percent initial_charging_state charging_state
					;;

			"Discharging")
					( [[ $battery_level -eq 1 ]] ) && notify-send -u critical "  at $battery_level_percent. Machine will die in a few seconds "
					[[ $battery_level -eq 2 ]] && notify-send -u critical "  at $battery_level_percent. Machine will die in a few seconds "
					( [[ $battery_level -eq 3 ]]  && [[ $battery_level -le 5 ]]) && notify-send -u critical "  at $battery_level_percent. Machine will die in a few seconds "

					( [[ $battery_level -ge 6 ]] && [[ $battery_level -le 10 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 11 ]] && [[ $battery_level -le 19 ]] ) && notify-send -u critical "  at $battery_level_percent "
					( [[ $battery_level -ge 20 ]] && [[ $battery_level -le 29 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 30 ]] && [[ $battery_level -le 39 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 40 ]] && [[ $battery_level -le 49 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 50 ]] && [[ $battery_level -le 59 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 60 ]] && [[ $battery_level -le 69 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 70 ]] && [[ $battery_level -le 79 ]] ) && notify-send -u normal "  at $battery_level_percent "
					( [[ $battery_level -ge 80 ]] && [[ $battery_level -le 89 ]] ) && notify-send -u low "  at $battery_level_percent "
					( [[ $battery_level -ge 90 ]] && [[ $battery_level -le 99 ]] ) && notify-send -u low "  at $battery_level_percent "
					[[ $battery_level -eq 100 ]] && notify-send -u low "  - Full"
					unset battery_level battery_level_percent initial_charging_state charging_state
					battery_lvl_notify
					;;
		esac
		battery_check $initial_charging_state
	fi
}


while [[ true ]]; do
	sleep 1
	init_charging_state=$(acpi | awk '{ sub(",","");print $3 }')
	battery_check $init_charging_state
	unset init_charging_state
done


