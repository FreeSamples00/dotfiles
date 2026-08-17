# Dotfiles Management

Configuration files are managed with [Nix](https://nixos.org/) (nix-darwin + Home Manager). All config deployment, package installation, and service management is declarative.

## Architecture

- **nix-darwin**: System-level — macOS defaults, Homebrew casks/formulae, launchd services
- **Home Manager**: User-level — dotfiles, packages, shell config, colorscheme generation
- **Flake-based**: Single `flake.nix` with multiple profile outputs

## Directory Structure

```
dotfiles/
├── flake.nix                  # Flake entry point (nix-darwin + HM)
├── nix/
│   ├── colors.nix             # Global colorscheme attrset
│   ├── nix.just               # Justfile module for nix commands
│   ├── shared/
│   │   └── models.nix         # Opencode model definitions
│   ├── home/                  # HM modules (one per tool)
│   └── darwin/                # nix-darwin modules (system, services, brew)
├── profiles/                  # Profile composition
│   ├── base.nix               # Shared base (xdg.configHome fix)
│   ├── minimal.nix            # Barebones POSIX
│   ├── default.nix            # Dev workstation
│   └── macos.nix              # macOS desktop
├── configs/                   # Raw source config files (per tool)
└── docs/                      # Documentation
```

## Profiles

| Profile   | Target                           | Deployment                                  |
| --------- | -------------------------------- | ------------------------------------------- |
| `minimal` | SSH servers, containers, rescue  | `home-manager switch --flake .#scc-minimal` |
| `default` | Dev workstation (Linux or macOS) | `home-manager switch --flake .#scc-default` |
| `macos`   | macOS desktop (full system)      | `darwin-rebuild switch --flake .#scc-mac`   |

## Deploy Commands

All commands are wrapped with `just`:

```bash
# Deploy macOS (full system: services + casks + dotfiles)
just nix deploy mac

# Deploy standalone HM (default profile)
just nix deploy

# Deploy minimal profile
just nix deploy minimal

# Dry-run build (no activation)
just nix build mac

# Rollback to previous generation
just nix rollback mac

# List generations
just nix generations mac

# Update flake inputs
just nix update

# Garbage collect old generations (keep last 5 days)
just nix gc
```

## Config Deployment Methods

Each tool's config is deployed via one of three methods, defined in its HM module (`nix/home/<tool>.nix`):

| Method              | How it works                                                                       | Examples                                                               |
| ------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **Full Nix module** | Config generated entirely from Nix attrsets                                        | `git`, `starship`, `lazygit`                                           |
| **Source-filter**   | Raw source files deployed, with generated files excluded via `lib.cleanSourceWith` | `neovim`, `nushell`, `btop`, `opencode`                                |
| **Raw source**      | Entire config directory deployed as-is                                             | `aerospace`, `bash`, `sketchybar`, `karabiner`, `vim`, `zellij`, `bat` |

## Colorscheme Generation

All theme colors come from `nix/colors.nix`. The HM modules generate per-tool theme files:

- neovim: `nvim/lua/colorscheme/palette.lua`
- nushell: `nushell/confs/colors.nu`
- btop: `btop/themes/catppuccin.theme`
- ghostty: `ghostty/config` + `ghostty/themes/colorscheme-normal`
- jankyborders: `borders/bordersrc`
- git, starship, lazygit: colors injected directly into module settings

See [colorscheme.md](./colorscheme.md) for the full palette reference.

## Editing Configs

Raw source configs live in `configs/<tool>/`. After editing:

```bash
# Rebuild and activate
just nix deploy mac

# Or just build first to check for errors
just nix build mac
```

For Nix-ified tools (git, starship, lazygit), edit the HM module in `nix/home/<tool>.nix` directly.

## Rollback

```bash
# nix-darwin
just nix rollback mac

# Home Manager (standalone)
just nix rollback
```
