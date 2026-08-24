# Migration Plan: HM Configs to Chezmoi + Nix Packages-Only

Convert the current Nix + Home Manager system to a decoupled architecture:

- **Chezmoi** manages all dotfile configs (with colorscheme templating) — works on every machine
- **Nix** (nix-darwin + HM) manages packages and macOS system settings — only on machines that can run Nix
- **Brew** is the fallback package manager — works anywhere, no Nix required

## Target Architecture

```
dotfiles/
├── configs/                              # chezmoi source directory (ALL dotfiles)
│   ├── .chezmoidata/
│   │   └── colors.toml                   # central colorscheme (replaces nix/colors.nix)
│   ├── .chezmoi.toml.tmpl                # per-machine config generator (username, gitName, gitEmail)
│   ├── .chezmoiignore.tmpl               # platform-conditional file deployment
│   ├── dot_config/
│   │   ├── bat/                           # static (config, themes/)
│   │   ├── lesskey                        # static (deployed to ~/.config/lesskey, not inside bat/)
│   │   ├── btop/
│   │   │   ├── btop.conf                  # static
│   │   │   └── themes/
│   │   │       ├── catppuccin.theme.bak   # static (backup)
│   │   │       └── catppuccin.theme.tmpl  # generated from colors.toml
│   │   ├── borders/
│   │   │   └── bordersrc.tmpl             # generated from colors.toml (macOS only)
│   │   ├── ghostty/
│   │   │   ├── config.tmpl               # generated from colors.toml
│   │   │   ├── Ghostty.icns              # static
│   │   │   ├── shaders/                  # static (recursive)
│   │   │   └── themes/
│   │   │       └── colorscheme-normal.tmpl  # generated from colors.toml
│   │   ├── git/
│   │   │   └── config.tmpl               # generated from colors.toml + identity
│   │   ├── karabiner/                    # static (recursive, macOS only)
│   │   ├── lazygit/
│   │   │   └── config.yml.tmpl          # generated from colors.toml
│   │   ├── nvim/                         # static (recursive, minus palette.lua)
│   │   │   └── lua/colorscheme/
│   │   │       └── palette.lua.tmpl      # generated from colors.toml
│   │   ├── nushell/                      # static (recursive, minus colors.nu)
│   │   │   └── confs/
│   │   │       └── colors.nu.tmpl        # generated from colors.toml
│   │   ├── opencode/                     # static (recursive)
│   │   ├── sketchybar/                   # static (recursive, macOS only)
│   │   ├── starship.toml.tmpl           # generated from colors.toml
│   │   └── zellij/                       # static (recursive)
│   ├── dot_aerospace.toml               # static (macOS only)
│   ├── dot_bashrc                        # static
│   ├── dot_hushlogin                     # static
│   ├── dot_gitignore                     # static
│   ├── dot_vimrc                         # static
│   ├── dot_vim/
│   │   └── colors/
│   │       └── colorscheme-normal.vim   # static
│   ├── dot_local/
│   │   └── bin/
│   │       └── nushell.tmpl              # platform-conditional PATH
│   ├── dot_ssh/
│   │   └── config                        # static (global settings + host definitions)
│   ├── run_after_bat-cache.sh            # activation hook (runs after chezmoi apply)
│   ├── run_after_fc-cache.sh            # activation hook (runs after chezmoi apply)
│
├── nix/                                  # ALL Nix stuff
│   ├── flake.nix                         # darwinConfigurations + homeConfigurations (packages only)
│   ├── flake.lock
│   ├── variables.nix                     # username + system (Nix identity, no gitName/gitEmail)
│   ├── nix.just                          # Nix commands justfile module
│   ├── darwin/
│   │   ├── system.nix                    # macOS defaults (dark mode, dock, finder, etc.)
│   │   ├── services.nix                  # launchd agents (sketchybar, aerospace, borders, obsidian)
│   │   └── brew.nix                      # Homebrew management (casks, formulae, taps)
│   └── profiles/
│       ├── minimal.nix                  # packages only (no config imports)
│       ├── default.nix                  # packages only (no config imports)
│       ├── security.nix                 # packages only (imports default.nix for packages)
│       └── macos.nix                   # packages only (imports default.nix, macOS-specific pkgs)
│
├── .justfile                             # root justfile (imports dot, pack, brew, tool modules)
├── dot.just                              # chezmoi commands (apply, edit, diff, update)
├── brew.just                             # brew fallback commands (install from Brewfile)
├── data/                                 # repo data (NOT deployed by chezmoi)
│   └── Brewfile                          # full brew package list for non-Nix machines
├── misc/                                 # wallpapers, ghidra themes (not deployed)
├── docs/                                 # documentation
└── README.md
```

### Deploy commands per machine type

**Mac (full Nix + chezmoi):**

```bash
just dot apply                            # deploys all configs with colorscheme templating
just pack deploy mac                      # system settings + services + brew + packages
```

**Personal Linux (Nix + chezmoi):**

```bash
just dot apply                            # deploys all configs (skips macOS-only files)
just pack deploy default                  # packages only (HM, no configs)
```

**University Linux (chezmoi + brew only, no Nix):**

```bash
just dot apply                            # deploys all configs (skips macOS-only files)
just brew install                         # installs packages via Linuxbrew from Brewfile
```

---

## Phase 1: Create Chezmoi Structure in `configs/`

### 1a. Rename config directories to chezmoi convention

Chezmoi uses a `dot_` prefix convention: `dot_config/` maps to `~/.config/`, `dot_bashrc` maps to `~/.bashrc`, etc.

**Existing files that need `git mv` (actual renames):**

| Current path                       | New path                         | Maps to                                                                           |
| ---------------------------------- | -------------------------------- | --------------------------------------------------------------------------------- |
| `configs/aerospace/aerospace.toml` | `configs/dot_aerospace.toml`     | `~/.aerospace.toml`                                                               |
| `configs/bash/bashrc`              | `configs/dot_bashrc`             | `~/.bashrc`                                                                       |
| `configs/bash/hushlogin`           | `configs/dot_hushlogin`          | `~/.hushlogin`                                                                    |
| `configs/vim/vimrc`                | `configs/dot_vimrc`              | `~/.vimrc`                                                                        |
| `configs/vim/colors/`              | `configs/dot_vim/colors/`        | `~/.vim/colors/`                                                                  |
| `configs/git/gitignore`            | `configs/dot_gitignore`          | `~/.gitignore`                                                                    |
| `configs/bat/`                     | `configs/dot_config/bat/`        | `~/.config/bat/`                                                                  |
| `configs/btop/`                    | `configs/dot_config/btop/`       | `~/.config/btop/`                                                                 |
| `configs/ghostty/`                 | `configs/dot_config/ghostty/`    | `~/.config/ghostty/` (only icns, shaders/, themes/ — no static config exists yet) |
| `configs/karabiner/`               | `configs/dot_config/karabiner/`  | `~/.config/karabiner/`                                                            |
| `configs/neovim/`                  | `configs/dot_config/nvim/`       | `~/.config/nvim/` (chezmoi: `nvim` not `neovim`)                                  |
| `configs/nushell/`                 | `configs/dot_config/nushell/`    | `~/.config/nushell/`                                                              |
| `configs/opencode/`                | `configs/dot_config/opencode/`   | `~/.config/opencode/`                                                             |
| `configs/sketchybar/`              | `configs/dot_config/sketchybar/` | `~/.config/sketchybar/`                                                           |
| `configs/zellij/`                  | `configs/dot_config/zellij/`     | `~/.config/zellij/`                                                               |

