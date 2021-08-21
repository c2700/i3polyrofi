#!/bin/bash

disks=($(lsblk -dnlo name | grep -iv "loop\|sr0"))
diskinfo_array=()
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
			"usb") dev_iface="removable USB drive" ;;
			"ata") dev_iface="removable ATA drive" ;;
			"sata") dev_iface="removable SATA drive" ;;
		esac	
	elif [[ $removable_dev -eq 0 ]]
	then
		case $dev_iface_temp in
			"usb") dev_iface="USB drive" ;;
			"ata") dev_iface="ATA drive" ;;
			"sata") dev_iface="SATA drive" ;;
		esac
	fi
	diskinfo_array+=("$(echo $disk_name [/dev/$i] - $disk_size - $dev_pttype - $dev_iface | sed 's/\s\s*/ /g')")
done

for i in "${diskinfo_array[@]}"
do
	notify-send -u low " $i "
done

