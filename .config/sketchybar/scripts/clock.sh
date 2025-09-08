#!/bin/sh

# formatting follows https://en.wikipedia.org/wiki/ISO_8601

case $(date "+%p") in
  AM)
    AM_PM=" am"
    ;;
  PM)
    AM_PM=" pm"
    ;;
  *)
    AM_PM=""
    ;;
esac

sketchybar --set "$NAME" label="$(date '+%b%e %l:%M')$AM_PM"
