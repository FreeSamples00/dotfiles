#!/bin/bash

# Component

SIDE="$1"
NAME="battery.$SIDE"
REFRESH_INTERVAL=120

POPUP_NAME="battery.remaining"
POPUP_REFRESH_INTERVAL=20

sketchybar  \
  --add item "$NAME" "$SIDE" \
  --subscribe "$NAME" system_woke power_source_change \
  --set "$NAME" \
        update_freq="$REFRESH_INTERVAL" \
        script="$SCRIPT_DIR/battery.sh" \
        click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
        popup.align=center \

sketchybar \
  --add item "$POPUP_NAME" "popup.$NAME" \
  --set "$POPUP_NAME" \
        label="--:--" \
        icon="" \
        topmost=on \
        update_freq=$POPUP_REFRESH_INTERVAL \
        script="$SCRIPT_DIR/battery_remaining.sh" \
        click_script="$SCRIPT_DIR/battery_remaining.sh"
