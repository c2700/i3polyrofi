eject /dev/cdrom
case $? in
	1) notify-send " could not eject cd tray " ;;
esac
