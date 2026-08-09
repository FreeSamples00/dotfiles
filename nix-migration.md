<!-- 2026-08-09 | branch: main -->

# Nix Migration Plan

## Overview

Migrate dotfiles from GNU Stow + Homebrew to Nix (nix-darwin + Home Manager) with a three-tier profile system, global colorscheme generation, and declarative service management.

## Architecture

- **nix-darwin**: System-level (services, Homebrew casks/formulae, system settings)
- **Home Manager**: User-level (dotfiles, packages, shell config)
- **Flake-based**: Single flake with multiple profile outputs

## Profile System

### `util` — Barebones POSIX (SSH servers, containers, rescue)

Standalone Home Manager (no nix-darwin required).

| Category  | Packages                                             | Config method          |
| --------- | ---------------------------------------------------- | ---------------------- |
| Editor    | `vim`                                                | Raw source (`.vimrc`)  |
| Shell     | `bash`, `bash-completion`                            | Raw source (`.bashrc`) |
| VCS       | `git`, `git-delta`                                   | `programs.git` module  |
| Coreutils | `coreutils`, `curl`, `wget`, `tree`, `less`, `rsync` | —                      |

### `core` — Dev Workstation (Linux or macOS)

Standalone Home Manager. Imports `util`.

| Category    | Packages                                                                                                                                                        | Config method                                                     |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Editor      | `neovim`, `python3`, `node`, `gcc`, `go`, `rustc`, `stylua`, `shellcheck`, `jq`, `pandoc`, `shfmt`, `lua-language-server`, `rust-analyzer`, `taplo`, `prettier` | Source-filter + generated `palette.lua`                           |
| Shell       | `nushell`, `starship`, `carapace`, `zoxide`                                                                                                                     | Source-filter + generated `colors.nu`; `programs.starship` module |
| Git         | `lazygit`, `git-delta`                                                                                                                                          | `programs.lazygit` module; `programs.git` (inherited)             |
| Search/fs   | `ripgrep`, `fd`, `fzf`, `eza`, `dust`, `bat`                                                                                                                    | Raw source (bat + lesskey); `bat cache --build` hook              |
| TUI tools   | `btop`, `zellij`                                                                                                                                                | Raw source                                                        |
| Task runner | `just`                                                                                                                                                          | `home.packages` only                                              |
| Other       | `glow`, `hyperfine`, `figlet`, `uv`, `pre-commit`                                                                                                               | —                                                                 |

### `macos` — macOS Desktop

Requires nix-darwin. Imports `core`.

| Category    | Packages                                                            | Config method                                                    |
| ----------- | ------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Terminal    | `ghostty` (cask)                                                    | Generated config + theme file                                    |
| Window mgmt | `aerospace` (cask)                                                  | Raw source                                                       |
| Bar/borders | `sketchybar`, `jankyborders`                                        | Raw source (sketchybar); generated (jankyborders)                |
| Keyboard    | `karabiner-elements` (cask)                                         | Raw source                                                       |
| Fonts       | `font-jetbrains-mono-nerd-font`, `font-sketchybar-app-font` (casks) | —                                                                |
| AI          | `opencode`                                                          | Source-filter + generated `opencode.jsonc` (model vars from Nix) |
| macOS tools | `pngpaste`, `ykman`, `yubico-piv-tool`, `libfido2`                  | —                                                                |

## Package Management

