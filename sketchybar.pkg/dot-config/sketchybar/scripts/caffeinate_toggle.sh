#!/bin/bash
# script

if pgrep "caffeinate" >/dev/null; then
  pgrep -i "caffeinate" | xargs kill
  ICON="󰛊"
else
  caffeinate -id &
  ICON="󰅶"
fi

sketchybar \
  --set "$NAME" \
        icon="$ICON"
