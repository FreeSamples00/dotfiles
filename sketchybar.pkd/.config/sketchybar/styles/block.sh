#!/usr/bin/env bash

if [ "$SBAR_CONFIG_VISIBLE" = "true" ]; then
  sketchybar --add bracket "config" "/config/" \
    --set "config" \
    background.color="$SBAR_BLOCK_BG_COLOR" \
    background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
    background.height="$SBAR_ITEM_BG_HEIGHT" \
    background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
    background.drawing=on

  sketchybar --set "/config/" icon.color="$SBAR_COLOR_CONFIG"
fi

sketchybar --add bracket "clock" "/clock\..*/" \
  --set "clock" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/clock\..*/" icon.color="$SBAR_COLOR_CLOCK" label.color="$SBAR_COLOR_CLOCK"

sketchybar --add bracket "calendar" "/calendar\..*/" \
  --set "calendar" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/calendar\..*/" icon.color="$SBAR_COLOR_CALENDAR" label.color="$SBAR_COLOR_CALENDAR"

sketchybar --add bracket "weather" "/weather\..*/" \
  --set "weather" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/weather\..*/" icon.color="$SBAR_COLOR_WEATHER" label.color="$SBAR_COLOR_WEATHER"

sketchybar --add bracket "caffeinate" "/caffeinate\..*/" \
  --set "caffeinate" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/caffeinate\..*/" icon.color="$SBAR_COLOR_CAFFEINATE"

sketchybar --add bracket "volume" "/volume\..*/" \
  --set "volume" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/volume\..*/" icon.color="$SBAR_COLOR_VOLUME" label.color="$SBAR_COLOR_VOLUME"

sketchybar --add bracket "bluetooth" "/bluetooth\..*/" \
  --set "bluetooth" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/bluetooth\..*/" icon.color="$SBAR_COLOR_BLUETOOTH" label.color="$SBAR_COLOR_BLUETOOTH"

sketchybar --add bracket "battery" "/battery\..*/" \
  --set "battery" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/battery\..*/" icon.color="$SBAR_COLOR_BATTERY" label.color="$SBAR_COLOR_BATTERY"

sketchybar --add bracket "disk" "/disk\..*/" \
  --set "disk" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/disk\..*/" icon.color="$SBAR_COLOR_DISK" label.color="$SBAR_COLOR_DISK"

sketchybar --add bracket "ram" "/ram\..*/" \
  --set "ram" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/ram\..*/" icon.color="$SBAR_COLOR_RAM" label.color="$SBAR_COLOR_RAM"

sketchybar --add bracket "cpu" "/cpu\..*/" \
  --set "cpu" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/cpu\..*/" icon.color="$SBAR_COLOR_CPU" label.color="$SBAR_COLOR_CPU"

sketchybar --add bracket "netstat" "/netstat\..*/" \
  --set "netstat" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/netstat\..*/" icon.color="$SBAR_COLOR_NETSTAT" label.color="$SBAR_COLOR_NETSTAT"

sketchybar --add bracket "kakaotalk" "/kakaotalk\.icon/" \
  --set "kakaotalk" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/kakaotalk\.icon/" icon.color="$SBAR_COLOR_KAKAOTALK"

source "$CONFIG_DIR/tokens/helpers.sh"
BADGE_COLOR=$(get_badge_label_color)
sketchybar --set kakaotalk.badge label.color="$BADGE_COLOR"

sketchybar --add bracket "front_app" "/front_app\..*/" \
  --set "front_app" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/front_app\..*/" icon.color="$SBAR_COLOR_FRONT_APP" label.color="$SBAR_COLOR_FRONT_APP"

sketchybar --add bracket "aerospace" "/workspace_.*/" \
  --set "aerospace" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on \
  background.padding_left="$SBAR_ITEM_ICON_PADDING_LEFT" \
  background.padding_right="16"

sketchybar --set "/workspace_.*/" label.color="$SBAR_COLOR_AEROSPACE"

sketchybar --add bracket "restart_notifier" "/restart_notifier\..*/" \
  --set "restart_notifier" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/restart_notifier\..*/" icon.color="$SBAR_COLOR_RESTART" label.color="$SBAR_COLOR_RESTART"