**New files that need to be created (do NOT exist in `configs/` yet — currently HM-generated):**

| New path                                                    | Maps to                                       | Source                                                            |
| ----------------------------------------------------------- | --------------------------------------------- | ----------------------------------------------------------------- |
| `configs/dot_config/lesskey`                                | `~/.config/lesskey`                           | `configs/bat/lesskey` (move out of bat/ to top-level dot_config/) |
| `configs/dot_config/git/config.tmpl`                        | `~/.config/git/config`                        | New template (was HM `programs.git.settings`)                     |
| `configs/dot_config/starship.toml.tmpl`                     | `~/.config/starship.toml`                     | New template (was HM `programs.starship.settings`)                |
| `configs/dot_config/lazygit/config.yml.tmpl`                | `~/.config/lazygit/config.yml`                | New template (was HM `programs.lazygit.settings`)                 |
| `configs/dot_config/borders/bordersrc.tmpl`                 | `~/.config/borders/bordersrc`                 | New template (was HM `jankyborders.nix`)                          |
| `configs/dot_config/btop/themes/catppuccin.theme.tmpl`      | `~/.config/btop/themes/catppuccin.theme`      | New template (was HM `btop.nix` generation)                       |
| `configs/dot_config/ghostty/config.tmpl`                    | `~/.config/ghostty/config`                    | New template (was HM `ghostty.nix` generation)                    |
| `configs/dot_config/ghostty/themes/colorscheme-normal.tmpl` | `~/.config/ghostty/themes/colorscheme-normal` | New template (was HM `ghostty.nix` generation)                    |
| `configs/dot_config/nushell/confs/colors.nu.tmpl`           | `~/.config/nushell/confs/colors.nu`           | New template (was HM `nushell.nix` generation)                    |
| `configs/dot_config/nvim/lua/colorscheme/palette.lua.tmpl`  | `~/.config/nvim/lua/colorscheme/palette.lua`  | New template (was HM `neovim.nix` generation)                     |
| `configs/dot_local/bin/nushell.tmpl`                        | `~/.local/bin/nushell`                        | New template (was HM `nushell.nix` launcher script)               |

After moves, remove empty directories: `configs/aerospace/`, `configs/bash/`, `configs/vim/`, `configs/git/`.

### 1b. Create colorscheme data file

Create `configs/.chezmoidata/colors.toml` from the values in `nix/colors.nix`. Keep the existing Nix naming convention (e.g., `red-soft`, `fg-secondary`) for now. Use quoted TOML keys for hyphenated names:

```toml
# configs/.chezmoidata/colors.toml
# Central colorscheme derived from Catppuccin Mocha.
# All template files reference these values via {{ .colors.* }}

[accent.dimmed]
coral = "f5e0dc"
salmon = "f2cdcd"
pink = "f5c2e7"
purple = "cba6f7"
red = "f38ba8"
"red-soft" = "eba0ac"
orange = "fab387"
yellow = "f9e2af"
green = "a6e3a1"
teal = "94e2d5"
cyan = "89dceb"
azure = "74c7ec"
blue = "89b4fa"
lilac = "b4befe"

[accent.normal]
coral = "f3b8b0"
salmon = "f0aaaa"
pink = "ee9dd4"
purple = "c490f0"
red = "ee668c"
"red-soft" = "e67c92"
orange = "f59a64"
yellow = "f0d57c"
green = "8ae28e"
teal = "6addca"
cyan = "6cd2ea"
azure = "67c0ea"
blue = "7aacf9"
lilac = "a29ffb"

[accent.bright]
coral = "f09898"
salmon = "ee8888"
pink = "e878c0"
purple = "b080f0"
red = "e84070"
"red-soft" = "e05878"
orange = "f08040"
yellow = "e8c84a"
green = "6de07a"
teal = "40d8c0"
cyan = "50c8e8"
azure = "5ab8e8"
blue = "6aa4f8"
lilac = "9080f8"

[structural]
fg = "cdd6f4"
"fg-secondary" = "bac2de"
"fg-muted" = "a6adc8"
"fg-faint" = "9399b2"
border = "7f849c"
"border-muted" = "6c7086"
"surface-raised" = "585b70"
surface = "45475a"
"surface-sunken" = "313244"

[background.catppuccin]
base = "1e1e2e"
mantle = "181825"
crust = "11111b"

[background.override]
base = "1E1E1E"
mantle = "141414"
crust = "0A0A0A"

[derived]
cursor = "CBD6F7"
"git-branch" = "f06040"
"git-state" = "f5906a" # hand-tuned, not from Catppuccin base palette
"diff-file" = "7aacf9"
"diff-hunk" = "f0d57c"
"diff-hint" = "9399b2"
"diff-separator" = "7f849c"
"diff-minus" = "660000"
"diff-minus-emph" = "8b3030"
"diff-plus" = "0e2e1e"
"diff-plus-emph" = "1a4a2a"
"diff-blame-1" = "3d3d4d"
"diff-blame-2" = "383846"
"diff-blame-3" = "34343f"
"diff-blame-4" = "303038"
"diff-blame-5" = "2c2c31"
"focus-dnd" = "6d7cff"
"focus-sleep" = "14b6a4"
"focus-reduce" = "db34f2"

[opacity]
background = 1
cursor = 0.85
```

Template usage:

- Non-hyphenated: `{{ .colors.accent.normal.red }}`
- Hyphenated: `{{ index .colors.accent.normal "red-soft" }}`

### 1c. Create template files (colorscheme injection)

Each file below replaces an HM module's config generation. The template reads values from `.chezmoidata/colors.toml` and renders the final config file when `chezmoi apply` runs.

#### `configs/dot_config/nushell/confs/colors.nu.tmpl`

Replaces the generation in `nix/home/nushell.nix` (lines 51-84).

```nushell
# Generated by chezmoi from .chezmoidata/colors.toml
# Do not edit — changes will be overwritten
# See docs/colorscheme.md for reference

let theme = {
    rosewater: "#{{ .colors.accent.normal.coral }}"
    flamingo: "#{{ .colors.accent.normal.salmon }}"
    pink: "#{{ .colors.accent.normal.pink }}"
    mauve: "#{{ .colors.accent.normal.purple }}"
    red: "#{{ .colors.accent.normal.red }}"
    maroon: "#{{ index .colors.accent.normal "red-soft" }}"
    peach: "#{{ .colors.accent.normal.orange }}"
    yellow: "#{{ .colors.accent.normal.yellow }}"
    green: "#{{ .colors.accent.normal.green }}"
    teal: "#{{ .colors.accent.normal.teal }}"
    sky: "#{{ .colors.accent.normal.cyan }}"
    sapphire: "#{{ .colors.accent.normal.azure }}"
    blue: "#{{ .colors.accent.normal.blue }}"
    lavender: "#{{ .colors.accent.normal.lilac }}"
    text: "#{{ .colors.structural.fg }}"
    subtext1: "#{{ index .colors.structural "fg-secondary" }}"
    subtext0: "#{{ index .colors.structural "fg-muted" }}"
    overlay2: "#{{ index .colors.structural "fg-faint" }}"
    overlay1: "#{{ .colors.structural.border }}"
    overlay0: "#{{ index .colors.structural "border-muted" }}"
    surface2: "#{{ index .colors.structural "surface-raised" }}"
    surface1: "#{{ .colors.structural.surface }}"
    surface0: "#{{ index .colors.structural "surface-sunken" }}"
    base: "#{{ .colors.background.override.base }}"
    mantle: "#{{ .colors.background.override.mantle }}"
    crust: "#{{ .colors.background.override.crust }}"
}
```

