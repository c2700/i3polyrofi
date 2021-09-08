#!/bin/bash

clr_reset=$(tput -T$TERM sgr0)
fg_blue=$(tput -T$TERM setaf 122)

prepend_zero () {
    seq -f "%02g" $1 $1
}

artist=$(echo -n $(cmus-remote -C status | grep artist -m 1| cut -c 12-))
song=$(echo $(cmus-remote -C status | grep file | awk '{$1="";gsub("\\w*/","");gsub("OST'\''","");print}' | sed 's/^\s*//g' | sed 's/\.mp3//g'))
state_text="$(echo cmus-remote -C status | grep -i status | awk '{ print $2 }' )"
state_icon=""
position=$(cmus-remote -C status | grep position | cut -c 10-)
minutes1=$(prepend_zero $((position / 60)))
seconds1=$(prepend_zero $((position % 60)))

duration=$(cmus-remote -C status | grep duration | cut -c 10-)
minutes2=$(prepend_zero $((duration/60)))
seconds2=$(prepend_zero $((duration%60)))

echo -en " $song [$minutes1:$seconds1 / $minutes2:$seconds2]  "


# state_icon=""
# [[ $state_text == "playing" ]] && state_icon=""
# [[ $state_text == "paused" ]] && state_icon=""
# [[ $state_text == "stopped" ]] && state_icon=""

# echo -ne "  $state_icon $song [$minutes1:$seconds1 / $minutes2:$seconds2]  "

