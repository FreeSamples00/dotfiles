#! /bin/bash

SIDE="$1"

sketchybar --add event aerospace_workspace_change

sketchybar \
        --add item "workspace_start.$SIDE" "$SIDE" \
        --set "workspace_start.$SIDE" \
              label="$WORKSPACE_LEFT_ENDCAP" \
              padding_left=0 \
              padding_right=0 \
              label.padding_left=8 \
              label.padding_right=2 \
              icon.padding_left=0 \
              icon.padding_right=0 \
              padding=0

for sid in $(aerospace list-workspaces --all); do
    NAME="workspace_${sid}.$SIDE"
    sketchybar \
        --add item "$NAME" "$SIDE" \
        --subscribe "$NAME" aerospace_workspace_change \
        --set "$NAME" \
              label="$sid" \
              script="$SCRIPT_DIR/aerospace.sh $sid" \
              click_script="aerospace workspace $sid" \
              padding_left=0 \
              padding_right=0 \
              label.padding_left=3 \
              label.padding_right=3 \
              icon.padding_left=0 \
              icon.padding_right=0 \
              padding=0
done

sketchybar \
        --add item "workspace_end.$SIDE" "$SIDE" \
        --set "workspace_end.$SIDE" \
              label="$WORKSPACE_RIGHT_ENDCAP" \
              padding_left=0 \
              padding_right=0 \
              label.padding_left=0 \
              label.padding_right=8 \
              icon.padding_left=0 \
              icon.padding_right=0 \
              padding=0

sketchybar \
        --add bracket "workspaces.$SIDE" \
        "workspace_start.$SIDE" \
        '/space_.*\..*' \
        "workspace_end.$SIDE"

sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"
