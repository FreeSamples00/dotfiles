#!/usr/bin/env bash

sketchybar \
  --default \
  icon.font="$SBAR_ICON_FONT_FAMILY:$SBAR_ICON_FONT_STYLE:$SBAR_ICON_FONT_SIZE" \
  label.font="$SBAR_LABEL_FONT_FAMILY:$SBAR_LABEL_FONT_STYLE:$SBAR_LABEL_FONT_SIZE" \
  icon.color="$SBAR_DEFAULT_ICON_COLOR" \
  label.color="$SBAR_DEFAULT_LABEL_COLOR" \
  --bar \
  position="$SBAR_BAR_POSITION" \
  height="$SBAR_BAR_HEIGHT" \
  y_offset="$SBAR_BAR_Y_OFFSET" \
  color="transparent"
