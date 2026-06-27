---
name: dotfiles-context
description: CRITICAL - Load for config file operations. Contains dotfiles path patterns (~/.config/* → ~/dotfiles/*.pkd/). Examples: aerospace, yabai, karabiner, skhd, git, ssh, or any ~/.config/ path.
---

## Dotfiles Structure

All configuration directories in `~/dotfiles/` with `.pkd` extension are symlinked to their standard locations using a custom GNU stow wrapper.

### Pattern

- **Source**: `~/dotfiles/<name>.pkd/`
- **Symlinked to**: Standard locations (`~/.config/<name>/`, `~/.<name>/`, etc.)

### File Operations Rule

- **PREFER reading from** `~/dotfiles/*.pkd/*` over standard locations (`~/.config/`, `~/`, etc.)
  - _Rationale: Configs exist in `~/dotfiles/*.pkd/` and are symlinked to standard locations. Reading from source avoids session boundary prompts_
- **Apply same pattern for writes**: Write to `~/dotfiles/*.pkd/*` rather than symlinked locations
- Standard locations are accessible if needed, but source paths avoid extra confirmation

### Known Config Packages

| Tool           | Source Path                                      |
| -------------- | ------------------------------------------------ |
| aerospace      | `~/dotfiles/aerospace.pkd/dot-aerospace.toml`    |
| bash           | `~/dotfiles/bash.pkd/dot-bashrc`                |
| btop           | `~/dotfiles/btop.pkd/.config/btop/`              |
| bus_pirate     | `~/dotfiles/bus_pirate.pkd/dot-screenrc`         |
| git            | `~/dotfiles/git.pkd/dot-gitconfig`              |
| ghostty        | `~/dotfiles/ghostty.pkd/.config/ghostty/`        |
| jankyborders   | `~/dotfiles/jankyborders.pkd/.config/borders/`   |
| karabiner      | `~/dotfiles/karabiner.pkd/.config/karabiner/`    |
| lazygit        | `~/dotfiles/lazygit.pkd/.config/lazygit/`        |
| llm (OpenCode) | `~/dotfiles/llm.pkd/.config/opencode/`          |
| neovim         | `~/dotfiles/neovim.pkd/.config/nvim/`            |
| nushell        | `~/dotfiles/nushell.pkd/.config/nushell/`        |
| sketchybar     | `~/dotfiles/sketchybar.pkd/.config/sketchybar/`  |
| starship       | `~/dotfiles/starship.pkd/.config/starship.toml`  |
| vim            | `~/dotfiles/vim.pkd/dot-vimrc`                   |
| zellij         | `~/dotfiles/zellij.pkd/.config/zellij/`          |

For a comprehensive list of config packages run `ls ~/dotfiles/*.pkd`

_Note: Other configs may follow this pattern. When encountering a `.pkd` directory, assume it follows the same symlinking structure._

> **OpenCode relocation:** OpenCode config was consolidated into `llm.pkd` — there is no `opencode.pkd`. Edit OpenCode config under `~/dotfiles/llm.pkd/.config/opencode/`.

### GNU Stow

Dotfiles are symlinked and managed using GNU `stow`, called through a wrapper script. This influences the `~/dotfiles` structure.
Hidden (`.**`) config files are typically named using the `dot-**` syntax supported by `stow`, with the exception of directories where `dot-` is not supported on all versions of `stow`.

## Colorscheme

A personal color palette derived from **Catppuccin Mocha**, defined authoritatively in `~/dotfiles/docs/colorscheme.md`. Consult that doc for exact hex values; the conventions below guide naming and structure when editing color configs.

### Naming Conventions

- **Accent colors** — color-identity names with an optional tier suffix:
  - `-dimmed` / `-bright` (unsuffixed = `normal`)
  - Names: coral, salmon, pink, purple, red, red-soft, orange, yellow, green, teal, cyan, azure, blue, lilac
- **Structural colors** — purpose names: `fg`, `fg-secondary`, `fg-muted`, `fg-faint`, `border`, `border-muted`, `surface-raised`, `surface`, `surface-sunken`
- **Background colors** — purpose names with transparency overrides (darker than Catppuccin originals, for terminal opacity): `bg`, `bg-secondary`, `bg-deep`
- **Derived colors** — tool-specific purpose names, not generated from accent tiers: `cursor`, `git-branch`, `diff-*`, `focus-*`

### Format Variants

- Hex (`#RRGGBB`) is the default
- `0xAARRGGBB` (alpha-prefixed) is provided for tools like `sketchybar` and `jankyborders`

### Provenance

Each generic name maps to a Catppuccin Mocha color (e.g. `coral` → `rosewater`, `bg` → `base`); see the mapping table in `docs/colorscheme.md`.

## Structure and Context

**ALWAYS** look for README.md files in configs, if present they will provide information about the design and use of the configuration
