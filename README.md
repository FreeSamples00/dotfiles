# My Configuration

Personal dotfiles and system configuration managed with Nix (nix-darwin + Home Manager).

## File Structure

```
dotfiles/
├── flake.nix                  # Flake entry point (nix-darwin + HM)
├── nix/                       # Nix configuration logic
│   ├── colors.nix             # Global colorscheme attrset
│   ├── nix.just               # Justfile module for nix commands
│   ├── shared/                # Shared Nix data (model definitions)
│   ├── home/                  # Home Manager modules (one per tool)
│   └── darwin/                # nix-darwin modules (system, services, brew)
├── profiles/                  # Profile composition (minimal, default, macos)
├── configs/                   # Raw source config files (per tool)
├── docs/                      # Documentation
└── misc/                      # Wallpapers and themes
```

- `nix/` — Nix modules that define how configs are generated and deployed
- `profiles/` — Controls what gets installed on each machine type
- `configs/` — Raw config files deployed to `~/.config/` by Home Manager
- `docs/` — Setup guides and reference documentation
- `misc/` — Visual assets (wallpapers, third-party themes)

## Quick Start

```bash
# Deploy macOS (full system)
just nix deploy mac

# Edit a config, then redeploy
just nix deploy mac
```

## Documentation

- [Setup](./docs/setup.md) - Initial installation (Nix, nix-darwin, first deploy)
- [Dotfiles Management](./docs/dotfiles-nix.md) - Deploy commands, editing, rollback
- [Colorscheme](./docs/colorscheme.md) - Color palette reference
- [Nix Migration Reference](./nix-migration.md) - Full architecture details
- [Cronjobs](./docs/cronjobs.md) - Scheduled tasks
- [Yubikey](./docs/yubikey.md) - Yubikey setup and SSH usage
- [TDF](./docs/pdf-viewer.md) - TUI pdf viewer
