#!/bin/bash

disks=($(lsblk -dnlo name | grep -iv "loop\|sr0"))
diskinfo_array=()
head_lines=""
max_length=""
for i in ${disks[@]}
do
	dev_iface=""

	disk_name="$(lsblk "/dev/$i" -dnlo vendor,model | sed 's/\s\s*/ /g')"
	disk_size="$(lsblk "/dev/$i" -dnlo size | sed 's/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
	dev_iface_temp="$(lsblk /dev/$i -dlno tran)"
	dev_pttype="$(lsblk /dev/$i -dlno pttype | tr [a-z] [A-Z])"
	removable_dev=$(lsblk /dev/$i -dlno rm)
	if [[ $removable_dev -eq 1 ]]
	then
		case $dev_iface_temp in
			"usb") dev_iface="removable 禍" ;;
			"ata") dev_iface="removable ATA " ;;
			"sata") dev_iface="removable SATA " ;;
		esac	
	elif [[ $removable_dev -eq 0 ]]
	then
		case $dev_iface_temp in
			"usb") dev_iface="USB 禍" ;;
			"ata") dev_iface="ATA " ;;
			"sata") dev_iface="SATA " ;;
		esac
	fi
	disk_info="  $(echo $dev_iface - $disk_size - $dev_pttype - $disk_name [/dev/$i] | sed 's/\s\s*/ /g')\n"
	max_length=${#disk_info}
	length=${#disk_info}

	[[ $max_length < $length ]] && max_length=$length

	disk_info+="   "
	if [[ "$i" != "${disks[-1]}" ]]
	then
	 	for (( j=0; j <= $length; j++ )){
	 		disk_info+="-"
	 	}
	fi
	diskinfo_array+=("$disk_info\n")
	unset disk_info
done

for (( j=0;j<=$max_length;j++ )){
	head_lines+="-"
}

notify-send -u low " Attached Disks " " ${head_lines}\n ${diskinfo_array[*]}"
