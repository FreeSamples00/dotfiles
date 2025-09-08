#!/bin/sh

SIDE="$1"
NAME="dexcom.$SIDE"

ICON=""
REFRESH_INTERVAL=150

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        icon="$ICON" \
        label="--" \
        script="$SCRIPT_DIR/dexcom.sh" \
        click_script="$SCRIPT_DIR/dexcom.sh" \
        update_freq="$REFRESH_INTERVAL" \
        icon.highlight_color="$RED" \
        icon.padding_left=0 \
        icon.padding_right=0 \
