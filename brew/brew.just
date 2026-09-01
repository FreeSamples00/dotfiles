_default:
    @just --unsorted --list brew

# Install packages from Brewfile (fallback for non-Nix machines)
install:
    brew bundle install --file ./Brewfile

# Update brew packages
update:
    brew bundle update --file ./Brewfile

# List installed packages from Brewfile
list:
    brew bundle list --file ./Brewfile
