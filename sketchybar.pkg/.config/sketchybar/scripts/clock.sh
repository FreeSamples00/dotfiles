#!/bin/bash
# script

case $(gdate "+%p") in
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

# use - in format specifiers to remove padding
sketchybar --set "$NAME" label="$(gdate '+%b %-e %-l:%M')$AM_PM"
