#!/bin/sh
# Script

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
IS_CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[7-9]|100)
    ICON="󰁹"
    ;;
  9[0-6])
    ICON="󰂂"
    ;;
  8[0-9])
    ICON="󰂁"
    ;;
  7[0-9])
    ICON="󰂀"
    ;;
  6[0-9])
    ICON="󰁿"
    ;;
  5[0-9])
    ICON="󰁾"
    ;;
  4[0-9])
    ICON="󰁽"
    ;;
  3[0-9])
    ICON="󰁼"
    ;;
  2[0-9])
    ICON="󰁻"
    ;;
  1[0-9])
    ICON="󰁺"
    ;;
  *)
    ICON="󰂎"
    ;;
esac

if [ "$IS_CHARGING" != "" ]; then
  ICON="󰂄"
fi

# case "${PERCENTAGE}" in
#   9[0-9]|100)
#     ICON=""
#   ;;
#   [6-8][0-9])
#     ICON=""
#   ;;
#   [3-5][0-9])
#     ICON=""
#   ;;
#   [1-2][0-9])
#     ICON=""
#   ;;
#   *)
#     ICON=""
#   ;;
# esac
# if [ "$IS_CHARGING" != "" ]; then
#   ICON=""
# fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar \
  --set "$NAME" \
  icon="$ICON" \
  label="${PERCENTAGE}%" \
