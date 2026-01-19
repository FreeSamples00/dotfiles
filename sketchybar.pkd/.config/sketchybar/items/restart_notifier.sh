#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/plugins/helpers.sh"

RESTART_ICON=$(get_widget_icon "restart")

SIDE="${1:-left}"

sketchybar --add item restart_notifier.icon "$SIDE" \
  --set restart_notifier.icon \
  icon="$RESTART_ICON" \
  icon.font="$SBAR_ICON_FONT_FAMILY:Bold:$(calc "$SBAR_ICON_FONT_SIZE + 3")" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$(calc "$SBAR_ITEM_LABEL_PADDING_RIGHT - 2")" \
  script="$SBAR_PLUGIN_DIR/restart_notifier.sh" \
  click_script="$SBAR_PLUGIN_DIR/restart_notifier.sh -R" \
  update_freq=3600
