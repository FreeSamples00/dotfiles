#!/bin/bash
# script

source "$CONFIG_DIR/aesthetics.sh"

NUM_OUTDATED=$(brew outdated | wc -l | xargs)
ICON_SYMBOL=""

SHOW_BOUND=5
WHITE_BOUND=10
ORANGE_BOUND=20

HIDE="True"
COLOR=""

if (( NUM_OUTDATED < SHOW_BOUND )); then
  HIDE="True"
  COLOR=""
elif (( NUM_OUTDATED <= WHITE_BOUND )); then
  HIDE="False"
  COLOR=$WHITE
elif (( NUM_OUTDATED <= ORANGE_BOUND )); then
  HIDE="False"
  COLOR=$ORANGE
else
  HIDE="False"
  COLOR=$RED
fi

if [[ "$HIDE" == "True" ]]; then
  sketchybar \
    --set "$NAME" \
        label="" \
        icon="" \
        padding_left=0 \
        padding_right=0 \
        icon.padding_left=0 \
        icon.padding_right=0 \
        label.padding_left=0 \
        label.padding_right=0
else
  sketchybar \
    --set "$NAME" \
        icon.color="$COLOR" \
        label="$NUM_OUTDATED" \
        icon="$ICON_SYMBOL" \
        padding_left="$PADDING" \
        padding_right="$PADDING" \
        icon.padding_left="$ICON_PADDING" \
        icon.padding_right="$ICON_PADDING" \
        label.padding_left="$ICON_PADDING" \
        label.padding_right="$ICON_PADDING"
fi

