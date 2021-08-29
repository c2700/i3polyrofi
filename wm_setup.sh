#!/bin/bash

set_background(){
	
}

script_dir="$PWD"
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
	echo "folders dunst i3 polybar and rofi to be copied to /home/$(whoami)/.config folder"
	read -p "press any key to continue." -n1
	cp -rfv dunst i3 polybar rofi -t "/home/$(whoami)/.config"
	echo "Need to install bs4 (python module), fontTools (python module), icons-in-terminal, NerdFonts, dunst rofi, rofi-calc and rofi-file-browser-extended-git"
	echo "Installing dunst, rofi, rofi-calc"
	sudo pacman -Syvd --noconfirm dunst rofi rofi-calc
	echo "Downloading rofi-file-browser-extended"
	git clone https://github.com/marvinkreis/rofi-file-browser-extended
	echo "Installing rofi-file-browser-extended"
	read -p "press any key to continue." -n1
	cd rofi-file-browser-extended
	makepkg -i
	# makepkg -sdi
	makepkg -sd
	sudo pacman -Uvd --noconfirm *rofi*file*browser*.pkg.tar.*
	cd ..
	rm -rfv rofi-file-browser-extended
	echo "Downloading icons-in-terminal"
	git clone https://github.com/sebastiencs/icons-in-terminal
	echo "Installing icons-in-terminal"
	cd icons-in-terminal
	chmod a+x *.sh
	./install.sh
	cd ..

	echo "Downloading bs4 and fontTools"
	wget -cdv $(curl https://pypi.org/project/bs4/#files | grep -i pythonhosted | sed 's/\s*<a href="//g;s/">//g')
	wget -cdv $(curl https://pypi.org/project/fonttools/#files | grep -i pythonhosted | sed 's/\s*<a href="//g;s/">//g')
	echo "Installing bs4 and fontTools"
	pip install "$(ls bs4-*)"
	pip install "$(ls fontTools-*)"
	echo "The file containing the links to the Nerd Fonts zip files is in $(PWD)/NerdFonts/nerd_fonts_v2.1.0.txt"
	read -p "press any key to continue." -n1
	python3 extract_nerdfonts.py
	cd NerdFonts
	echo "Downloading NerdFonts"
	wget -cdvi nerd_fonts_v2.1.0.txt
	echo "Installing NerdFonts"
	# extract and copy nerdfonts files to relevant directories
	echo "You will find the nerd fonts zip files are in $script_dir/NerdFonts"
	read -p "press any key to continue." -n1
	nerdfonts_files=($(ls *.zip | sed 's/.zip//g'))
	for u in ${nerdfonts_files[@]}
	do
		unzip "${u}.zip" -d "/usr/share/fonts/$i"
	done
	cd ..
	read -p "keep the nerdfonts zip files? [y/n]: " -n1 keep_nf_files
	case $? in
		'y'|'Y') echo "You will find the nerd fonts zip files are in $script_dir/NerdFonts" ;;
		'n'|'N') rm -rfv NerdFonts
	esac

	terms=($(pqqs "terminal emulator" | grep -iv "lib"))
	if [[ ${#terms[@]} -eq 0 ]]
	then
		echo "no terminal emulators found. Installing vte3"
		sudo pacman -Syvd --noconfirm vte3
		VTE3="$(pacman -Ql vte3 | grep -iv "bin/$" | grep -i "bin" | awk '{ print $2 }')"
		sed -i /home/$(whoami)/.config/i3/config 's/konsole/'$VTE3'/g'
	elif [[ ${#terms[@]} -eq 1 ]]
	then
		sed -i /home/$(whoami)/.config/i3/config 's/konsole/'${terms[0]}'/g'
		echo "terminal set to ${terms[0]}"
	elif [[ ${#terms[@]} -gt 1 ]]
	then
		a=1
		for i in ${terms[@]}
		do
			echo " $a) $i"
			a=$((a+1))
		done
		unset a 
		echo ""
		read -p "select terminal emulator to use: " selected_terminal
		selected_terminal=$((selected_terminal-1))
	 	sed -i /home/$(whoami)/.config/i3/config 's/konsole/'${terms[$(selected_terminal)]}'/g'
		echo "terminal set to ${terms[$(selected_terminal)]}"
		unset a selected_terminal terms
	fi

	# set wireless iface
	wifi_iface=("$(nmcli device | grep -i "wifi" | grep -iv "p2p" | awk '{ print $1 }')")
	if [[ ${#wifi_iface[@]} -eq 1 ]]
	then
		sed -i /home/$(whoami)/.config/polybar/config '270s/interface = /interface = '${wifi_iface[0]}'/g'
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
		unset a 
		echo ""
		read -p "select wireless interface: " selected_iface
		selected_iface=$((selected_iface-1))
	 	sed -i /home/$(whoami)/.config/polybar/config '270s/interface = /interface = '${wifi_iface[$selected_iface]}'/g'
		echo "Wi-Fi card set to ${wifi_iface[$selected_iface]}"
		unset a selected_iface wifi_iface
	fi
	
	# loop to select 
	ether_iface=("$(nmcli device | grep -i "ethernet" | grep -iv "p2p" | awk '{ print $1 }')")
	if [[ ${#ether_iface[@]} -eq 1 ]]
	then
		sed -i /home/$(whoami)/.config/polybar/config '282s/interface = /interface = '${ether_iface[0]}'/g'
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
		unset a
		echo ""
		read -p "select ethernet interface: " selected_iface
		selected_iface=$((selected_iface-1))
		sed /home/$(whoami)/.config/polybar/config '282s/interface = /interface = '${ether_iface[$selected_iface]}'/g'
		echo "Ethernet card set to ${ether_iface[$selected_iface]}"
		unset selected_iface ether_iface
	fi
	
	sed -i /home/$(whoami)/.config/i3/config 's/home\/blank/home\/'$(whoami)'/g'
	sed -i /home/$(whoami)/.config/polybar/launch.sh 's/home\/blank/home\/'$(whoami)'/g'
	sed -i /home/$(whoami)/.config/polybar/config 's/home\/blank/home\/'$(whoami)'/g'
	sed -i /home/$(whoami)/.config/dunst/dunstrc 's/home\/blank/home\/'$(whoami)'/g'
	echo -e "install terminal file managers:\n  1)ranger\n  2) nnn\n 3) mc\n 4) fff\n 5) vifm\n"
	read -p "choose option: " -n1 fm_opt
	
	case $fm_opt in
		1) sudo pacman -Syvd --noconfirm ranger ;;
		2) sudo pacman -Syvd --noconfirm nnn ;;
		3) sudo pacman -Syvd --noconfirm mc ;;
		4) sudo pacman -Syvd --noconfirm fff ;;
		5) sudo pacman -Syvd --noconfirm vifm ;;
	esac
	read -n1 -p "set a wallpaper (your background will be black by default. you can still your app.s) [y/n]: " choice
	case $? choice
		'n'|'N') echo "Background is set to default (black color)" ;;
		'y'|'Y')
			read -p "file path to picture of use as background: " bkgrnd_file
			[[ ! -e "$bkgrnd_file" ]] && echo "invalid file path"
			if [[ -e "$bkgrnd_file" ]]
			then
				sed -i "/home/$(whoami)/.config/i3/config" '202s/--bg-fill /--bg-fill '$bkgrnd_file'/g'
				echo "$bkgrnd_file set as background"
				;;
			fi
	esac
fi

read -n1 -p "save installed glyphs with it's names in a text_file? [y/n]: " choice_g

case $choice_g in
	"y"|"Y")
		echo "saving glyph hex code in glyphs_code.txt"
		icons-in-terminal | grep -iv 'glyphs\|total' | tr [A-Z] [a-z] | sed 's/  /\n/g' > glyphs_code.txt
		echo "saving glyph with it's info in glyphs_info.txt"
		python3 hex_to_glyph.py > glyphs_info.txt
		echo "saved glyph with it's info in glyphs_info.txt"
		echo "removing glyphs_code.txt file"
		rm -rfv glyphs_code.txt
		echo "removed glyphs_code.txt file"
		;;
esac