#### `configs/dot_config/nvim/lua/colorscheme/palette.lua.tmpl`

Replaces the generation in `nix/home/neovim.nix` (lines 38-115). Contains all 3 accent tiers + structural + background, same structure as the Nix-generated file.

```lua
-- Generated by chezmoi from .chezmoidata/colors.toml
-- Do not edit — changes will be overwritten
-- See docs/colorscheme.md for reference

local M = {}

M.accent = {
  dimmed = {
    coral    = "#{{ .colors.accent.dimmed.coral }}",
    salmon   = "#{{ .colors.accent.dimmed.salmon }}",
    pink     = "#{{ .colors.accent.dimmed.pink }}",
    purple   = "#{{ .colors.accent.dimmed.purple }}",
    red      = "#{{ .colors.accent.dimmed.red }}",
    ["red-soft"] = "#{{ index .colors.accent.dimmed "red-soft" }}",
    orange   = "#{{ .colors.accent.dimmed.orange }}",
    yellow   = "#{{ .colors.accent.dimmed.yellow }}",
    green    = "#{{ .colors.accent.dimmed.green }}",
    teal     = "#{{ .colors.accent.dimmed.teal }}",
    cyan     = "#{{ .colors.accent.dimmed.cyan }}",
    azure    = "#{{ .colors.accent.dimmed.azure }}",
    blue     = "#{{ .colors.accent.dimmed.blue }}",
    lilac    = "#{{ .colors.accent.dimmed.lilac }}",
  },
  normal = {
    coral    = "#{{ .colors.accent.normal.coral }}",
    salmon   = "#{{ .colors.accent.normal.salmon }}",
    pink     = "#{{ .colors.accent.normal.pink }}",
    purple   = "#{{ .colors.accent.normal.purple }}",
    red      = "#{{ .colors.accent.normal.red }}",
    ["red-soft"] = "#{{ index .colors.accent.normal "red-soft" }}",
    orange   = "#{{ .colors.accent.normal.orange }}",
    yellow   = "#{{ .colors.accent.normal.yellow }}",
    green    = "#{{ .colors.accent.normal.green }}",
    teal     = "#{{ .colors.accent.normal.teal }}",
    cyan     = "#{{ .colors.accent.normal.cyan }}",
    azure    = "#{{ .colors.accent.normal.azure }}",
    blue     = "#{{ .colors.accent.normal.blue }}",
    lilac    = "#{{ .colors.accent.normal.lilac }}",
  },
  bright = {
    coral    = "#{{ .colors.accent.bright.coral }}",
    salmon   = "#{{ .colors.accent.bright.salmon }}",
    pink     = "#{{ .colors.accent.bright.pink }}",
    purple   = "#{{ .colors.accent.bright.purple }}",
    red      = "#{{ .colors.accent.bright.red }}",
    ["red-soft"] = "#{{ index .colors.accent.bright "red-soft" }}",
    orange   = "#{{ .colors.accent.bright.orange }}",
    yellow   = "#{{ .colors.accent.bright.yellow }}",
    green    = "#{{ .colors.accent.bright.green }}",
    teal     = "#{{ .colors.accent.bright.teal }}",
    cyan     = "#{{ .colors.accent.bright.cyan }}",
    azure    = "#{{ .colors.accent.bright.azure }}",
    blue     = "#{{ .colors.accent.bright.blue }}",
    lilac    = "#{{ .colors.accent.bright.lilac }}",
  },
}

M.structural = {
  fg             = "#{{ .colors.structural.fg }}",
  ["fg-secondary"]   = "#{{ index .colors.structural "fg-secondary" }}",
  ["fg-muted"]       = "#{{ index .colors.structural "fg-muted" }}",
  ["fg-faint"]       = "#{{ index .colors.structural "fg-faint" }}",
  border         = "#{{ .colors.structural.border }}",
  ["border-muted"]   = "#{{ index .colors.structural "border-muted" }}",
  ["surface-raised"] = "#{{ index .colors.structural "surface-raised" }}",
  surface        = "#{{ .colors.structural.surface }}",
  ["surface-sunken"] = "#{{ index .colors.structural "surface-sunken" }}",
}

M.background = {
  bg           = "#{{ .colors.background.override.base }}",
  ["bg-secondary"] = "#{{ .colors.background.override.mantle }}",
  ["bg-deep"]      = "#{{ .colors.background.override.crust }}",
}

return M
```

#### `configs/dot_config/btop/themes/catppuccin.theme.tmpl`

Replaces the generation in `nix/home/btop.nix` (lines 30-118). All theme values from `colors.toml` (normal tier + structural + background.override). One hardcoded value: `meter_bg = "#282828"` (not from colorscheme, kept as-is from original).

