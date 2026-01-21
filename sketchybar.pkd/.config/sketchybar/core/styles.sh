#!/usr/bin/env bash

# Widget bracket configurations for block style
# Each widget gets a themed background with corresponding icon/label colors

sketchybar --add bracket "clock" "/clock\..*/" \
  --set "clock" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/clock\..*/" icon.color="$SBAR_COLOR_CLOCK" label.color="$SBAR_COLOR_CLOCK"

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

sketchybar --add bracket "battery" "/battery\..*/" \
  --set "battery" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/battery\..*/" icon.color="$SBAR_COLOR_BATTERY" label.color="$SBAR_COLOR_BATTERY"

sketchybar --add bracket "front_app" "/front_app\..*/" \
  --set "front_app" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/front_app\..*/" icon.color="$SBAR_COLOR_FRONT_APP" label.color="$SBAR_COLOR_FRONT_APP"

sketchybar --add bracket "aerospace" "/workspace_.*/" \
  "${ANIMATION[@]}" --set "aerospace" \
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


sketchybar --add bracket "apple" "/apple\..*/" \
  --set "apple" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/apple\..*/" icon.color="$SBAR_COLOR_APPLE" label.color="$SBAR_COLOR_APPLE"


sketchybar --add bracket "mail" "/mail\..*/" \
  --set "mail" \
  background.color="$SBAR_BLOCK_BG_COLOR" \
  background.corner_radius="$SBAR_ITEM_BG_CORNER_RADIUS" \
  background.height="$SBAR_ITEM_BG_HEIGHT" \
  background.border_width="$SBAR_ITEM_BG_BORDER_WIDTH" \
  background.drawing=on

sketchybar --set "/mail\..*/" icon.color="$SBAR_COLOR_MAIL" label.color="$SBAR_COLOR_MAIL"
