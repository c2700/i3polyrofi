My personal i3, polybar and rofi dotfiles and with shell scripts for dunst notifications

You're going to need to install nerfonts.
If you ever feel like you can't find the fonts you are looking just head over to https://glyphsearch.com/?copy=unicode (Not my site. It's where I got some of the fonts for my rice. The option in the "copy" section selected needs to be "unicode" in order for you to copy the icon/font/glyph exactly the way it is to the terminal)<br>

<h2>idotfiles setup</h2><br>
chmod a+x wm_setup.sh<br>
./wm_setup.sh<br>

wifi module:
	left click - opens dunst notification get pvt ipv4, ipv6 addresses, ssid connected to and checks for 
				 WAN connectivity (internet).
	right click - disconnects wifi

ethernet module:
	left click - same as wifi module's left click

calendar:
	left click - opens calendar in dunst notification

disk module:
	left click - shows all disks and partitions and their mountpoints in brackets (if mounted) next to the
				 partition

init script - one time run on startup and exit on execution. shows, batteyr, wifi and ethernet stats

arch logo - left click to spawn rofi

shortcuts:
	super+r - resize windows
	super+f (or) <F11> - full screen window
	super+shift+space - toggle floating window mode
	super+shift+arrow_key - move floating window in set direction
	super+shift+e - exit i3 without prompt (comment line 155, uncomment line 154 if you need the exit
											prompt)
	ctrl+shift+delete - shutdown machine (i3 keybinding)
	ctrl+alt+delete - reboot machine (i3 keybinding)
	super+shift+o - turns on all screens (script is i3/scripts/screens/turn_on_all_screens.sh)
	super+shift+b - turns off all screens (script is i3/scripts/screens/turn_off_all_screens.sh)
	super+shift+a - turns off only primary screen (script is i3/scripts/screens/turn_off_main_screen.sh)
	super+shift+q - quits focused app
	super+arrow_keys - change window focus
	ctrl+alt+f - open rofi in file explorer mode
	super+enter - open terminal emulator
	super+shift+r - restart i3
	ctrl+shift+esc - starts htop in set terminal emulator

	
