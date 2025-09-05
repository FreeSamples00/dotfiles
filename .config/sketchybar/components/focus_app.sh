#! /bin/bash


SIDE="$1"
NAME="focus_app.$SIDE"

sketchybar --add item "$NAME" "$SIDE" \
           --subscribe "$NAME" front_app_switched \
           --set "$NAME" \
                 icon.drawing=off \
                 script="$SCRIPT_DIR/focus_app.sh" \