```ini
# Generated by chezmoi from .chezmoidata/colors.toml
# Normal tier colorscheme
# See docs/colorscheme.md for reference

# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]="#{{ .colors.background.override.base }}"

# Main text color (fg)
theme[main_fg]="#{{ .colors.structural.fg }}"

# Title color for boxes (fg)
theme[title]="#{{ .colors.structural.fg }}"

# Highlight color for keyboard shortcuts (blue)
theme[hi_fg]="#{{ .colors.accent.normal.blue }}"

# Background color of selected item in processes box (surface-sunken)
theme[selected_bg]="#{{ index .colors.structural "surface-sunken" }}"

# Foreground color of selected item in processes box (blue)
theme[selected_fg]="#{{ .colors.accent.normal.blue }}"

# Color of inactive/disabled text (border-muted)
theme[inactive_fg]="#{{ index .colors.structural "border-muted" }}"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling (coral)
theme[graph_text]="#{{ .colors.accent.normal.coral }}"

# Background color of the percentage meters
theme[meter_bg]="#282828"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text (coral)
theme[proc_misc]="#{{ .colors.accent.normal.coral }}"

# CPU, Memory, Network, Proc box outline colors
theme[cpu_box]="#{{ .colors.accent.normal.purple }}"
theme[mem_box]="#{{ .colors.accent.normal.green }}"
theme[net_box]="#{{ .colors.accent.normal.blue }}"
theme[proc_box]="#{{ .colors.accent.normal.orange }}"

# Box divider line and small boxes line color (border-muted)
theme[div_line]="#{{ index .colors.structural "border-muted" }}"

# Temperature graph color (Green -> Yellow -> Red)
theme[temp_start]="#{{ .colors.accent.normal.green }}"
theme[temp_mid]="#{{ .colors.accent.normal.yellow }}"
theme[temp_end]="#{{ .colors.accent.normal.red }}"

# CPU graph colors (Teal -> Azure -> Lilac)
theme[cpu_start]="#{{ .colors.accent.normal.teal }}"
theme[cpu_mid]="#{{ .colors.accent.normal.azure }}"
theme[cpu_end]="#{{ .colors.accent.normal.lilac }}"

# Mem/Disk free meter (Purple -> Lilac -> Blue)
theme[free_start]="#{{ .colors.accent.normal.purple }}"
theme[free_mid]="#{{ .colors.accent.normal.lilac }}"
theme[free_end]="#{{ .colors.accent.normal.blue }}"

# Mem/Disk cached meter (Azure -> Blue -> Lilac)
theme[cached_start]="#{{ .colors.accent.normal.azure }}"
theme[cached_mid]="#{{ .colors.accent.normal.blue }}"
theme[cached_end]="#{{ .colors.accent.normal.lilac }}"

# Mem/Disk available meter (Orange -> Red-soft -> Red)
theme[available_start]="#{{ .colors.accent.normal.orange }}"
theme[available_mid]="#{{ index .colors.accent.normal "red-soft" }}"
theme[available_end]="#{{ .colors.accent.normal.red }}"

# Mem/Disk used meter (Green -> Teal -> Cyan)
theme[used_start]="#{{ .colors.accent.normal.green }}"
theme[used_mid]="#{{ .colors.accent.normal.teal }}"
theme[used_end]="#{{ .colors.accent.normal.cyan }}"

# Download graph colors (Orange -> Red-soft -> Red)
theme[download_start]="#{{ .colors.accent.normal.orange }}"
theme[download_mid]="#{{ index .colors.accent.normal "red-soft" }}"
theme[download_end]="#{{ .colors.accent.normal.red }}"

# Upload graph colors (Green -> Teal -> Cyan)
theme[upload_start]="#{{ .colors.accent.normal.green }}"
theme[upload_mid]="#{{ .colors.accent.normal.teal }}"
theme[upload_end]="#{{ .colors.accent.normal.cyan }}"

# Process box color gradient for threads, mem and cpu usage (Azure -> Lilac -> Purple)
theme[process_start]="#{{ .colors.accent.normal.azure }}"
theme[process_mid]="#{{ .colors.accent.normal.lilac }}"
theme[process_end]="#{{ .colors.accent.normal.purple }}"
```

#### `configs/dot_config/ghostty/config.tmpl`

Replaces the generation in `nix/home/ghostty.nix` (lines 15-77). Ghostty config with colors injected. Ghostty handles per-OS config itself (macOS-specific settings like `macos-titlebar-style` are ignored on Linux), so the same config file works on both platforms.

```ini
# Documentation:  https://ghostty.org/docs/config

# --- SHELL ---
shell-integration-features = ssh-env, no-cursor, sudo, ssh-terminfo
command = "~/.local/bin/nushell --login"

# --- TEXT ---
font-family = "JetBrainsMono Nerd Font Mono"
font-size = 17
font-feature = +liga
font-thicken = true
link-url = true

# --- WINDOW ---
macos-titlebar-style = hidden
macos-titlebar-proxy-icon = hidden
macos-window-buttons = hidden
background-opacity = {{ .colors.opacity.background }}
background-blur = true
window-padding-balance = true

# --- COLORS ---
theme = colorscheme-normal
cursor-color = #{{ .colors.derived.cursor }}
cursor-text = #{{ .colors.background.override.base }}
bold-color = bright

# --- CURSOR ---
adjust-cursor-thickness = +6
adjust-cursor-height = -4
cursor-opacity = {{ .colors.opacity.cursor }}
cursor-style-blink = false
cursor-style = block
mouse-hide-while-typing = true
custom-shader = shaders/cursor_trail.glsl
custom-shader-animation = always

# --- BELL & NOTIFICATIONS ---
bell-features = system, attention, no-title, no-audio, no-border
desktop-notifications = true
app-notifications = config-reload, clipboard-copy

# --- QUIT BEHAVIOR ---
confirm-close-surface = false
quit-after-last-window-closed = true

# --- CLIPBOARD BEHAVIOR ---
clipboard-read = allow
clipboard-write = allow
keybind = shift+enter=text:\x1b\r
clipboard-trim-trailing-spaces = true

# --- APP ICON ---
macos-icon = custom

# --- QUICK TERMINAL ---
keybind = super+e=toggle_quick_terminal
quick-terminal-position = center
quick-terminal-size = 60%,80%
quick-terminal-autohide = true
quick-terminal-animation-duration = 0.01
```

#### `configs/dot_config/ghostty/themes/colorscheme-normal.tmpl`

Replaces the generation in `nix/home/ghostty.nix` (lines 84-111). ANSI palette: normal tier for 0-7, bright tier for 8-15. Uses `background.catppuccin` for the terminal background (not `background.override` — the override is for other tools like btop/neovim that need a different base).

```ini
# Generated by chezmoi from .chezmoidata/colors.toml
# ANSI palette: normal tier for 0-7, bright tier for 8-15

background = #{{ .colors.background.catppuccin.base }}
foreground = #{{ .colors.structural.fg }}
cursor-color = #{{ .colors.derived.cursor }}
cursor-text = #{{ .colors.background.override.base }}
selection-background = #{{ .colors.structural.surface }}
selection-foreground = #{{ .colors.structural.fg }}

palette = 0=#{{ index .colors.structural "surface-sunken" }}
palette = 1=#{{ .colors.accent.normal.red }}
palette = 2=#{{ .colors.accent.normal.green }}
palette = 3=#{{ .colors.accent.normal.yellow }}
palette = 4=#{{ .colors.accent.normal.blue }}
palette = 5=#{{ .colors.accent.normal.pink }}
palette = 6=#{{ .colors.accent.normal.teal }}
palette = 7=#{{ .colors.structural.fg }}
palette = 8=#{{ .colors.structural.surface }}
palette = 9=#{{ .colors.accent.bright.red }}
palette = 10=#{{ .colors.accent.bright.green }}
palette = 11=#{{ .colors.accent.bright.yellow }}
palette = 12=#{{ .colors.accent.bright.blue }}
palette = 13=#{{ .colors.accent.bright.pink }}
palette = 14=#{{ .colors.accent.bright.teal }}
palette = 15=#{{ index .colors.structural "fg-secondary" }}
```

#### `configs/dot_config/git/config.tmpl`

Replaces `nix/home/git.nix` (programs.git.settings). Git config with identity and delta colors injected.

