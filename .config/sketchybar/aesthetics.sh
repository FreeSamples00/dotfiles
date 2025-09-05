#!/usr/bin/env sh

# ==================== Color Palette ====================

BLACK=0xff181926
WHITE=0xffcad3f5
RED=0xffed8796
GREEN=0xffa6da95
BLUE=0xff8aadf4
YELLOW=0xffeed49f
ORANGE=0xfff5a97f
MAGENTA=0xffc6a0f6
GREY=0xff1e1e1e
TRANSPARENT=0x00000000

# ==================== Component Variables ====================

# ========== General ==========

export FONT="JetBrainsMono Nerd Font Mono"
export ICON_SIZE="22.0"
export FONT_SIZE="17.0"

export PADDING=8
export ICON_PADDING=4

# ========== Bar ==========

export BAR_COLOR=$TRANSPARENT # Grey bar
export ICON_COLOR=$WHITE # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export SHADOW_COLOR=$BLACK

export BAR_HEIGHT=40
export BAR_POSITION="top"
export BAR_STICKY="on"
export BAR_PADDING_RIGHT=10
export BAR_PADDING_LEFT=10
export BAR_BLUR_RADIUS=0
export BAR_CORNER_RADIUS=9

# ========== Backgrounds ==========

export BACKGROUND_COLOR=$GREY

export BACKGROUND_STATUS="on"
export BACKGROUND_RADIUS=8
export BACKGROUND_HEIGHT=28

# ========== Popups ==========

export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$WHITE

# ========== Workspaces ==========

export WORKSPACE_LEFT_ENDCAP="["
export WORKSPACE_RIGHT_ENDCAP="]"

export WORKSPACE_FOCUSED_COLOR="0xffa6e3a1"

