#!/bin/bash

if [[ $DESKTOP_SESSION != "i3" ]]
then
	echo "This rice setup is for i3-gaps Window Manager. Please run Your Linux machine on i3-gaps Window Manager"
	echo "Checking if i3 -gaps window manager is installed"
	sudo pacman --noconfirm -Qs i3-gaps
	case $? in
		0) echo "i3-gaps is installed. please kill the current session and login with i3-gaps running (i3-gaps could be shown as "i3" on your display manager's "session menu")" ;;
		1) 
			read "i3 is not installed. Install i3? [y/n]" choice
			case $choice in
				'y'|'Y'|['yY']['eE']['sS']) 
					sudo pacman -Syvd --noconfirm i3-gaps
					echo "i3 has been installed"
					;;
				'n'|'N'|['nN']['oO']) echo "i3-gaps needs to be installed and run for this setup to run" ;;
			esac
			;;
	esac
	exit

elif [[ $DESKTOP_SESSION == "i3" ]]
then
	echo "copying dunst i3 polybar and rofi config files to /home/$(whoami)/.config"
	sleep 3
	cp -rfv dunst i3 polybar rofi "/home/$(whoami)/.config"
	echo "Need to install bs4 (python module), NerdFonts, dunst rofi, rofi-calc and rofi-file-browser-extended-git"
	echo "Installing dunst, rofi, rofi-calc"
	sudo pacman -Syvd --noconfirm dunst rofi rofi-calc
	echo "Downloading rofi-file-browser-extended"
	git clone https://github.com/marvinkreis/rofi-file-browser-extended
	echo "Installing rofi-file-browser-extended"
	sleep 3
	cd rofi-file-browser-extended
	makepkg -i
	# makepkg -sdi
	# makepkg -sd
	# sudo pacman -Uvd --noconfirm *rofi-file-browser*.pkg.tar.*
	cd ..
	echo "Downloading bs4"
	wget -cdv $(curl https://pypi.org/project/bs4/#files | grep -i pythonhosted | sed 's/\s*<a href="//g;s/">//g')
	echo "Installing bs4"
	pip install "$(ls bs4-*)"
	echo "Downloading NerdFonts"
	python3 extract_nerdfonts.py
	cd NerdFonts
	wget -cdvi nerd_fonts_v2.1.0.txt
	rm -rfv nerd_fonts_v2.1.0.txt
	echo "Installing NerdFonts"
	# copy nerdfonts files to relevant directories

	terms=($(pqqs "terminal emulator" | grep -iv "lib"))
	if [[ ${#terms[@]} -eq 0 ]]
	then
		echo "no terminal emulators found. Installing vte3"
		sudo pacman -Syvd --noconfirm vte3
		VTE3="$(pacman -Ql vte3 | grep -iv "bin/$" | grep -i "bin" | awk '{ print $2 }')"
		cat /home/$(whoami)/.config/i3/config | sed 's/konsole/$VTE3/g'
		# sed -i /home/$(whoami)/.config/i3/config 's/konsole/$VTE3/g'
	elif [[ ${#terms[@]} -eq 1 ]]
	then
		sed -i /home/$(whoami)/.config/i3/config 's/konsole/${terms[0]}/g'
		# cat /home/$(whoami)/.config/i3/config | sed 's/konsole/${terms[0]}/g'
		echo "terminal set to ${terms[0]}"
	elif [[ ${#terms[@]} -gt 1 ]]
	then
		a=1
		for i in ${terms[@]}
		do
			echo " $a) $i"
			a=$((a+1))
		done
		echo ""
		read -p "select terminal emulator to use: " selected_terminal
		selected_terminal=$((selected_terminal-1))
	 	cat /home/$(whoami)/.config/i3/config | sed 's/konsole/${terms[$(selected_terminal)]}/g'
	 	# sed -i /home/$(whoami)/.config/i3/config 's/konsole/${terms[$(selected_terminal)]}/g'
		echo "terminal set to ${terms[$(selected_terminal)]}"
		unset a selected_terminal terms
	fi

	# set wireless iface
	wifi_iface=("$(nmcli device | grep -i "wifi" | grep -iv "p2p" | awk '{ print $1 }')")
	if [[ ${#wifi_iface[@]} -eq 1 ]]
	then
		cat /home/$(whoami)/.config/polybar/config | sed '270s/interface = /interface = ${wifi_iface[0]}/g'
		echo "Wi-Fi card set to ${wifi_iface[0]}"
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
	 	cat /home/$(whoami)/.config/polybar/config | sed '270s/interface = /interface = ${wifi_iface[$selected_iface]}/g'
		echo "Wi-Fi card set to ${wifi_iface[$selected_iface]}"
		unset a selected_iface wifi_iface
	fi
	
	# loop to select 
	ether_iface=("$(nmcli device | grep -i "ethernet" | grep -iv "p2p" | awk '{ print $1 }')")
	if [[ ${#ether_iface[@]} -eq 1 ]]
	then
		cat /home/$(whoami)/.config/polybar/config | sed '282s/interface = /interface = ${ether_iface[0]}/g'
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
		cat /home/$(whoami)/.config/polybar/config | sed '282s/interface = /interface = ${ether_iface[$selected_iface]}/g'
		echo "Ethernet card set to ${ether_iface[$selected_iface]}"
		unset a selected_iface ether_iface
	fi
	
	cat /home/$(whoami)/.config/i3/config | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
	cat /home/$(whoami)/.config/polybar/launch.sh | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
	cat /home/$(whoami)/.config/polybar/config | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
	cat /home/$(whoami)/.config/dunst/dunstrc | awk '{ sub("home/blank","home/$(whoami)"); print $0 }'
	
	# sed -i /home/$(whoami)/.config/i3/config 's/"home\/blank","home\/$(whoami)")/g'
	# sed -i /home/$(whoami)/.config/polybar/launch.sh 's/"home\/blank","home\/$(whoami)"/g'
	# sed -i /home/$(whoami)/.config/polybar/config 's/"home\/blank","home\/$(whoami)"/g'
	# sed -i /home/$(whoami)/.config/dunst/dunstrc 's/"home\/blank","home\/$(whoami)"/g'
	
	echo "cp -rfv polybar i3 rofi -t \"/home/$(whoami)/.config\""
fi

