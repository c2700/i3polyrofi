#!/bin/bash

primary_screen=$(xrandr --query | grep -i " primary" | cut -d" " -f1)
xrandr --output $primary_screen --off
