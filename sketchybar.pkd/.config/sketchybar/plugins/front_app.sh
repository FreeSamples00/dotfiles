#!/usr/bin/env bash

source "$CONFIG_DIR/user.sketchybarrc"

# Sketchybar environment variables
: "${INFO:=}"

source "$CONFIG_DIR/tokens/colors.sh"
source "$CONFIG_DIR/plugins/icon.sh"

if [ -n "$INFO" ]; then
  APP_NAME="$INFO"
  ICON=$(get_app_icon "$APP_NAME")

  sketchybar "${ANIMATION[@]}" --set front_app.icon icon="$ICON"
  sketchybar "${ANIMATION[@]}" --set front_app.name label="$APP_NAME"
fi