- **Nix** (`home.packages`): All CLI formulae (git, neovim, ripgrep, etc.)
- **nix-darwin** (`homebrew` module): All casks + non-Nix formulae. `cleanup = "none"` (declares what should exist, doesn't remove manual installs).
- **Cargo**: nufmt, nu-lint, etc. stay as-is (not Nix-managed)

## Services (nix-darwin `launchd.user.agents`)

| Service      | Label                              | Settings                      |
| ------------ | ---------------------------------- | ----------------------------- |
| sketchybar   | `io.github.felixkratz.sketchybar`  | KeepAlive, RunAtLoad          |
| aerospace    | `com.github.nikitabobko.aerospace` | KeepAlive, RunAtLoad          |
| jankyborders | `io.github.felixkratz.borders`     | KeepAlive, RunAtLoad          |
| obsidian     | `md.obsidian`                      | RunAtLoad (launches at login) |

## Colorscheme System

### `nix/colors.nix`

Pure Nix attrset mirroring `docs/colorscheme.md`:

- `accent`: 3 tiers (dimmed, normal, bright) x 14 colors, raw hex without `#`
- `structural`: 9 colors (fg, border, surface, etc.)
- `background`: catppuccin originals + transparency overrides
- `derived`: 18 tool-specific values (cursor, git-branch, diff-_, focus-_)
- Format helpers: `withHash`, `with0x`

### Theme Generation Per Tool

| Tool         | Generated file                                         | Pattern                                                                      |
| ------------ | ------------------------------------------------------ | ---------------------------------------------------------------------------- |
| neovim       | `nvim/lua/colorscheme/palette.lua`                     | Source-filter + palette module; `theme.lua` and `lualine.lua` `require()` it |
| nushell      | `nushell/confs/colors.nu`                              | Source-filter + colors file; `theme.nu` `source`s it                         |
| starship     | — (entire config from `programs.starship` module)      | Palette from `accents.*.bright` + `derived.*`                                |
| lazygit      | — (`programs.lazygit` module)                          | Theme from `accents.*.normal`                                                |
| git          | — (`programs.git` module)                              | Delta colors from `derived.*`                                                |
| ghostty      | `ghostty/config` + `ghostty/themes/colorscheme-normal` | Generated text (opacity + ANSI palette)                                      |
| jankyborders | `borders/bordersrc`                                    | Generated text (ARGB colors)                                                 |
| opencode     | `opencode/opencode.jsonc`                              | Generated JSON (model vars from `nix/shared/models.nix`)                     |

## Opencode Model Variables

Define models in `nix/shared/models.nix`, generate `opencode.jsonc` as plain JSON. Deploy agents/, skills/, plugins/, themes/ as raw source via source-filter.

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
| btop         | Raw source                      | No         | name ref          |
| vim          | Raw source                      | No         | name ref          |
| zellij       | Raw source                      | No         | name ref          |
| bash         | Raw source                      | No         | No                |
| karabiner    | Raw source                      | No         | No                |

## Source Conflict Resolution

Home Manager errors when deploying a recursive directory AND a specific file within it. Use `lib.cleanSourceWith` to exclude generated file paths from source trees before deploying.

## Existing Config Edits Required

| File                                            | Edit                                                                                                                   |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `neovim.pkd/.../lua/plugins/theme.lua`          | Add `require("colorscheme.palette")`, replace hex in `color_overrides.mocha`                                           |
| `neovim.pkd/.../lua/plugins/ui/lualine.lua`     | Add `require("colorscheme.palette")`, replace 2 hex values (lines 80, 84)                                              |
| `nushell.pkd/.config/nushell/confs/theme.nu`    | Replace `let theme` + `let scheme` blocks (lines 4-43) with `source colors.nu`                                         |
| `nushell.pkd/.config/nushell/env.nu`            | Remove starship/zoxide/carapace init (lines 46-54), `$env.dependencies` (38-42), `mkdir` (44). Keep just init (55-61). |
| `zellij.pkd/.config/zellij/layouts/default.kdl` | Fix `color_base` from `#1E1E1E` to `#1e1e2e` (line 11)                                                                 |

## bat Cache

Home Manager activation hook runs `bat cache --build` after deploying bat config and theme:

```nix
home.activation.buildBatCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.bat}/bin/bat cache --build
'';
```

## Nushell Launcher

`/usr/local/bin/nushell` is a symlink to `nushell-launcher.sh` (wrapper that sets XDG_CONFIG_HOME and PATH before exec-ing `nu`). Keep this launcher; deploy via `home.file`. Ghostty config references this path.

## Flake Structure

```
~/dotfiles/
├── flake.nix
├── flake.lock
├── nix/
│   ├── colors.nix
│   ├── shared/
│   │   └── models.nix
│   ├── home/
│   │   ├── neovim.nix
│   │   ├── nushell.nix
│   │   ├── starship.nix
│   │   ├── lazygit.nix
│   │   ├── git.nix
│   │   ├── ghostty.nix
│   │   ├── jankyborders.nix
│   │   ├── aerospace.nix
│   │   ├── opencode.nix
│   │   ├── bat.nix
│   │   └── ...
│   └── darwin/
│       ├── brew.nix
│       ├── services.nix
│       └── system.nix
├── profiles/
│   ├── util.nix
│   ├── core.nix
│   └── macos.nix
├── *.pkd/
├── dot
└── data/
    └── Brewfile
```

## Activation

```bash
# macOS (full system: services + casks + dotfiles)
darwin-rebuild switch --flake ~/dotfiles#scc-mac

# Remote Linux box (core dev tools)
home-manager switch --flake ~/dotfiles#scc-core

# Container/VM (minimal)
home-manager switch --flake ~/dotfiles#scc-util
```

## nix-darwin Compatibility Notes

All Home Manager config is nix-darwin safe:

- All user-level (`xdg.configFile`, `home.file`, `programs.*`, `home.packages`)
- No `home.sessionVariables` (shell integration via program modules)
- No `home.keyboard` (karabiner is raw source)
- Profiles import cleanly into nix-darwin's `home-manager.users.<name>` block

## Risks and Mitigations

### High Risk

1. **Shell breakage during nushell migration** — Removing env.nu init blocks before HM modules activate could leave no prompt/completions. Test HM integration first, keep old env.nu commented.
2. **PATH conflicts between Nix and Homebrew** — Both modify PATH. Remove duplicates from Homebrew. Don't have both install the same tool.
3. **nix-darwin modifies system state** — Bad config could break system services. Always `darwin-rebuild build` before `switch`.
4. **launchd service conflicts** — sketchybar started by both aerospace and launchd. Remove `exec-and-forget` from aerospace config when migrating to launchd.

### Medium Risk

5. **Immutable symlinks break edit workflow** — Edits require `home-manager switch`. Use `mkOutOfStoreSymlink` for actively iterated configs.
6. **Opencode config generation** — Nix bug could silently change agent permissions. Diff generated JSON against current file.
7. **Brewfile migration drift** — Missing a tap/cask in nix-darwin declarations. Run `brew list` after migration, diff against declarations.

## Rollback

### Home Manager

```bash
home-manager generations
home-manager rollback
```

### nix-darwin

```bash
darwin-rebuild --list-generations
darwin-rebuild rollback
```

### Full Rollback to Pre-Nix State

```bash
home-manager rollback
darwin-rebuild rollback
git checkout neovim.pkd/ nushell.pkd/ zellij.pkd/
./dot stow -a
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

## Migration Order

1. Install Nix + nix-darwin + Home Manager
2. Create `nix/colors.nix` — verify with `nix eval`
3. Create `nix/shared/models.nix`
4. Create `flake.nix` + all profile + module skeletons
5. Dry-run: `darwin-rebuild build --flake .#scc-mac`
6. Fix zellij `color_base` bug
7. Edit neovim `theme.lua` + `lualine.lua`
8. Edit nushell `theme.nu` + `env.nu`
9. Migrate configs: git -> starship -> lazygit -> neovim -> nushell -> bat/lesskey -> ghostty -> jankyborders -> aerospace -> opencode -> remaining raw-source
10. Set up launchd services
11. Migrate Brewfile -> nix-darwin `homebrew` module (full migration, `cleanup = "none"`)
12. Set up `bat cache --build` activation hook
13. Remove stow symlinks and `dot` script
14. Verify standalone util/core profiles build

## Safest Migration Strategy

1. **Commit everything first** — `git add -A && git commit -m "pre-nix-migration"`
2. **Keep stow working alongside HM initially** — Don't remove stow symlinks until HM is verified. One config at a time: `dot -d git` then `home-manager switch`, verify, repeat.
3. **Test on one config first** — Migrate just `git` (simplest, `programs.git` module). Verify. Then proceed.
4. **Keep the `dot` script** — Don't delete until at least a week on Nix. Emergency fallback.
5. **Emergency rollback**:
   ```bash
   home-manager rollback
   darwin-rebuild rollback
   git checkout neovim.pkd/ nushell.pkd/ zellij.pkd/
   ./dot stow -a
   ```
