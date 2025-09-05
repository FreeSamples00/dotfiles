#!/bin/sh

# formatting follows https://en.wikipedia.org/wiki/ISO_8601
sketchybar --set "$NAME" label="$(date '+%b%e %l:%M') $(date "+%p" | gsed 's/\(AM\|PM\)/\L&/g')"
