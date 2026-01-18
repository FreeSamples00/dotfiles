#!/usr/bin/env bash

sketchybar --add item front_app.icon left \
  --set front_app.icon \
  icon="" \
  icon.font="$SBAR_APP_ICON_FONT:Regular:$SBAR_APP_ICON_FONT_SIZE" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"

sketchybar --add item front_app.name left \
  --set front_app.name \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  script="$SBAR_PLUGIN_DIR/front_app.sh" \
  --subscribe front_app.name front_app_switched
