My 1st i3, polybar, dunst and rofi rice with shell scripts for dunst notifications

You're going to need to install nerdfonts.
If you ever feel like you can't find the fonts you are looking just head over to https://glyphsearch.com/?copy=unicode (Not my site. It's where I got some of the fonts for my rice. The option in the "copy" section selected needs to be "unicode" in order for you to copy the icon/font/glyph exactly the way it is to the terminal)<br><br>

I'm also using curl in this script to download bs4 and fontTools as pip tells me this. "ERROR: XMLRPC request failed [code: -32500]<br>RuntimeError: PyPI's XMLRPC API is currently disabled due to unmanageable load and will be deprecated in the near future. See https://status.python.org/ for more information." (copy pasted the Error msg).<br>pip is used to install bs4 and fontTools though.

<h2>dotfiles setup</h2><br>
the wm_setup.sh script is to copy the config files to certain diretories and change the values on your machine. you might need to restart your machine to see all changes take effect.
sudo chmod a+x wm_setup.sh<br>
./wm_setup.sh<br><br>

- <h4>wifi module:</h4>
	1. left click - opens dunst notification get pvt ipv4, ipv6 addresses, ssid connected to and checks for WAN connectivity (internet).<br>
	2. right click - disconnects wifi<br><br>

- <h4>ethernet module:</h4>
	1. left click - same as wifi module's left click<br><br>

- <h4>calendar:</h4>
	1. left click - opens calendar in dunst notification<br><br>

- <h4>disk module:</h4>
	1. left click - shows all disks and partitions and their mountpoints in brackets (if mounted) next to the partition<br>
	2. right click - shows all available disks (no partitions or their info).<br><br>

- init script - executes on i3 startup (not a daemon). shows, battery, wifi and ethernet stats via dunst<br><br>

- arch logo - left click to spawn rofi<br><br>

- <h4>i3 shortcuts:</h4>
	1. super+r - resize windows<br>
	2. super+f (or) <F11> - full screen window<br>
	3. super+shift+space - toggle floating window mode<br>
	4. super+shift+arrow_key - move floating window in set direction<br>
	5. super+shift+e - exit i3 without prompt (comment line 155, uncomment line 154 if you need the exit prompt)<br>
	6. ctrl+shift+delete - shutdown machine without prompt (i3 keybinding)<br>
	7. ctrl+alt+delete - reboot machine without prompt (i3 keybinding)<br>
	8. super+shift+o - turns on all screens (script is i3/scripts/screens/turn_on_all_screens.sh)<br>
	9. super+shift+b - turns off all screens (script is i3/scripts/screens/turn_off_all_screens.sh)<br>
	10. super+shift+a - turns off only primary screen (script is i3/scripts/screens/turn_off_main_screen.sh)<br>
	11. super+shift+q - quits focused window/app<br>
	12. super+arrow_keys - change focus to another window/app<br>
	13. ctrl+alt+f - open rofi in file explorer mode<br>
	14. super+enter - open terminal emulator<br>
	15. super+shift+r - restart i3 (you might need to kill your display manager and login to i3 or restart your machine to restart all "on i3 startup scritps/services" in case what you need to restart doesn't restart with i3)<br>
	16. ctrl+shift+esc - starts htop in set terminal emulator<br>
	
