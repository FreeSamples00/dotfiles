_default:
    @just --unsorted --list dot

# Apply configs (deploy all dotfiles via chezmoi)
apply:
    chezmoi apply --source ./ --force --keep-going

# Show diff between applied and source
diff:
    chezmoi diff --source ./

# Initialize chezmoi on a new machine
init:
    chezmoi init --source ./
