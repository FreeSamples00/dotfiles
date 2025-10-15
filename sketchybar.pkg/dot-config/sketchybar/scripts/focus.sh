#!/bin/bash
# script

FOCUS=$("$CONFIG_DIR/scripts/getfocus" 2>&1)

if [[ "$FOCUS" == "None" ]]; then
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left=0 \
                      padding_right=0 \
                      icon.padding_left=0 \
                      icon.padding_right=0 \
                      label.padding_left=0 \
                      label.padding_right=0

elif [[ "$FOCUS" == "Do Not Disturb" ]]; then
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"

elif [[ "$FOCUS" == "Sleep" ]]; then
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"

elif [[ "$FOCUS" == "Reduce Interruptions" ]]; then
    sketchybar --set "$NAME" \
                      icon="󱏬" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
else 
  sketchybar --set "$NAME" \
                      icon="?" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
fi
