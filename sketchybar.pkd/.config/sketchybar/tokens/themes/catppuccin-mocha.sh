#!/usr/bin/env bash

# Catppuccin Mocha Theme
# https://catppuccin.com/

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/tokens/helpers.sh"

export THEME_TYPE="dark"

export COLOR_TRANSPARENT="0x00ffffff"
export COLOR_LIGHT_GRAY="0xFFa6adc8"
export COLOR_DARK_GRAY="0xFF45475a"

export COLOR_BG1="0xFF181825"
export COLOR_BG2="0xFF11111b"

generate_alpha_variants "WHITE" "0xFFcdd6f4"
generate_alpha_variants "BLACK" "0xFF1e1e2e"
generate_alpha_variants "RED" "0xFFf38ba8"
generate_alpha_variants "YELLOW" "0xFFf9e2af"
generate_alpha_variants "BLUE" "0xFF89b4fa"
generate_alpha_variants "GREEN" "0xFFa6e3a1"
generate_alpha_variants "MAGENTA" "0xFFf5c2e7"
generate_alpha_variants "CYAN" "0xFF89dceb"
generate_alpha_variants "ORANGE" "0xFFfab387"
generate_alpha_variants "TANGERINE" "0xFFeba0ac"
generate_alpha_variants "PURPLE" "0xFF8b6baf"
generate_alpha_variants "BLACK" "0xFF171723"
