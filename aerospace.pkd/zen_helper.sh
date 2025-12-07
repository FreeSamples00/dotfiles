#!/bin/bash

# Script to open zen and ensure it lands on the right workspace

CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
open -na Zen

# Wait for Zen window to appear (max 5 seconds)
for _ in {1..10}; do
    if aerospace list-windows --all | grep -i "zen" > /dev/null; then
        break
    fi
    sleep 0.25
done

# Move the Zen window to the current workspace
aerospace move-node-to-workspace "$CURRENT_WORKSPACE"
aerospace workspace "$CURRENT_WORKSPACE"
