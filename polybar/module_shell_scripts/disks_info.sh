#!/bin/bash

disk_partition_info(){
	clear
	local disk_temp="$(echo "$1" | sed 's/[0-9]*//g')"
	local disk_arrays=($(lsblk -ln /dev/$disk_temp -o name | grep -iv "$disk_temp$"))
	local name=""

	if [[ -z ${disk_arrays[@]} ]]
	then
		echo " Disk does not contain a partition "
	elif [[ -n ${disk_arrays[@]} ]]
	then
		if [[ ${#disk_arrays[@]} -eq 1 ]]
		then
			name=" /dev/$(lsblk "/dev/$1" -nlo name)"
		elif [[ ${#disk_arrays[@]} -gt 1 ]]
		then
			if [[ "$1" == "${disk_arrays[-1]}" ]]
			then
				name=" \`-/dev/$(lsblk "/dev/$1" -nlo name)"
			elif [[ "$1" != "${disk_arrays[-1]}" ]]
			then
				name=" |-/dev/$(lsblk "/dev/$1" -nlo name)"
			fi
		fi
		
		local mntpt="$(lsblk "/dev/$1" -nlo mountpoint)"
		local size="$(lsblk "/dev/$1" -nlo size | sed 's/^\s*//g;s/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
		local fstype="$(lsblk "/dev/$1" -no fstype,fsver | sed 's/swap   1/SWAP/g;s/vfat   FAT32/FAT32/g;s/ext4   1.0/EXT4/g;s/ntfs\s*/NTFS/g')"
		local used_space="$(lsblk "/dev/$1" -no fsused | sed 's/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
		local part_size="$(lsblk "/dev/$1" -no size | sed 's/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
		local fssize="$(lsblk "/dev/$1" -no fssize | awk '{ sub("^\\s+","");print $0 }' | sed 's/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
		local free_partition_size="$(lsblk "/dev/$1" -no fsavail | sed 's/^\s*//g;s/M/ MB/g;s/G/ GB/g;s/T/ TB/g')"
	
		local disk_parttypename="$(lsblk "/dev/$1" -no parttypename)"
		local partition_use_percentage=" $(lsblk "/dev/$1" -no fsuse%) "
		local disk_part_info_string=""
	
		local part_label="$(lsblk "/dev/$1" -no partlabel)"

		if [[ $part_label == "" ]] || [[ -z $part_label ]] || [[ $part_label =~ "\s+" ]]
		then
			part_label="(None)"
		fi
	
		if [[ $fstype == "" ]] || [[ -z $fstype ]] || [[ $fstype =~ " " ]]
		then
			fstype="(None)"
		fi
	
		if [[ $mntpt == "" ]] || [[ -z $mntpt ]] || [[ $mntpt =~ " " ]]
		then
			disk_part_info_string=" $name - [T: $size] [L: $part_label] [PT: $disk_parttypename] [FS: $fstype] "
		elif [[ $mntpt != "" ]] || [[ -n $mntpt ]] || [[ ! $mntpt =~ " " ]]
		then
			if [[ $mntpt == "/" ]] || [[ $mntpt =~ "/home/\w*/$" ]] || [[ $mntpt =~ "/boot" ]] || [[ $mntpt == "[SWAP]" ]]
			then
				if [[ $fstype == "swap" ]]
				then
					disk_part_info_string=" $name ($mntpt) - [T: $size] [L: $part_label] [PT: $disk_parttypename] [FS: $fstype] "
				elif [[ $fstype != "swap" ]]
				then
					disk_part_info_string=" $name ($mntpt) - [T: $size] [U: $free_partition_size] [L: $part_label] [PT: $disk_parttypename] [FS: $fstype] "
				fi

			elif [[ $mntpt =~ "/home(/\w*)/" ]] || [[ ! $mntpt =~ "/boot" ]]
			then
				if [[ $fstype == "swap" ]]
				then
					spaces=""
					for (( i=0;i <= ${#mntpt}; i++ )){
						spaces+=" "
					}
					disk_part_info_string=" $name ($mntpt) - [T: $size] [L: $part_label]\n$spaces [PT: $disk_parttypename] [FS: $fstype] "
					unset spaces
				elif [[ $fstype != "swap" ]]
				then
					spaces=""
					for (( i=0;i <= $((${#mntpt}+${#name}+2)); i++ )){
						spaces+=" "
					}
					disk_part_info_string=" $name ($mntpt) - [T: $size] [U: $free_partition_size] [L: $part_label]\n  |$spaces [PT: $disk_parttypename] [FS: $fstype] "
				fi
			fi
		fi
		echo "$disk_part_info_string"
	fi
	clear
}

Disk_info(){
	clear
	local disk_kname="$1"
	local disk_name="$(lsblk /dev/$disk_kname -dlno vendor,model | awk '{ sub("\\s+"," "); print $0 }')"
	local disk_size="$(lsblk /dev/$disk_kname -dlno size | sed 's/G/ GB/g;s/M/ MB/g;s/T/ TB/g')"
	local dev_iface="$(lsblk /dev/$disk_kname -dlno tran)"
	local dev_pttype="$(lsblk /dev/$disk_kname -dlno pttype | tr [a-z] [A-Z])"
	local removable_dev=$(lsblk /dev/$disk_kname -dlno rm)
	local hotplug_dev=$(lsblk /dev/$disk_kname -dlno hotplug)
	local drive_type=$(lsblk /dev/$disk_kname -dlno rota)
	local disk_type=""

	if [[ $removable_dev -eq 1 ]]
	then
		case $dev_iface in
			"usb") disk_type="removable USB drive" ;;
			"ata") disk_type="removable ATA drive" ;;
			"sata") disk_type="removable SATA drive" ;;
		esac
	elif [[ $removable_dev -eq 0 ]]
	then
		case $dev_iface in
			"usb") disk_type="USB drive" ;;
			"ata") disk_type="ATA drive" ;;
			"sata") disk_type="SATA drive" ;;
		esac
	fi
	disk_info_string_summary=" $disk_name [/dev/$disk_kname - ($disk_size - $dev_pttype) - $disk_type] "
	local disk_info_string_body=""

	local disk_parts_array=($(lsblk -nlo name /dev/$disk_kname | grep -iv "$disk_kname$"))
	for i in ${disk_parts_array[@]}
	do
		disk_info_string_body+="$(disk_partition_info $i)"
		disk_info_string_body+="\n"
	done
	
	disk_info_string+="\n"
	# dunstify -t 0 "$disk_info_string_summary" "$disk_info_string_body"
	notify-send -u low -t 0 "$disk_info_string_summary" "$disk_info_string_body"
	unset $disk_info_string
	clear
}

disks_info=""
disks=($(lsblk -dnlo name | grep -iv "loop\|sr[0-9]*"))
for i in ${disks[@]}
do
	Disk_info $i
done


