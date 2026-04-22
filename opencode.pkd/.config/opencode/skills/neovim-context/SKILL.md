---
name: neovim-context
description: Neovim configuration details including plugin management and language tools
---

## Config Location

`~/dotfiles/neovim.pkd/.config/nvim/`

## Gaining Context

**ALWAYS read these READMEs when working with this config:**

1. `~/dotfiles/neovim.pkd/.config/nvim/README.md` - Overview of plugins, UI, navigation, and language tooling
2. `~/dotfiles/neovim.pkd/.config/nvim/lua/lang-system/README.md` - Language system documentation

## Structure

```
lua/
├── plugins/           # lazy.nvim plugin specs
│   └── lang-system.lua  # Language definitions
├── lang-system/       # Language tool management
│   ├── init.lua       # Entry point; sets up Mason, treesitter, LSP, null-ls
│   ├── languages.lua  # Helper functions and public API
│   └── mappings.lua   # LSP/formatter/linter → Mason package mappings
└── ...
```

## Plugin Management

- Uses `lazy.nvim` for plugin management
- Aims for blazing fast boot times via lazy loading

## Language System

Declarative language configuration that centralizes:
- Treesitter
- LSP
- Formatter
- Linter
- DAP

### Key Commands

| Command                     | Description                      |
| --------------------------- | -------------------------------- |
| `:LanguageInstall [name]`   | Install tools for a language     |
| `:LanguageInstallCurrent`   | Install tools for current buffer |
| `:LanguageList`             | List all defined languages       |
| `:LanguageStatus`           | Show installation status         |
| `:AutoFormatToggle`         | Toggle format-on-save            |

### Adding Languages

Languages are defined in `lua/plugins/lang-system.lua` with schema:

```lua
lang_name = {
  filetypes = { "ext" },
  treesitter = "parser",
  lsp = { name = "server", mason = true },
  formatter = { name = "tool", mason = true },
  linter = { name = "tool", mason = true },
  dap = { ... },
}
```

## Editor Alias

The alias `e` opens neovim.
