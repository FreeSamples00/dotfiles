#!/bin/bash
# component

SIDE="$1"
NAME="restart_notifier.$SIDE"
REFRESH_INTERVAL=3600

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        icon="" \
        click_script="$SCRIPT_DIR/restart_notifier.sh -R" \
        script="$SCRIPT_DIR/restart_notifier.sh" \
        update_freq="$REFRESH_INTERVAL" \
        icon.color="$RED" \
        icon.padding_right=0 \
        icon.padding_left=0 \
        label.padding_right=0 \
        label.padding_left=0 \
        padding_right=0 \
        padding_left=0 \
        label.drawing=off
