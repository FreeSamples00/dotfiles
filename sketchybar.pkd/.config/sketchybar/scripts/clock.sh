#!/bin/bash
# script

# use - in format specifiers to remove padding
sketchybar --set "$NAME" label="$(gdate '+%b %-e %-l:%M %P')"
