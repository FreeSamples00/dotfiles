#!/bin/bash

CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
open -na Zen
aerospace move-node-to-workspace "$CURRENT_WORKSPACE" 2&>/dev/null
aerospace workspace "$CURRENT_WORKSPACE" 2&>/dev/null
