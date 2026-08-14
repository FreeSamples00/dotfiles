_default:
    @just --unsorted --list

# Dump data for tracking
[group('dot')]
dump:
    ./dot dump

# Manage symlinks
[group('dot')]
stow *args='':
    ./dot stow {{ args }}

# Nix commands (deploy, build, rollback, etc.)
[group('nix')]
mod nix 'nix/nix.just'

# Neovim configuration tasks
[group: 'tools']
mod nvim 'neovim.pkd/.config/nvim/.nvim.just'

# Sketchybar configuration tasks
[group: 'tools']
mod skbar 'sketchybar.pkd/.config/sketchybar/.sketchybar.just'
