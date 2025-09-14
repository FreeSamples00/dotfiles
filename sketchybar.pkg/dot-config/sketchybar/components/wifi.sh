#!/bin/sh

SIDE="$1"
NAME="wifi.$SIDE"
REFRESH_INTERVAL=15 # in seconds

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        icon="w" \
        icon.highlight_color="$RED" \
        update_freq="$REFRESH_INTERVAL" \
        script="$SCRIPT_DIR/wifi.sh" \
        click_script="open 'x-apple.systempreferences:com.apple.preference.network'" \
