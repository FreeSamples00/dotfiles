#!/bin/bash

# Script to open zen and ensure it lands on the right workspace

CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
open -na Zen
aerospace move-node-to-workspace "$CURRENT_WORKSPACE" &>/dev/null
aerospace workspace "$CURRENT_WORKSPACE" &>/dev/null