```ini
[user]
    name = {{ .gitName }}
    email = {{ .gitEmail }}

[init]
    defaultBranch = main

[core]
    excludesfile = ~/.gitignore
    pager = delta -s
    editor = nvim

[pull]
    rebase = false

[color]
    ui = auto
    status = auto
    diff = auto
    branch = auto

[merge]
    tool = nvim
    conflictStyle = zdiff3

[mergetool]
    keepBackup = false
    prompt = false

[mergetool "nvim"]
    cmd = "MERGED=\"$MERGED\" nvim -d -c \"wincmd l\" -c \"norm! ]c\" \"$LOCAL\" \"$MERGED\" \"$REMOTE\""

[delta]
    line-numbers = true
    navigate = true
    hyperlinks = true
    paging = auto
    dark = true
    word-diff = true
    true-color = always
    width = variable
    syntax-theme = Catppuccin Mocha
    minus-style = "syntax #{{ index .colors.derived "diff-minus" }}"
    minus-emph-style = "syntax #{{ index .colors.derived "diff-minus-emph" }}"
    plus-style = "syntax #{{ index .colors.derived "diff-plus" }}"
    plus-emph-style = "syntax #{{ index .colors.derived "diff-plus-emph" }}"
    zero-style = "syntax"
    line-numbers-minus-style = #{{ .colors.accent.normal.red }}
    line-numbers-plus-style = #{{ .colors.accent.normal.green }}
    line-numbers-zero-style = #{{ .colors.structural.border }}
    commit-style = "#{{ .colors.accent.normal.orange }} bold"
    commit-decoration-style = "#{{ .colors.structural.surface }} ol"
    file-style = #{{ index .colors.derived "diff-file" }}
    file-decoration-style = ""
    hunk-header-style = "#{{ index .colors.derived "diff-hunk" }} bold"
    hunk-header-decoration-style = ""
    hunk-header-file-style = #{{ index .colors.derived "diff-file" }}
    hunk-header-line-number-style = #{{ index .colors.derived "diff-hunk" }}
    inline-hint-style = #{{ index .colors.derived "diff-hint" }}
    blame-palette = "{{ index .colors.derived "diff-blame-1" }} {{ index .colors.derived "diff-blame-2" }} {{ index .colors.derived "diff-blame-3" }} {{ index .colors.derived "diff-blame-4" }} {{ index .colors.derived "diff-blame-5" }}"
    blame-code-style = "syntax"
    blame-separator-style = #{{ index .colors.derived "diff-separator" }}
    blame-separator-format = "{n:^4} │"
```

#### `configs/dot_config/starship.toml.tmpl`

Replaces `nix/home/starship.nix` (programs.starship.settings). Full starship config with palette colors from `colors.toml` (bright tier + structural + derived). Note: `git-state` is a hand-tuned color (`f5906a`) not from the Catppuccin base palette — it lives in `[derived]` in `colors.toml`.

Starship format strings use `${}` for shell variable interpolation — Go templates use `{{ }}` — so no escaping conflicts. But the Nix module escapes braces (`$\{count\}`) because Nix uses `${}` for interpolation. In the chezmoi template, `${count}` is written directly since Go templates don't interfere with `${}`.

```toml
# Generated by chezmoi from .chezmoidata/colors.toml
# Do not edit — changes will be overwritten
# See docs/colorscheme.md for reference

"$schema" = "https://starship.rs/config-schema.json"
add_newline = true
scan_timeout = 10
palette = "catppuccin_mocha"

format = " $directory$git_branch$git_status$git_state$nix_shell$fill $status$hostname$cmd_duration$sudo$memory_usage$time $line_break  $character"

[fill]
disabled = false
style = "spacer_color"
symbol = "─"

[character]
disabled = false
success_symbol = "[➔](bold green)"
error_symbol = "[➔](bold red)"

[directory]
disabled = false
truncation_length = 1
truncation_symbol = ""
style = "dir_color"
format = "[ $path]($style) "

[git_branch]
disabled = false
style = "git_orange"
symbol = "󰊢"
format = "[─](spacer_color) [$symbol $branch]($style) "

[git_status]
disabled = false
ahead = "↑${count} "
behind = "↓${count} "
diverged = "↓${ahead_count}↑${behind_count} "
modified = "!${count} "
untracked = "?${count} "
stashed = "*${count} "
conflicted = "~${count} "
staged = "+${count} "
deleted = "-${count} "
format = "[$ahead_behind](git_ahead_behind)[$stashed](git_stashed)[$conflicted](git_conflicted)[$staged](git_staged)[$deleted](git_deleted)[$modified](git_modified)[$untracked](git_untracked)"

[git_state]
disabled = false
style = "git_state_color"
format = "[─](spacer_color) [󰚖 $state ($progress_current/$progress_total)]($style) "
rebase = "REBASE"
merge = "MERGE"
revert = "REVERT"
cherry_pick = "CHERRY"
bisect = "BISECT"
am = "AM"
am_or_rebase = "AM/REBASE"

[cmd_duration]
disabled = false
style = "timer_color"
format = "[󰔛 $duration]($style) [─](spacer_color) "

[time]
disabled = false
style = "clock_color"
time_format = "%I:%M%P"
format = "[󰔛 $time]($style)"

[nix_shell]
disabled = false
symbol = "󱄅"
style = "nix_color"
pure_msg = "pure"
impure_msg = "impure"
unknown_msg = "dev"
heuristic = true
format = "[─](spacer_color) [$symbol $name \\[$state\\]](nix_color) "

[memory_usage]
disabled = false
threshold = 70
symbol = ""
style = "memory_color"
format = "[$symbol $ram_pct]($style) [─](spacer_color) "

[status]
disabled = false
style = "red"
symbol = ""
recognize_signal_code = false
format = "[$symbol $status]($style) [─](spacer_color) "

[hostname]
disabled = false
ssh_only = true
trim_at = "."
style = "bold yellow"
format = "[󰒋 $hostname]($style) [─](spacer_color) "

[sudo]
disabled = false
format = "[SUDO]($style) [─](spacer_color) "
style = "bold red"

[palettes.catppuccin_mocha]
spacer_color = "#{{ .colors.structural.surface }}"
timer_color = "#{{ .colors.accent.bright.yellow }}"
dir_color = "#{{ .colors.accent.bright.blue }}"
clock_color = "#{{ .colors.accent.bright.azure }}"
memory_color = "#{{ .colors.accent.bright.salmon }}"
nix_color = "#{{ .colors.accent.bright.purple }}"
git_orange = "#{{ index .colors.derived "git-branch" }}"
git_state_color = "#{{ index .colors.derived "git-state" }}"
git_modified = "#{{ .colors.accent.bright.yellow }}"
git_untracked = "#{{ .colors.accent.bright.blue }}"
git_ahead_behind = "#{{ .colors.accent.bright.green }}"
git_staged = "#{{ .colors.accent.bright.green }}"
git_unstaged = "#{{ .colors.accent.bright.blue }}"
git_stashed = "#{{ .colors.accent.bright.purple }}"
git_conflicted = "#{{ .colors.accent.bright.red }}"
git_deleted = "#{{ .colors.accent.bright.red }}"
```

#### `configs/dot_config/lazygit/config.yml.tmpl`

Replaces `nix/home/lazygit.nix` (programs.lazygit.settings). Full lazygit config with theme colors from `colors.toml` (normal tier + structural). The Nix module uses `programs.lazygit.settings` which translates to YAML — the chezmoi template writes YAML directly with Go template color injection.

