#! /bin/bash

SIDE="$1"
NAME="volume.$SIDE"

sketchybar  \
  --add item "$NAME" "$SIDE" \
  --subscribe "$NAME" volume_change \
  --set "$NAME" \
        script="$PLUGIN_DIR/volume.sh" \
