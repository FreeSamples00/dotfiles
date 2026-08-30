# Setup

## macOS (Nix)

### Install Nix

Install Nix using the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | sh -s -- install
```

This installs Nix with flakes enabled and adds `~/.nix-profile/bin` to PATH via `/etc/paths.d/nix`.

### Install nix-darwin

Install `darwin-rebuild` (bootstrap tool, not declared in the flake):

```bash
nix profile install nix-darwin
```

### Deploy packages + system settings

```bash
# Build first to verify everything compiles
just pack build mac

# Deploy the full system (packages + settings + services)
just pack deploy mac
```

This activates:

- macOS system defaults (dark mode, dock settings, finder, trackpad, screenshots)
- Touch ID for sudo
- Nushell as login shell (via `~/.local/bin/nushell` launcher)
- launchd services (sketchybar, aerospace, jankyborders, obsidian)
- Homebrew casks and formulae

### Deploy configs

```bash
# Initialize chezmoi (prompts for username, git name, email — run once)
just dot init

# Deploy all configs via chezmoi
just dot apply
```

### Post-Deploy

#### Sketchybar Full Disk Access

Sketchybar's getfocus plugin requires Full Disk Access to read `~/Library/DoNotDisturb/DB/Assertions.json`:

1. System Settings > Privacy & Security > Full Disk Access
2. Add `sketchybar` (at `/opt/homebrew/bin/sketchybar`)

#### Karabiner-Elements

Grant Karabiner input monitoring permission on first launch:

1. System Settings > Privacy & Security > Input Monitoring
2. Enable Karabiner-Elements

## Linux with Nix

```bash
# Deploy packages via Home Manager
just pack deploy default

# Initialize chezmoi + deploy configs
just dot init
just dot apply
```

## Linux without Nix (e.g., university machine)

```bash
# Install packages via Linuxbrew
just brew install

# Initialize chezmoi (prompts for username, git name, email — run once)
just dot init

# Deploy configs via chezmoi
just dot apply
```

### Linuxbrew setup

If Linuxbrew isn't on PATH yet:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

The `dot_bashrc` deploys a Linuxbrew detection block that runs this automatically for bash. For nushell, the `nushell.tmpl` launcher prepends `/home/linuxbrew/.linuxbrew/bin` to PATH.

## Next Steps

- [Dotfiles Management](./dotfiles-nix.md) - Deploy commands, config editing, rollback
- [Colorscheme](./colorscheme.md) - Color palette reference
- [SSH](./ssh.md) - SSH config structure and yubikey setup
