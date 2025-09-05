#!/bin/sh

# time formatting seems to follow C rules: https://man7.org/linux/man-pages/man3/strftime.3.html
sketchybar --set "$NAME" label="$(date '+%b%e %l:%M')"
