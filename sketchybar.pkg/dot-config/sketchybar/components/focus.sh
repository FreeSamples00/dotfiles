#!/bin/bash

SIDE="$1"
NAME="focus.$SIDE"

sketchybar \
  --add item "$NAME" "$SIDE" \
  --set "$NAME" \
        update_freq=10 \
        icon="" \
        padding_left=0 \
        padding_right=0 \
        icon.padding_left=0 \
        icon.padding_right=0 \
        label.padding_left=0 \
        label.padding_right=0 \
        script="$SCRIPT_DIR/focus.sh"
