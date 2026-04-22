# Language System

> [!NOTE]: This system was entirely vibe-coded, partially as an experiment, partially because I am lazy. Therefore it comes with absolutely no warranty or guarantee.

A declarative language configuration system that centralizes LSP, formatters, linters, DAP, and treesitter into a single source of truth.

## Structure

```
lua/lang-system/
├── init.lua       # Entry point; sets up Mason, treesitter, LSP, null-ls
├── languages.lua  # Helper functions and public API
└── mappings.lua   # LSP/formatter/linter → Mason package mappings

lua/plugins/
└── lang-system.lua  # Plugin spec + language definitions
```

## Dependencies

| Plugin                              | Purpose                                    |
| ----------------------------------- | ------------------------------------------ |
| `williamboman/mason.nvim`           | Package manager for LSP/formatters/linters |
| `williamboman/mason-lspconfig.nvim` | Mason ↔ lspconfig bridge                   |
| `neovim/nvim-lspconfig`             | LSP client configuration                   |
| `nvimtools/none-ls.nvim`            | Formatters, linters, code actions          |
| `nvimtools/none-ls-extras.nvim`     | Extra sources for none-ls                  |
| `nvim-treesitter/nvim-treesitter`   | Syntax highlighting                        |

## Language Declaration Schema

Language definitions are passed to `langs.setup()` in `lua/plugins/lang-system.lua`:

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

### Tool Defaults

| Field     | Default | Description                        |
| --------- | ------- | ---------------------------------- |
| `enable`  | `true`  | Whether the tool is active         |
| `install` | `true`  | Whether to auto-install via Mason  |
| `mason`   | `true`  | `false` for system-installed tools |

## Commands

| Command                     | Description                      |
| --------------------------- | -------------------------------- |
| `:LanguageInstall [name]`   | Install tools for a language     |
| `:LanguageInstallCurrent`   | Install tools for current buffer   |
| `:LanguageUninstallCurrent` | Uninstall tools for current buffer |
| `:LanguageUninstall [name]` | Uninstall tools for a language     |
| `:LanguageList`             | List all defined languages       |
| `:LanguageStatus`           | Show installation status         |
| `:AutoFormatToggle`         | Toggle format-on-save            |

## Adding a New Language

1. Add definition to `lua/plugins/lang-system.lua`:

   ```lua
   lua = {
     filetypes = { "lua" },
     treesitter = "lua",
     lsp = { name = "lua_ls" },
     formatter = { name = "stylua" },
     linter = nil,
     dap = nil,
   },
   ```

2. Add to `ensure_installed` for auto-install on startup:

   ```lua
   ensure_installed = { ..., "lua" }
   ```

3. If using a formatter/linter from `none-ls-extras`, it's loaded automatically.

## Adding a New Tool (Formatters/Linters)

1. Check if tool exists in `null_ls.builtins.formatting[name]` or `none-ls-extras`
2. Add to language definition with `name` matching the none-ls source
3. Mason package name should match the source name

## Tool Name Mappings

`mappings.lua` maps LSP/formatter/linter names to Mason package names. If auto-install fails, the mapping may be missing. Check Mason docs for the correct package name.

## none-ls Source Loading

Sources are loaded with fallback logic:

1. Check `tool_to_nullls` mapping for explicit source/provider config
2. Try `null_ls.builtins[method][name]` (core builtins)
3. For `provider = "extras"`, load from `none-ls.{method}.{source}`

This allows using tools from `none-ls-extras.nvim` with explicit mapping.
