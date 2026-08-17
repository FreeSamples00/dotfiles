<!-- 2026-08-14 | branch: nix -->

# Nix Migration Reference

## Overview

Dotfiles managed by Nix (nix-darwin + Home Manager) with a three-tier profile system, global colorscheme generation from `nix/colors.nix`, and declarative service management via launchd. Replaces the previous GNU Stow + Homebrew setup.

## Architecture

- **nix-darwin**: System-level (services, Homebrew casks/formulae, system defaults, user shell)
- **Home Manager**: User-level (dotfiles, packages, shell config, colorscheme generation)
- **Flake-based**: Single flake with multiple profile outputs
- **Determinate Nix installer**: Manages Nix itself (`nix.enable = false` in nix-darwin)

## Profile System

### `minimal` — Barebones POSIX (SSH servers, containers, rescue)

Standalone Home Manager (no nix-darwin required).

| Category  | Packages                                             | Config method          |
| --------- | ---------------------------------------------------- | ---------------------- |
| Editor    | `vim`                                                | Raw source (`.vimrc`)  |
| Shell     | `bash`, `bash-completion`                            | Raw source (`.bashrc`) |
| VCS       | `git`, `git-delta`                                   | `programs.git` module  |
| Coreutils | `coreutils`, `curl`, `wget`, `tree`, `less`, `rsync` | —                      |

### `default` — Dev Workstation (Linux or macOS)

Standalone Home Manager. Imports `minimal`.

| Category    | Packages                                                                                                                                                           | Config method                                                     |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| Editor      | `neovim`, `python3`, `nodejs`, `gcc`, `go`, `rustup`, `stylua`, `shellcheck`, `jq`, `pandoc`, `shfmt`, `lua-language-server`, `rust-analyzer`, `taplo`, `prettier` | Source-filter + generated `palette.lua`                           |
| Shell       | `nushell`, `starship`, `carapace`, `zoxide`                                                                                                                        | Source-filter + generated `colors.nu`; `programs.starship` module |
| Git         | `lazygit`, `git-delta`                                                                                                                                             | `programs.lazygit` module; `programs.git` (inherited)             |
| Search/fs   | `ripgrep`, `fd`, `fzf`, `eza`, `dust`, `bat`                                                                                                                       | Raw source (bat + lesskey); `bat cache --build` hook              |
| TUI tools   | `btop`, `zellij`                                                                                                                                                   | Raw source (btop source-filter + generated theme)                 |
| Task runner | `just`                                                                                                                                                             | `home.packages` only                                              |
| Other       | `glow`, `hyperfine`, `figlet`, `uv`, `pre-commit`                                                                                                                  | —                                                                 |

### `macos` — macOS Desktop

Requires nix-darwin. Imports `default`.

| Category    | Packages                                                            | Config method                                                    |
| ----------- | ------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Terminal    | `ghostty` (cask)                                                    | Generated config + theme file                                    |
| Window mgmt | `aerospace` (cask)                                                  | Raw source                                                       |
| Bar/borders | `sketchybar`, `jankyborders`                                        | Raw source (sketchybar); generated (jankyborders)                |
| Keyboard    | `karabiner-elements` (cask)                                         | Raw source                                                       |
| Fonts       | `font-jetbrains-mono-nerd-font`, `font-sketchybar-app-font` (casks) | —                                                                |
| AI          | `opencode`                                                          | Source-filter + generated `opencode.jsonc` (model vars from Nix) |
| macOS tools | `pngpaste`, `yubikey-manager`, `yubico-piv-tool`, `libfido2`        | —                                                                |

## Package Management

