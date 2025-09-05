#! /bin/bash

SIDE="$1"
NAME="battery.$SIDE"

sketchybar  \
  --add item "$NAME" "$SIDE" \
  --subscribe "$NAME" system_woke power_source_change \
  --set "$NAME" \
        update_freq=120 \
        script="$PLUGIN_DIR/battery.sh" \
