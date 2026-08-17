_default:
    @just --unsorted --list

# Nix commands (deploy, build, rollback, etc.)
[group('nix')]
mod nix 'nix/nix.just'

# Neovim configuration tasks
[group: 'tools']
mod nvim 'configs/neovim/.nvim.just'

# Sketchybar configuration tasks
[group: 'tools']
mod skbar 'configs/sketchybar/.sketchybar.just'