```yaml
# Generated by chezmoi from .chezmoidata/colors.toml
# Do not edit — changes will be overwritten
# See docs/colorscheme.md for reference

notARepository: quit
disableStartupPopups: true
promptToReturnFromSubprocess: false

git:
  autoFetch: false
  disableForcePushing: true
  diffRenderers:
    - command: "delta --paging=never"

os:
  editPreset: nvim
  editAtLine: "nvim {{filename}} +{{line}}"
  openDirInEditor: "nvim {{filename}}"

gui:
  expandFocusedSidePanel: true
  tabWidth: 2
  enlargedSideViewLocation: left
  sidePanelWidth: 0.25
  expandedSidePanelWeight: 3
  showRootItemInFileTree: false
  fileTreeSortOrder: foldersFirst
  showBottomLine: false
  showCommandLog: false
  nerdFontsVersion: "3"
  showDivergenceFromBaseBranch: arrowAndNumber
  border: rounded
  statusPanelView: allBranchesLog

  spinner:
    rate: 100
    frames:
      - "⠋"
      - "⠙"
      - "⠹"
      - "⠸"
      - "⠼"
      - "⠴"
      - "⠦"
      - "⠧"
      - "⠇"
      - "⠏"

  theme:
    activeBorderColor:
      - "#{{ .colors.accent.normal.orange }}"
      - bold
    inactiveBorderColor:
      - "#{{ index .colors.structural "fg-muted" }}"
    optionsTextColor:
      - "#{{ .colors.accent.normal.blue }}"
    selectedLineBgColor:
      - "#{{ index .colors.structural "surface-sunken" }}"
    cherryPickedCommitBgColor:
      - "#{{ .colors.structural.surface }}"
    cherryPickedCommitFgColor:
      - "#{{ .colors.accent.normal.orange }}"
    unstagedChangesColor:
      - "#{{ .colors.accent.normal.red }}"
    defaultFgColor:
      - "#{{ .colors.structural.fg }}"
    searchingActiveBorderColor:
      - "#{{ .colors.accent.normal.yellow }}"
    inactiveViewSelectedLineBgColor:
      - "#{{ index .colors.structural "surface-raised" }}"
    markedBaseCommitFgColor:
      - "#{{ .colors.accent.normal.purple }}"
    markedBaseCommitBgColor:
      - "#{{ .colors.structural.surface }}"

  branchColorPatterns:
    "^(main|master)$": "#{{ .colors.accent.normal.blue }}"
    "^develop$": "#{{ .colors.accent.normal.teal }}"
    "^(feat|feature)/": "#{{ .colors.accent.normal.green }}"
    "^fix/": "#{{ .colors.accent.normal.orange }}"
    "^(chore|docs|refactor|test|ci)/": "#{{ .colors.accent.normal.purple }}"

  authorColors:
    "*": "#{{ .colors.accent.normal.lilac }}"
```

#### `configs/dot_config/borders/bordersrc.tmpl`

Replaces `nix/home/jankyborders.nix`. ARGB colors via `0xff` prefix:

```bash
#!/bin/bash

options=(
  style=round
  width=5.0
  hidpi=off
  active_color=0xff{{ .colors.accent.dimmed.purple }}
  inactive_color=0xff{{ .colors.structural.surface }}
)

borders "${options[@]}"
```

#### `configs/dot_local/bin/nushell.tmpl`

Replaces the nushell launcher from `nix/home/nushell.nix`. Platform-conditional brew path:

```sh
#!/bin/sh -l
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$HOME/.nix-profile/bin{{ if eq .chezmoi.os "darwin" }}:/opt/homebrew/bin{{ else if eq .chezmoi.os "linux" }}:/home/linuxbrew/.linuxbrew/bin{{ end }}:$PATH"
exec nu --experimental-options='native-clip' "$@"
```

### 1d. Create chezmoi infrastructure files

#### `configs/.chezmoi.toml.tmpl`

Per-machine config generator. Run `chezmoi init --source ~/dotfiles/configs` to create `~/.config/chezmoi/chezmoi.toml` from this template.

```
{{- $username := promptString "username" -}}
{{- $gitName := promptString "gitName" "Spencer Christensen" -}}
{{- $gitEmail := promptString "gitEmail" "134820811+FreeSamples00@users.noreply.github.com" -}}

[data]
    username = {{ $username | quote }}
    gitName = {{ $gitName | quote }}
    gitEmail = {{ $gitEmail | quote }}
```

#### `configs/.chezmoiignore.tmpl`

Platform-conditional file deployment. macOS-only files are ignored on Linux. Ghostty is deployed on both platforms (it handles per-OS config itself). Karabiner automatic backups are machine-specific and should not be deployed.

```
{{ if not (eq .chezmoi.os "darwin") }}
dot_aerospace.toml
dot_config/karabiner/
dot_config/sketchybar/
dot_config/borders/
{{ end }}

# Always ignore: machine-specific backups, not configs
dot_config/karabiner/automatic_backups/
```

#### `configs/run_after_bat-cache.sh`

Activation hook — runs after `chezmoi apply` when the script content changes.

```sh
#!/bin/sh
if command -v bat >/dev/null 2>&1; then
    bat cache --build
fi
```

#### `configs/run_after_fc-cache.sh`

```sh
#!/bin/sh
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -rf
fi
```

### 1e. Create SSH config

#### `configs/dot_ssh/config`

Static file (not a template). Contains global SSH settings only — no host-specific entries (university hosts are managed elsewhere):

```
Host *
  SendEnv COLORTERM
  IdentityFile ~/.ssh/keys/yubikey_ssh
  IdentityAgent none
```

### 1f. No cleanup needed for HM-generated files

The following files were previously generated by HM (they exist as symlinks in `~/.config/` pointing to `/nix/store`, but do NOT exist in the `configs/` repo directory). There is nothing to remove from `configs/` — the `.tmpl` files are new creations:

- `btop/themes/catppuccin.theme` — was HM-generated, now becomes `catppuccin.theme.tmpl` (new file)
- `ghostty/config` — was HM-generated, now becomes `config.tmpl` (new file)
- `ghostty/themes/colorscheme-normal` — was HM-generated, now becomes `colorscheme-normal.tmpl` (new file)

The HM symlinks in `~/.config/` are removed in Phase 4c.

### 1g. Update `.gitignore`

Update the btop theme path from `configs/btop/themes/catppuccin.theme` to `configs/dot_config/btop/themes/catppuccin.theme` (the generated output, not the `.tmpl` source).

---

## Phase 2: Strip Nix HM Config Modules, Move Flake to `nix/`

### 2a. Delete HM config modules

Delete the entire `nix/home/` directory (all 16 modules):

- `aerospace.nix`, `bash.nix`, `bat.nix`, `btop.nix`, `ghostty.nix`, `git.nix`, `jankyborders.nix`, `karabiner.nix`, `lazygit.nix`, `neovim.nix`, `nushell.nix`, `opencode.nix`, `sketchybar.nix`, `starship.nix`, `vim.nix`, `zellij.nix`

### 2b. Delete `nix/colors.nix`

Replaced by `configs/.chezmoidata/colors.toml`.

### 2c. Move flake to `nix/`

- `git mv flake.nix nix/flake.nix`
- `git mv flake.lock nix/flake.lock`

### 2d. Update `nix/flake.nix`

Update all paths to be relative to `nix/`:

- `./profiles/minimal.nix` (same path, since profiles are in `nix/profiles/`)
- `./darwin/system.nix` (was `./nix/darwin/system.nix`)
- `./darwin/brew.nix` (was `./nix/darwin/brew.nix`)
- `./darwin/services.nix` (was `./nix/darwin/services.nix`)
- `./profiles/macos.nix` (same path, since profiles are in `nix/profiles/`)

The `macos.nix` profile is needed for the `darwinConfigurations` output — it provides macOS-specific packages. Currently it does not exist in the repo (the `nix/profiles/` directory does not exist yet — see Phase 2f). It needs to be **created** as a packages-only profile, not modified from an existing file.

Remove from `flake.nix` specialArgs:

- `colors` — no longer needed (chezmoi handles colorscheme)
- `gitName`, `gitEmail` — no longer needed (chezmoi handles identity)

