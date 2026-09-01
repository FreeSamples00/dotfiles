_default:
    @just --unsorted --list

# Dotfiles: deploy configs via chezmoi
[group('dot')]
mod dot 'configs/dot.just'

# Packages: Nix commands (deploy, build, rollback, etc.)
[group('pack')]
mod pack 'nix/nix.just'

# Brew: fallback package installation
[group('pack')]
mod brew 'brew/brew.just'

# Neovim configuration tasks
[group('tools')]
mod nvim 'configs/dot_config/nvim/.nvim.just'

# Sketchybar configuration tasks
[group('tools')]
mod skbar 'configs/dot_config/sketchybar/.sketchybar.just'