- **Nix** (`home.packages`): All CLI formulae (git, neovim, ripgrep, etc.)
- **nix-darwin** (`homebrew` module): All casks + non-Nix formulae. `cleanup = "none"` (declares what should exist, doesn't remove manual installs).
- **Cargo**: nufmt, nu-lint, etc. stay as-is (not Nix-managed)
- **npm**: neovim, ocx, vercel stay as-is
- **Go**: golang.org/dl/go1.27rc1 stays as-is

## Services (nix-darwin `launchd.user.agents`)

| Service      | Label                              | Settings                      |
| ------------ | ---------------------------------- | ----------------------------- |
| sketchybar   | `io.github.felixkratz.sketchybar`  | KeepAlive, RunAtLoad          |
| aerospace    | `com.github.nikitabobko.aerospace` | KeepAlive, RunAtLoad          |
| jankyborders | `io.github.felixkratz.borders`     | KeepAlive, RunAtLoad          |
| obsidian     | `md.obsidian`                      | RunAtLoad (launches at login) |

Note: Sketchybar's getfocus plugin requires Full Disk Access (System Settings > Privacy & Security > Full Disk Access > sketchybar).

## Colorscheme System

### `nix/colors.nix`

Pure Nix attrset mirroring `docs/colorscheme.md`:

- `accent`: 3 tiers (dimmed, normal, bright) x 14 colors, raw hex without `#`
- `structural`: 9 colors (fg, border, surface, etc.)
- `background`: catppuccin originals + transparency overrides
- `derived`: 18 tool-specific values (cursor, git-branch, diff-_, focus-_)
- `opacity`: background and cursor opacity settings
- Format helpers: `withHash`, `with0x`
- `current`: convenience accessor for active tier colors (with `#` prefix)

### Theme Generation Per Tool

| Tool         | Generated file                                         | Pattern                                                                      |
| ------------ | ------------------------------------------------------ | ---------------------------------------------------------------------------- |
| neovim       | `nvim/lua/colorscheme/palette.lua`                     | Source-filter + palette module; `theme.lua` and `lualine.lua` `require()` it |
| nushell      | `nushell/confs/colors.nu`                              | Source-filter + colors file; `theme.nu` `source`s it                         |
| starship     | — (entire config from `programs.starship` module)      | Palette from `accent.bright.*` + `derived.*`                                 |
| lazygit      | — (`programs.lazygit` module)                          | Theme from `accent.normal.*`                                                 |
| git          | — (`programs.git` module)                              | Delta colors from `derived.*`                                                |
| ghostty      | `ghostty/config` + `ghostty/themes/colorscheme-normal` | Generated text (opacity + ANSI palette)                                      |
| jankyborders | `borders/bordersrc`                                    | Generated text (ARGB colors via `with0x`)                                    |
| opencode     | `opencode/opencode.jsonc`                              | Generated JSON (model vars from `nix/shared/models.nix`)                     |
| btop         | `btop/catppuccin.theme`                                | Source-filter + generated theme file                                         |

## Opencode Model Variables

Define models in `nix/shared/models.nix`, generate `opencode.jsonc` as plain JSON via `builtins.toJSON`. Deploy agents/, skills/, plugins/, themes/ as raw source via source-filter.

## Config Deployment Methods

| Config       | Method                          | Nix-ified? | Theme?            |
| ------------ | ------------------------------- | ---------- | ----------------- |
| git          | `programs.git`                  | Full       | delta colors      |
| starship     | `programs.starship`             | Full       | palette           |
| lazygit      | `programs.lazygit`              | Full       | gui.theme         |
| aerospace    | Raw source                      | No         | No                |
| neovim       | Source-filter + palette.lua     | Multi-file | palette           |
| nushell      | Source-filter + colors.nu       | Multi-file | colors            |
| sketchybar   | Raw source                      | No         | No                |
| opencode     | Source-filter + generated jsonc | Multi-file | No                |
| ghostty      | Generated config + theme file   | Full       | opacity + palette |
| jankyborders | Generated bordersrc             | Full       | ARGB colors       |
| bat          | Raw source + activation hook    | No         | No                |
| lesskey      | Raw source                      | No         | No                |
| btop         | Source-filter + generated theme | Multi-file | catppuccin theme  |
| vim          | Raw source                      | No         | No                |
| zellij       | Raw source                      | No         | No                |
| bash         | Raw source                      | No         | No                |
| karabiner    | Raw source                      | No         | No                |

## Source Conflict Resolution

Home Manager errors when deploying a recursive directory AND a specific file within it. Use `lib.cleanSourceWith` to exclude generated file paths from source trees before deploying. Applied to: neovim, nushell, btop, opencode.

## Config Edits Made to Source Files

| File                                        | Edit                                                                                                             |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `configs/neovim/lua/plugins/theme.lua`      | Added `require("colorscheme.palette")`, replaced hex in `color_overrides.mocha`                                  |
| `configs/neovim/lua/plugins/ui/lualine.lua` | Added `require("colorscheme.palette")`, replaced 2 hex values                                                    |
| `configs/nushell/confs/theme.nu`            | Replaced `let theme` + `let scheme` blocks with `source colors.nu`                                               |
| `configs/nushell/env.nu`                    | Removed starship/zoxide/carapace init, `$env.dependencies`, `mkdir`. Added PATH setup + shell tool init blocks.  |
| `configs/nushell/login.nu`                  | Removed dependency on external scripts                                                                           |
| `configs/nushell/aggregator.nu`             | Sources cache files for shell tools (starship, zoxide, carapace)                                                 |
| `configs/zellij/layouts/default.kdl`        | Fixed `color_base` from `#1E1E1E` to `#1e1e2e`                                                                   |
| `configs/bash/bashrc`                       | Removed `git config --global` calls (now managed by HM `programs.git`)                                           |
| `configs/aerospace/aerospace.toml`          | Removed `after-startup-command` (sketchybar kill/respawn — launchd handles it now). Used `$HOME` trick for btop. |

## bat Cache

Home Manager activation hook runs `bat cache --build` after deploying bat config and theme:

```nix
home.activation.buildBatCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.bat}/bin/bat cache --build
'';
```

## Nushell Launcher

Deployed via HM to `~/.local/bin/nushell`. Sets `XDG_CONFIG_HOME` and PATH (both HM and standalone Nix profile paths) before exec-ing `nu` with `--experimental-options='native-clip'`. Referenced by:

- nix-darwin user shell (`users.users.${username}.shell`)
- Ghostty config
- Aerospace btop shortcut

Shell integrations (starship/zoxide/carapace) use `enableNushellIntegration = false` in HM modules because source-deployed nushell config overrides HM's `extraConfig` injection. Integrations are handled manually via cache files sourced in `env.nu` and `aggregator.nu`.

## xdg.configHome

Forced to `~/.config/` in `profiles/base.nix` to prevent Home Manager from deploying to `~/Library/Application Support/` on macOS (HM's default XDG behavior on Darwin).

## Flake Structure

```
~/dotfiles/
├── flake.nix                          # nix-darwin + HM flake with 3 profiles
├── flake.lock
├── nix/
│   ├── colors.nix                     # global colorscheme attrset
│   ├── nix.just                       # nix justfile module
│   ├── shared/
│   │   └── models.nix                 # opencode model definitions
│   ├── home/
│   │   ├── git.nix                    # programs.git + delta
│   │   ├── starship.nix               # programs.starship
│   │   ├── lazygit.nix                # programs.lazygit
│   │   ├── neovim.nix                 # source-filter + palette.lua
│   │   ├── nushell.nix                # source-filter + colors.nu + launcher
│   │   ├── ghostty.nix                # generated config + theme
│   │   ├── jankyborders.nix           # generated bordersrc
│   │   ├── aerospace.nix              # raw source
│   │   ├── karabiner.nix              # raw source
│   │   ├── opencode.nix               # source-filter + generated jsonc
│   │   ├── sketchybar.nix             # raw source
│   │   ├── bat.nix                    # raw source + activation hook
│   │   ├── btop.nix                   # source-filter + generated theme
│   │   ├── zellij.nix                 # raw source
│   │   ├── vim.nix                    # raw source
│   │   └── bash.nix                   # raw source
│   └── darwin/
│       ├── brew.nix                   # Homebrew casks/formulae/taps
│       ├── services.nix               # launchd user agents
│       └── system.nix                 # macOS defaults, Touch ID, user shell
├── profiles/
│   ├── base.nix                       # shared base (xdg.configHome fix)
│   ├── minimal.nix                    # minimal profile
│   ├── default.nix                    # default profile
│   └── macos.nix                      # macos profile
├── configs/                           # raw source config files (per tool)
│   ├── aerospace/
│   ├── bash/
│   ├── bat/
│   ├── btop/
│   ├── ghostty/
│   ├── git/
│   ├── karabiner/
│   ├── neovim/
│   ├── nushell/
│   ├── opencode/
│   ├── sketchybar/
│   ├── vim/
│   └── zellij/
├── docs/                              # documentation
└── misc/                              # wallpapers and themes
```

## Activation

```bash
# macOS (full system: services + casks + dotfiles)
just nix deploy mac
# or: sudo darwin-rebuild switch --flake ~/dotfiles#scc-mac

# Standalone HM (default profile, no nix-darwin)
just nix deploy
# or: home-manager switch --flake ~/dotfiles#scc-default

# Minimal profile
just nix deploy minimal
# or: home-manager switch --flake ~/dotfiles#scc-minimal
```

## Just Commands

```
just nix deploy [profile]    # Deploy (mac = darwin-rebuild, else home-manager)
just nix build [profile]     # Dry-run build
just nix rollback [profile]  # Rollback to previous generation
just nix generations [profile] # List generations
just nix update              # Update flake inputs
just nix gc [keep]           # Garbage collect (keep last N days, default 5)
just nix eval <expr>         # Evaluate a Nix expression
just nix check               # Check flake for errors
```

## nix-darwin Configuration Notes

- `nix.enable = false` — Determinate Nix installer manages Nix, not nix-darwin
- `system.stateVersion = 7` — set once, don't change
- `system.primaryUser` — required by nix-darwin
- `security.pam.services.sudo_local.touchIdAuth = true` — Touch ID for sudo (replaces deprecated `enableSudoTouchIdAuth`)
- `specialArgs` passes `username`/`homeDirectory` to nix-darwin modules (separate from HM's `extraSpecialArgs`)
- `home-manager.useGlobalPkgs = true` and `useUserPackages = true` — shares nixpkgs instance
- `home-manager.extraSpecialArgs` passes `colors`/`models`/`username`/`homeDirectory` to HM modules

All Home Manager config is nix-darwin safe:

- All user-level (`xdg.configFile`, `home.file`, `programs.*`, `home.packages`)
- No `home.sessionVariables` (shell integration via program modules)
- No `home.keyboard` (karabiner is raw source)
- Profiles import cleanly into nix-darwin's `home-manager.users.<name>` block

## PATH

Two Nix profile paths are on PATH (both set in the nushell launcher):

- `~/.local/state/nix/profiles/home-manager/home-path/bin` — nix-darwin embedded HM
- `~/.nix-profile/bin` — standalone HM / Determinate Nix

`/etc/paths.d/nix` (created by Determinate Nix installer) adds `~/.nix-profile/bin` to system PATH for non-nushell shells (bash). This is kept intentionally.

## Rollback

### Home Manager

```bash
just nix rollback
# or: home-manager rollback
```

### nix-darwin

```bash
just nix rollback mac
# or: darwin-rebuild rollback
```

### What Can't Be Easily Reversed

| Item                                   | Reversible? | Notes                                         |
| -------------------------------------- | ----------- | --------------------------------------------- |
| Home Manager symlinks                  | Easy        | `home-manager rollback`                       |
| nix-darwin system config               | Easy        | `darwin-rebuild rollback`                     |
| launchd services                       | Easy        | Removed on rollback                           |
| Homebrew declarations                  | Easy        | `cleanup = "none"` means nothing removed      |
| env.nu / theme.lua / lualine.lua edits | Manual      | `git checkout` the files                      |
| Nix store (/nix/store)                 | Stays       | ~5-20GB. `nix-collect-garbage -d` to clean    |
| `/etc/nix` configuration               | Manual      | nix-darwin writes here; rollback handles most |