Keep in specialArgs:

- `username` — needed for `home.username`
- `homeDirectory` — needed for `home.homeDirectory`

### 2e. Update `nix/variables.nix`

Remove `gitName` and `gitEmail` (now handled by chezmoi). Keep `username` and `system`:

```nix
# Per-deployment configuration. Edit these values before deploying to a new machine.
{
  username = "scc";
  system = "aarch64-darwin";
}
```

### 2f. Create Nix profiles (packages only)

The `nix/profiles/` directory does not currently exist. These files need to be **created from scratch** as packages-only profiles. No HM config module imports, no `home.activation` hooks, no config deployment — only package lists.

#### `nix/profiles/minimal.nix`

```nix
{ config, pkgs, username, homeDirectory, ... }:
{
  home = { inherit username homeDirectory; stateVersion = "25.05"; };
  programs.home-manager.enable = true;
  xdg.enable = true;
  xdg.configHome = "${config.home.homeDirectory}/.config";

  home.packages = with pkgs; [
    vim git bash coreutils curl wget tree less rsync openssh
  ];
}
```

No `../nix/home/` imports. No config modules.

#### `nix/profiles/default.nix`

```nix
{pkgs, ...}: {
  imports = [ ./minimal.nix ];

  home.packages = with pkgs; [
    python3 nodejs gcc go rustup stylua shellcheck jq pandoc shfmt
    lua-language-server taplo prettier just gh ripgrep fd fzf eza dust bat
    btop zellij jc nmap imagemagick pipx hugo catimg exiftool transmission_4 llvm
    python3Packages.pygments delta
    nerd-fonts.jetbrains-mono nerd-fonts.space-mono sketchybar-app-font
    glow hyperfine figlet uv pre-commit
  ];

  fonts.fontconfig.enable = true;
}
```

No HM config imports. No `home.activation` hooks (chezmoi handles activation). Keep `fonts.fontconfig.enable = true` so Nix store fonts are registered with fontconfig on Nix machines. Chezmoi's `run_after_fc-cache.sh` handles font cache rebuild when configs change.

#### `nix/profiles/security.nix`

```nix
{pkgs, ...}: {
  imports = [ ./default.nix ];

  home.packages = with pkgs; [
    john noseyparker aircrack-ng pv lolcat mpv p7zip trufflehog
  ];
}
```

Imports `default.nix` for the full package set, adds security tools.

#### `nix/profiles/macos.nix`

```nix
{pkgs, ...}: {
  imports = [ ./default.nix ];

  home.packages = with pkgs; [
    pngpaste yubikey-manager yubico-piv-tool opencode libfido2
  ];
}
```

Imports `default.nix` for the full package set, adds macOS-specific packages. No HM config imports — chezmoi handles all config deployment.

---

## Phase 3: Update Justfiles

### 3a. Root `.justfile`

```just
_default:
    @just --unsorted --list

# Dotfiles: deploy configs via chezmoi
[group('dot')]
mod dot 'dot.just'

# Packages: Nix commands (deploy, build, rollback, etc.)
[group('pack')]
mod pack 'nix/nix.just'

# Brew: fallback package installation
[group('pack')]
mod brew 'brew.just'

# Neovim configuration tasks
[group: 'tools']
mod nvim 'configs/dot_config/nvim/.nvim.just'

# Sketchybar configuration tasks
[group: 'tools']
mod skbar 'configs/dot_config/sketchybar/.sketchybar.just'
```

### 3b. `dot.just` (repo root)

```just
_default:
    @just --unsorted --list dot

# Apply configs (deploy all dotfiles via chezmoi)
apply:
    chezmoi apply --source ~/dotfiles/configs

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
```

### 3c. `brew.just` (repo root)

```just
_default:
    @just --unsorted --list brew

# Install packages from Brewfile (fallback for non-Nix machines)
install:
    brew bundle install --file ~/dotfiles/data/Brewfile

# Update brew packages
update:
    brew bundle update --file ~/dotfiles/data/Brewfile

# List installed packages from Brewfile
list:
    brew bundle list --file ~/dotfiles/data/Brewfile
```

### 3d. `nix/nix.just` (update flake paths)

Flake is now at `nix/flake.nix`. From `nix/nix.just` (same directory), `--flake .` references `nix/flake.nix`:

```just
_default:
    @just --unsorted --list pack

# Dry-build: list build results
[group('build')]
dry profile='default':
    {{ if profile == 'mac' { 'nix build "./#darwinConfigurations.scc-mac.system" --dry-run --no-link' } else { 'nix build "./#homeConfigurations.scc-' + profile + '.activationPackage" --dry-run --no-link' } }}

# Build: build, no switch
[group('build')]
build profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild build --flake "./#scc-mac"' } else { 'home-manager build --flake "./#scc-{{ profile }}"' } }}

# Deploy: build and switch
[group('deploy')]
deploy profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild switch --flake "./#scc-mac"' } else { 'home-manager switch --flake "./#scc-{{ profile }}" -b backup' } }}

# Rollback to previous generation
[group('deploy')]
rollback profile='default':
    {{ if profile == 'mac' { 'sudo darwin-rebuild rollback' } else { 'home-manager rollback' } }}

# List generations
[group('deploy')]
generations profile='default':
    {{ if profile == 'mac' { 'darwin-rebuild --list-generations' } else { 'home-manager generations' } }}

# Update flake inputs
[group('maintenance')]
update:
    nix flake update .

# Garbage collect old generations (keep last N days)
[group('maintenance')]
gc keep='5':
    nix-collect-garbage --delete-older-than {{ keep }}d

# Evaluate a Nix expression
[group('dev')]
eval expr:
    nix eval --impure --expr '{{ expr }}'

# Check flake for errors
[group('dev')]
check:
    nix flake check .
```

### 3e. Tool justfile module paths

The `.justfile` module paths for nvim and sketchybar change:

- `configs/neovim/.nvim.just` → `configs/dot_config/nvim/.nvim.just`
- `configs/sketchybar/.sketchybar.just` → `configs/dot_config/sketchybar/.sketchybar.just`

The `.nvim.just` and `.sketchybar.just` files themselves don't need changes — they use `.` (current directory) for their commands, which will resolve to the new locations.

---

## Phase 4: System Transition

### 4a. Redeploy Nix first (installs chezmoi + removes HM config symlinks)

```bash
sudo darwin-rebuild switch --flake ./nix#scc-mac
```

This does three things at once:

1. Installs **chezmoi** as a Nix package (added to `minimal.nix`, available in all profiles)
2. Removes all HM-managed config symlinks (the HM modules are deleted, so this rebuild no longer deploys configs)
3. Deploys packages + system settings + services + brew management

After this step, `chezmoi` is on PATH (via Nix profile) and all old HM config symlinks are gone. The current terminal session stays alive — just don't open a new terminal until step 4d.

### 4b. Initialize chezmoi

```bash
chezmoi init --source ~/dotfiles/configs
```

This generates `~/.config/chezmoi/chezmoi.toml` from `configs/.chezmoi.toml.tmpl`, prompting for username, gitName, gitEmail.

### 4c. Review what chezmoi will deploy

```bash
chezmoi diff --source ~/dotfiles/configs
```

