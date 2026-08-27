_default:
    @just --unsorted --list dot

# Apply configs (deploy all dotfiles via chezmoi)
apply:
    chezmoi apply --source ~/dotfiles/configs --force --keep-going

# Edit chezmoi source files
edit:
    chezmoi edit --source ~/dotfiles/configs

# Show diff between applied and source
diff:
    chezmoi diff --source ~/dotfiles/configs

# Update from git and reapply
update:
    cd ~/dotfiles && git pull && just dot apply

# Initialize chezmoi on a new machine
init:
    chezmoi init --source ~/dotfiles/configs

# Switch colorscheme theme (e.g., just dot theme catppuccin-mocha)
theme name:
    cp ~/dotfiles/configs/themes/{{name}}.toml ~/dotfiles/configs/.chezmoidata/colors.toml
    just dot apply
