#!/bin/sh
# Ensure executable scripts deployed by chezmoi have correct permissions
# Chezmoi doesn't always preserve the executable bit on first apply

# Nushell launcher (user shell)
chmod +x "$HOME/.local/bin/nushell" 2>/dev/null

# Sketchybar scripts
chmod +x "$HOME/.config/sketchybar/sketchybarrc" 2>/dev/null
chmod +x "$HOME/.config/sketchybar/items/"*.nu 2>/dev/null
chmod +x "$HOME/.config/sketchybar/plugins/"*.nu 2>/dev/null
chmod +x "$HOME/.config/sketchybar/plugins/getfocus" 2>/dev/null

# Jankyborders launcher
chmod +x "$HOME/.config/borders/bordersrc" 2>/dev/null
