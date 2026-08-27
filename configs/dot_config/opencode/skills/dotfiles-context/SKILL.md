---
name: dotfiles-context
description: CRITICAL - Load for config file operations. Contains dotfiles path patterns (~/.config/* → ~/dotfiles/configs/). Examples: aerospace, yabai, karabiner, skhd, git, ssh, or any ~/.config/ path.
---

## Dotfiles Structure

All configuration files are managed with **chezmoi**. The source directory is `~/dotfiles/configs/`. Chezmoi deploys files to standard locations (`~/.config/`, `~/`, etc.) using `just dot apply`.

### Pattern

- **Source**: `~/dotfiles/configs/dot_config/<tool>/` (chezmoi `dot_` prefix maps to `~/.`)
- **Deployed to**: `~/.config/<tool>/` (and `~/dot_<file>` maps to `~/.<file>`)
- **Templates**: Files with `.tmpl` extension are Go templates processed by chezmoi
- **Data**: `~/dotfiles/configs/.chezmoidata/colors.toml` provides `.colors.*` template variables

### File Operations Rule

- **PREFER reading from** `~/dotfiles/configs/dot_config/<tool>/` over deployed locations (`~/.config/`, `~/`, etc.)
  - _Rationale: Source files are the canonical version. Deployed files are generated. Reading source avoids session boundary prompts._
- **Apply same pattern for writes**: Write to `~/dotfiles/configs/dot_config/<tool>/` rather than deployed locations
- Template files (`.tmpl`) contain Go template syntax (`{{ .colors.* }}`) — edit the template, not the deployed output
- After editing, run `just dot apply` to deploy changes

### Known Config Locations

| Tool       | Source Path                                             | Notes                                           |
| ---------- | ------------------------------------------------------- | ----------------------------------------------- |
| aerospace  | `~/dotfiles/configs/dot_aerospace.toml`                 | macOS only                                      |
| bash       | `~/dotfiles/configs/dot_bashrc`                         |                                                 |
| bat        | `~/dotfiles/configs/dot_config/bat/`                    | `.tmTheme.tmpl`                                 |
| btop       | `~/dotfiles/configs/dot_config/btop/`                   | `.theme.tmpl`                                   |
| borders    | `~/dotfiles/configs/dot_config/borders/`                | `bordersrc.tmpl`, macOS only                    |
| git        | `~/dotfiles/configs/dot_config/git/config.tmpl`         |                                                 |
| ghostty    | `~/dotfiles/configs/dot_config/ghostty/`                | `config.tmpl`, `themes/colorscheme-normal.tmpl` |
| karabiner  | `~/dotfiles/configs/dot_config/karabiner/`              | macOS only                                      |
| lazygit    | `~/dotfiles/configs/dot_config/lazygit/config.yml.tmpl` |                                                 |
| neovim     | `~/dotfiles/configs/dot_config/nvim/`                   | `palette.lua.tmpl`                              |
| nushell    | `~/dotfiles/configs/dot_config/nushell/`                | `colors.nu.tmpl`                                |
| opencode   | `~/dotfiles/configs/dot_config/opencode/`               |                                                 |
| sketchybar | `~/dotfiles/configs/dot_config/sketchybar/`             | `config.nu.tmpl`, macOS only                    |
| starship   | `~/dotfiles/configs/dot_config/starship.toml.tmpl`      |                                                 |
| vim        | `~/dotfiles/configs/dot_vimrc`                          |                                                 |
| zellij     | `~/dotfiles/configs/dot_config/zellij/`                 |                                                 |

macOS-only configs are excluded on Linux via `~/dotfiles/configs/.chezmoiignore.tmpl`.

### Chezmoi

Configs are deployed with chezmoi using `just dot apply` which runs `chezmoi apply --source ~/dotfiles/configs --force --keep-going`. The `dot_` prefix in source filenames maps to a dot in the deployed path (e.g., `dot_config` -> `.config`, `dot_bashrc` -> `.bashrc`).

## Colorscheme

Theme colors come from `~/dotfiles/configs/.chezmoidata/colors.toml` (the active theme). Theme files live in `~/dotfiles/configs/themes/`. Switch themes with `just dot theme <name>`.

### Token Structure

Colors are organized in 10 semantic sections under `.colors.*`:

- `colors.palette.*` — 14 accent colors (coral, salmon, pink, purple, red, red_soft, orange, yellow, green, teal, cyan, azure, blue, lilac)
- `colors.ui.*` — structural colors (bg, bg_alt, bg_deep, fg, fg_secondary, fg_muted, fg_faint, border, border_muted, surface, surface_raised, surface_sunken, accent, cursor, etc.)
- `colors.syntax.*` — syntax highlighting (keyword, type, function, property, variable, string, number, tag, comment, operator, punctuation, constant)
- `colors.markup.*` — markup colors
- `colors.diagnostic.*` — error, warning, info, hint
- `colors.git.*` — branch, modified, untracked, staged, deleted, etc.
- `colors.diff.*` — minus, plus, hunk, file, blame, nvim_add_bg, etc.
- `colors.ansi.*` — 16 ANSI palette colors
- `colors.starship.*` — starship prompt colors
- `colors.opacity.*` — background, cursor opacity values

All keys use underscores (not hyphens) to avoid `{{ index }}` syntax in templates.

See `~/dotfiles/docs/colorscheme.md` for the full reference with hex values and catppuccin compat mapping.

## Structure and Context

**ALWAYS** look for README.md files in configs, if present they will provide information about the design and use of the configuration
