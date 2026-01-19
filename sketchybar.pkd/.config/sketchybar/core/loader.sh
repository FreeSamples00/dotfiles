#!/usr/bin/env bash

SPACER_INDEX=1
CURRENT_SIDE=""

load_widgets() {
  CURRENT_SIDE="$1"
  shift
  local widget_array=("$@")

  if [ "$SBAR_AUTO_INSERT_SPACER" = true ]; then
    for i in "${!widget_array[@]}"; do
      item="${widget_array[$i]}"
      widget_name="${item%% *}"
      source "$SBAR_ITEM_DIR/${widget_name}.sh" "$CURRENT_SIDE"

      if [ $((i + 1)) -lt ${#widget_array[@]} ]; then
        source "$SBAR_ITEM_DIR/spacer.sh" "$CURRENT_SIDE" "$SPACER_INDEX"
        ((SPACER_INDEX++))
      fi
    done
  else
    for item in "${widget_array[@]}"; do
      widget_name="${item%% *}"
      source "$SBAR_ITEM_DIR/${widget_name}.sh" "$CURRENT_SIDE"
    done
  fi
}
