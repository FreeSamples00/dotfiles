#! /bin/bash

SIDE="$1"
NAME="clock.$SIDE"

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        update_freq=10 \
        icon=󰸗  \
        script="$SCRIPT_DIR/clock.sh" \
        click_script="open -a calendar"
