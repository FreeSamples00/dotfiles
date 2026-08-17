# Setup

## Nix (Determinate Nix installer)

Install Nix using the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | sh -s -- install
```

This installs Nix with flakes enabled and adds `~/.nix-profile/bin` to PATH via `/etc/paths.d/nix`.

## nix-darwin

Install `darwin-rebuild` (bootstrap tool, not declared in the flake):

```bash
nix profile install nix-darwin
```

## Deploy

```bash
# Build first to verify everything compiles
just nix build mac

# Deploy the full system (services + casks + dotfiles)
just nix deploy mac
```

This activates:

- macOS system defaults (dark mode, dock settings, finder, trackpad, screenshots)
- Touch ID for sudo
- Nushell as login shell (via `~/.local/bin/nushell` launcher)
- launchd services (sketchybar, aerospace, jankyborders, obsidian)
- Homebrew casks and formulae
- All dotfiles via Home Manager

## Post-Deploy

### Sketchybar Full Disk Access

Sketchybar's getfocus plugin requires Full Disk Access to read `~/Library/DoNotDisturb/DB/Assertions.json`:

1. System Settings > Privacy & Security > Full Disk Access
2. Add `sketchybar` (at `/opt/homebrew/bin/sketchybar`)

### Karabiner-Elements

Grant Karabiner input monitoring permission on first launch:

1. System Settings > Privacy & Security > Input Monitoring
2. Enable Karabiner-Elements

## Next Steps

- [Dotfiles Management](./dotfiles-nix.md) - Deploy commands, config editing, rollback
- [Colorscheme](./colorscheme.md) - Color palette reference
