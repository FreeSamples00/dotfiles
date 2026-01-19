#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/plugins/helpers.sh"

LOADING_ICON=$(get_widget_icon "loading")

SIDE="${1:-right}"

sketchybar --add item weather.label "$SIDE" \
  --set weather.label \
  label="$LOADING_ICON" \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT" \
  update_freq=600 \
  updates=on \
  script="SBAR_WEATHER_LOCATION=$SBAR_WEATHER_LOCATION $SBAR_PLUGIN_DIR/weather.sh" \
  click_script="open -a Weather"

sketchybar --add item weather.icon "$SIDE" \
  --set weather.icon \
  icon="" \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$(calc "$SBAR_ICON_FONT_SIZE + 12.5")" \
  icon.padding_left="$(calc "$SBAR_ITEM_ICON_PADDING_LEFT - 4.0")" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"
