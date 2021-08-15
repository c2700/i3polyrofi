#!/bin/bash

mons=$(xrandr --query | grep -iv "primary" | grep -i " connected" | cut -d" " -f1)
prim_mon=$(xrandr --query | grep -i "primary"| grep -i " connected" | cut -d" " -f1)

for i in $mons $prim_mon
do
	xrandr --output $i --auto
done

xrandr --output $mons --left-of $prim_mon
