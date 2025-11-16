#!/bin/bash
# script

if pgrep -i caffeinate >/dev/null; then
  ICON="󰅶"
else
  ICON="󰛊"
fi

sketchybar \
  --set "$NAME" \
        icon="$ICON"
