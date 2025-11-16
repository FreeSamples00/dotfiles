#!/bin/bash
# component

SIDE="$1"
NAME="caffeinate.$SIDE"
REFRESH_INTERVAL=10

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        icon="󰾪" \
        click_script="$SCRIPT_DIR/caffeinate_toggle.sh" \
        script="$SCRIPT_DIR/caffeinate.sh" \
        update_freq="$REFRESH_INTERVAL" \
        label.drawing=off
