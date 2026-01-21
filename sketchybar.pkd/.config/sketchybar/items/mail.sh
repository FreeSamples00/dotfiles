#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/icon.sh"
source "$CONFIG_DIR/core/env.sh"

SIDE="${1:-right}"
MAIL_ICON=$(get_widget_icon "mail")

sketchybar --add item mail.label "$SIDE" \
  --set mail.label \
  click_script="open -a mail" \
  update_freq="120" \
  label="--" \
  script="$SBAR_PLUGIN_DIR/mail.sh" \
  label.padding_right="$SBAR_ITEM_LABEL_PADDING_RIGHT"

sketchybar --add item mail.icon "$SIDE" \
  --set mail.icon \
  icon="$MAIL_ICON" \
  click_script="open -a mail" \
  icon.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  icon.padding_right="$SBAR_ITEM_ICON_PADDING_RIGHT"
