#!/bin/bash

mons=($(xrandr --query | grep -i " connected" | awk '{ print $1 }'))

for i in "${mons[@]}"
do
	xrandr --output $i --off
done

