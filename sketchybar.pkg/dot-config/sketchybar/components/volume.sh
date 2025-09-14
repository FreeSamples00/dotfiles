#!/bin/sh

SIDE="$1"
NAME="volume.$SIDE"

sketchybar \
  --add item "$NAME" "$SIDE" \
  --subscribe "$NAME" volume_change \
  --set "$NAME" \
        script="$SCRIPT_DIR/volume.sh" \
        click_script="$SCRIPT_DIR/mute.sh"
