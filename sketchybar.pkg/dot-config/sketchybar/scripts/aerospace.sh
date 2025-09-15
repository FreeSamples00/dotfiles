#!/bin/bash

source "$CONFIG_DIR/aesthetics.sh"

if [ "$1" == "$FOCUSED_WORKSPACE" ]; then
    sketchybar \
      --set "$NAME" label.color="$WORKSPACE_FOCUSED_COLOR"
else

  if [ "$(aerospace list-windows --workspace "$1")" == "" ]; then
    sketchybar \
      --set "$NAME" label.color="$WORKSPACE_EMPTY_COLOR"
  else
    sketchybar \
      --set "$NAME" label.color="$WORKSPACE_DEFAULT_COLOR"
  fi

fi

