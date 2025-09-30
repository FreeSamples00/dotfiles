#!/bin/bash
# script

FOCUS=$(shortcuts run "Focus_Helper")

case "$FOCUS" in
  None)
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left=0 \
                      padding_right=0 \
                      icon.padding_left=0 \
                      icon.padding_right=0 \
                      label.padding_left=0 \
                      label.padding_right=0
    ;;
  "Do Not Disturb")
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
    ;;
  "Sleep")
    sketchybar --set "$NAME" \
                      icon="" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
    ;;
  "Reduce Interruptions")
    sketchybar --set "$NAME" \
                      icon="󱏬" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
    ;;
  *)
    sketchybar --set "$NAME" \
                      icon="--" \
                      padding_left="12" \
                      padding_right="12" \
                      icon.padding_left="$ICON_PADDING" \
                      icon.padding_right="$ICON_PADDING" \
                      label.padding_left="$ICON_PADDING" \
                      label.padding_right="$ICON_PADDING"
    ;;
esac
