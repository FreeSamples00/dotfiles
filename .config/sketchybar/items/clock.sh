#! /bin/bash

SIDE="$1"
NAME="clock.$SIDE"

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        update_freq=10 \
        icon=  \
        script="$PLUGIN_DIR/clock.sh" \