Dry run — verify templates render correctly before applying. Check that color values appear in ghostty config, git config, starship, etc.

### 4d. Apply chezmoi

```bash
chezmoi apply --source ~/dotfiles/configs
```

This deploys all config files, renders all `.tmpl` templates with colorscheme values, runs activation hooks (`bat cache --build`, `fc-cache -rf`), and skips macOS-only files on non-darwin platforms.

### 4e. Fix user shell (if needed)

The user shell was set to `~/.local/bin/nushell` by nix-darwin. After chezmoi deploys the launcher, this should work. Verify:

```bash
dscl . -read /Users/scc UserShell
# Should be: /Users/scc/.local/bin/nushell
```

If the old stow symlink at `/usr/local/bin/nushell` is still present, it can be removed:

```bash
sudo rm /usr/local/bin/nushell
```

The chezmoi-deployed launcher at `~/.local/bin/nushell` replaces it.

### Non-Nix machines (university Linux)

On machines without Nix (e.g., `argolis`), the sequence is different — chezmoi is installed via Linuxbrew, and there are no HM symlinks to remove:

```bash
brew bundle install --file ~/dotfiles/data/Brewfile   # installs chezmoi + all packages
chezmoi init --source ~/dotfiles/configs
chezmoi diff --source ~/dotfiles/configs
chezmoi apply --source ~/dotfiles/configs
```

---

## Phase 5: Test and Verify

### 5a. Config deployment verification

| Check            | Command                                                   | Expected                                                           |
| ---------------- | --------------------------------------------------------- | ------------------------------------------------------------------ |
| Nushell launches | `~/.local/bin/nushell --login`                            | Nushell starts with correct prompt                                 |
| Nushell colors   | `theme.nu` loads `colors.nu`                              | Colors from `colors.toml` are applied                              |
| Neovim loads     | `nvim`                                                    | Opens with Catppuccin theme                                        |
| Neovim palette   | `:lua print(vim.inspect(require("colorscheme.palette")))` | All accent tiers present                                           |
| Ghostty config   | `cat ~/.config/ghostty/config`                            | Generated config with colors                                       |
| Ghostty theme    | `cat ~/.config/ghostty/themes/colorscheme-normal`         | ANSI palette with normal/bright tiers                              |
| Starship prompt  | `starship config`                                         | Prompt renders with colors                                         |
| Git config       | `git config --list`                                       | Name, email, delta colors present                                  |
| Lazygit          | `lazygit`                                                 | Opens with Catppuccin theme                                        |
| Btop             | `btop`                                                    | Opens with generated theme                                         |
| Jankyborders     | `borders` running                                         | Purple active border, surface inactive                             |
| Sketchybar       | `sketchybar --query bar`                                  | Bar running with correct items                                     |
| Aerospace        | `aerospace list-workspaces`                               | Workspaces listed                                                  |
| Bat cache        | `bat --list-themes`                                       | Custom colorscheme theme present                                   |
| Fonts            | `fc-list \| grep "JetBrainsMono"`                         | Nerd Font installed (via Nix on Nix machines, via brew on non-Nix) |
| SSH config       | `ssh -G argolis`                                          | Correct hostname, user, RemoteCommand                              |

### 5b. Nix packages verification

| Check                | Command                 | Expected                |
| -------------------- | ----------------------- | ----------------------- |
| Nix packages on PATH | `which gh`              | Nix profile path        |
| Openssh with FIDO2   | `ssh -V`                | nixpkgs openssh version |
| Delta installed      | `which delta`           | Nix profile path        |
| Fonts in Nix store   | `fc-list \| grep "Nix"` | Fonts from Nix store    |

### 5c. macOS system verification

| Check            | Command                                            | Expected        |
| ---------------- | -------------------------------------------------- | --------------- |
| Dark mode        | `defaults read NSGlobalDomain AppleInterfaceStyle` | "Dark"          |
| Dock autohide    | `defaults read com.apple.dock autohide`            | 1               |
| Menu bar hidden  | `defaults read NSGlobalDomain _HIHideMenuBar`      | 1               |
| Touch ID         | `sudo -k && sudo -n true`                          | Touch ID prompt |
| Services running | `launchctl list \| grep sketchybar`                | Loaded          |

### 5d. University machine test (future)

On `argolis` (or similar):

1. Clone repo: `git clone <repo> ~/dotfiles`
2. Install packages: `brew bundle install --file ~/dotfiles/data/Brewfile` (installs chezmoi + all tools via Linuxbrew)
3. Initialize: `chezmoi init --source ~/dotfiles/configs`
4. Apply: `chezmoi apply --source ~/dotfiles/configs`
5. Verify nushell, nvim, git config all work

---

## Implementation Ordering

Execute phases in order. Each phase depends on the previous one.

1. **Phase 1** (chezmoi structure) — all file renames and template creation in `configs/`
2. **Phase 2** (Nix cleanup) — delete HM modules, move flake, update profiles
3. **Phase 3** (justfiles) — update root `.justfile`, create `dot.just`, `brew.just`, update `nix/nix.just`
4. **Phase 4** (system transition) — redeploy Nix (installs chezmoi + removes HM symlinks), init chezmoi, apply
5. **Phase 5** (test) — verify all configs, packages, and system settings

### File change summary

| Action                  | Count  |
| ----------------------- | ------ |
| Created (new files)     | 23     |
| Moved (git mv)          | 18     |
| Modified                | 5      |
| Deleted                 | 21     |
| **Total files touched** | **67** |

### Risk areas

1. **Template syntax errors** — Go template syntax is different from Nix expressions. Each `.tmpl` file needs careful conversion. Test with `chezmoi diff` before `chezmoi apply`.

2. **Config gap during Phase 4** — `darwin-rebuild switch` (4a) removes HM config symlinks. Between 4a and 4d, configs don't exist. The current terminal session stays alive, but opening a new terminal won't work until 4d completes. Don't close the active terminal.

3. **Flake path change** — moving `flake.nix` from repo root to `nix/` changes all `--flake` paths in `nix.just`. Need to test `just pack dry mac` before `just pack deploy mac`.

4. **Nix-darwin reconfiguration** — the first `darwin-rebuild switch` with the new flake removes HM-managed config symlinks. Chezmoi must be applied immediately after to deploy replacements. The gap is brief (a few commands, no reboot).

5. **Font cache** — chezmoi's `run_after_fc-cache.sh` runs on all machines. On Nix machines, HM's `fonts.fontconfig.enable = true` also manages font cache. Verify no conflict.

6. **`colors.toml` hyphenated keys** — Go templates need `{{ index .colors.accent.normal "red-soft" }}` for hyphenated keys. This is more verbose than Nix's `a.red-soft`. Consider renaming to non-hyphenated names in a future cleanup (e.g., Catppuccin standard names: `maroon` instead of `red-soft`).

### Post-migration cleanup (optional, future)

- Rename hyphenated color keys to Catppuccin standard names (e.g., `red-soft` → `maroon`, `fg-secondary` → `subtext1`)
- Add chezmoi encryption for sensitive files (SSH keys, API tokens)
- Create a `run_onchange_macos-setup.sh.tmpl` for one-time macOS system defaults (as a backup to nix-darwin)
- Add chezmoi `run_` scripts for brew cask installation on non-Nix machines
- Consider dropping nix-darwin entirely if macOS system settings prove stable without it
