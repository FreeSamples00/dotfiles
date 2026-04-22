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

| Tool     | Source Path                                 |
| -------- | ------------------------------------------- |
| Nushell  | `~/dotfiles/nushell.pkd/.config/nushell/`   |
| Neovim   | `~/dotfiles/neovim.pkd/.config/nvim/`       |
| OpenCode | `~/dotfiles/opencode.pkd/.config/opencode/` |
| Ghostty  | `~/dotfiles/ghostty.pkd/.config/ghostty/`   |

For a comprehensive list of config packages run `ls ~/dotfiles/*.pkd`

_Note: Other configs may follow this pattern. When encountering a `.pkd` directory, assume it follows the same symlinking structure._

### GNU Stow

Dotfiles are symlinked and managed using GNU `stow`, called through a wrapper script. This influences the `~/dotfiles` structure.
Hidden (`.**`) config files are typically named using the `dot-**` syntax supported by `stow`, with the exception of directories where `dot-` is not supported on all versions of `stow`.

## Structure and Context

**ALWAYS** look for README.md files in configs, if present they will provide information about the design and use of the configuration
