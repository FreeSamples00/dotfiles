# NEOVIM

## Language System

> This system is entirely vibe coded, and therefore comes with no warranty. It was done this way both because I do not care to actually do it right, and because I wanted to explore LLM capabilities.

A declarative language configuration system that centralizes LSP, formatters, linters, DAP, and treesitter into a single source of truth.

### Structure

```
lua/core/
├── language_conf.lua      # Declarative language definitions (edit here)
├── languages.lua          # Helper functions and public API
└── lsp_mason_mappings.lua # lspconfig → Mason package name mappings

lua/plugins/
└── language-tools.lua     # Plugin setup (Mason, LSP, none-ls, treesitter)
```

### Dependencies

| Plugin                              | Purpose                                    |
| ----------------------------------- | ------------------------------------------ |
| `williamboman/mason.nvim`           | Package manager for LSP/formatters/linters |
| `williamboman/mason-lspconfig.nvim` | Mason ↔ lspconfig bridge                   |
| `neovim/nvim-lspconfig`             | LSP client configuration                   |
| `nvimtools/none-ls.nvim`            | Formatters, linters, code actions          |
| `nvimtools/none-ls-extras.nvim`     | Extra sources for none-ls                  |
| `nvim-treesitter/nvim-treesitter`   | Syntax highlighting                        |

### Language Declaration Schema

```lua
lua = {
  filetypes = { "lua" },           -- Required: filetypes this language handles
  treesitter = "lua",              -- Optional: parser name or array
  lsp = {                          -- Optional: LSP configuration
    name = "lua_ls",               -- lspconfig server name
    config = { ... },              -- passed to lspconfig setup
    mason = false,                 -- set false for system-installed servers
  },
  formatter = {                    -- Optional: formatter configuration
    name = "stylua",               -- none-ls source name
    config = { ... },              -- passed to none-ls source.with()
    mason = false,                 -- set false for system-installed tools
  },
  linter = {                       -- Optional: linter configuration
    name = "shellcheck",
    config = { ... },
    mason = false,
    enable = false,                -- set false to disable but keep definition
    install = false,               -- set false to skip auto-install
  },
  dap = { ... },                   -- Optional: DAP configuration (same schema)
},
```

#### Tool Defaults

| Field     | Default | Description                        |
| --------- | ------- | ---------------------------------- |
| `enable`  | `true`  | Whether the tool is active         |
| `install` | `true`  | Whether to auto-install via Mason  |
| `mason`   | `true`  | `false` for system-installed tools |

### Commands

| Command                     | Description                    |
| --------------------------- | ------------------------------ |
| `:LanguageInstall [name]`   | Install tools for a language   |
| `:LanguageUninstall [name]` | Uninstall tools for a language |
| `:LanguageList`             | List all defined languages     |
| `:LanguageStatus`           | Show installation status       |
| `:AutoFormatToggle`         | Toggle format-on-save          |

### Adding a New Language

1. Add definition to `lua/core/language_conf.lua`:

   ```lua
   rust = {
     filetypes = { "rust" },
     treesitter = "rust",
     lsp = { name = "rust_analyzer" },
     formatter = { name = "rustfmt" },
     linter = nil,
     dap = nil,
   },
   ```

2. Add to `ensure_installed` for auto-install on startup:

   ```lua
   M.ensure_installed = { ..., "rust" }
   ```

3. If using a formatter/linter from `none-ls-extras`, it's loaded automatically.

### Adding a New Tool (Formatters/Linters)

1. Check if tool exists in `null_ls.builtins.formatting[name]` or `none-ls-extras`
2. Add to language definition with `name` matching the none-ls source
3. Mason package name should match the source name

### LSP Server Name Mappings

`lsp_mason_mappings.lua` maps lspconfig server names to Mason package names. If auto-install fails, the mapping may be missing. Check `mason-lspconfig` docs for the correct Mason package name.

### none-ls Source Loading

Sources are loaded with fallback logic:

1. Try `null_ls.builtins[method][name]` (core builtins)
2. Try `require("none-ls." .. method .. "." .. name)` (extras)

This allows using tools from `none-ls-extras.nvim` without configuration changes.
