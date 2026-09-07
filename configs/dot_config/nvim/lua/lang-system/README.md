# Language System

> [!NOTE]: This system was entirely vibe-coded, partially as an experiment, partially because I am lazy. Therefore it comes with absolutely no warranty or guarantee.

A declarative language configuration system that centralizes LSP, formatters, linters, DAP, and treesitter into a single source of truth.

## Structure

```
lua/lang-system/
├── init.lua       # Entry point; setup functions for Mason, treesitter, LSP, conform, nvim-lint
├── functions.lua  # Core helper functions and merge logic
├── languages.lua  # Default language definitions
└── mappings.lua   # Explicit LSP → Mason package name overrides

lua/plugins/
└── lang-system.lua  # Plugin spec + user overrides
```

## Default Definitions

Both `languages.lua` and `mappings.lua` contain defaults that can be overridden via opts in `lua/plugins/lang-system.lua`. User values are deep-merged with defaults.

### Language Defaults

`languages.lua` contains default language configurations.

**Example: Override default LSP server**

```lua
-- languages.lua defines:
python = {
  filetypes = { "python", "py" },
  treesitter = "python",
  lsp = { name = "basedpyright" },
}

-- User opts override:
opts = {
  languages = {
    python = {
      lsp = { name = "pyright" },  -- Uses pyright instead
    },
  },
}
```

### Mapping Defaults

`mappings.lua` holds explicit LSP server → Mason package overrides for names that can't be derived mechanically. Most servers resolve automatically via `get_mason_name()`:

1. explicit override (`mappings.lua`)
2. underscore → dash (`rust_analyzer` → `rust-analyzer`)
3. trailing `_ls`/`ls` → `-language-server` (`bashls` → `bash-language-server`)

When multiple candidates apply, the first one found in the Mason registry wins. Only add entries to `mappings.lsp_to_mason` when derivation fails:

```lua
opts = {
  mappings = {
    lsp_to_mason = {
      my_custom_lsp = "my-custom-mason-package",
    },
  },
}
```

Formatter/linter names need no mapping: conform.nvim and nvim-lint address tools by their executable names, matching `languages.lua` directly.

## Dependencies

| Plugin                              | Purpose                                    |
| ----------------------------------- | ------------------------------------------ |
| `williamboman/mason.nvim`           | Package manager for LSP/formatters/linters |
| `williamboman/mason-lspconfig.nvim` | Mason ↔ lspconfig bridge                  |
| `neovim/nvim-lspconfig`             | LSP client configuration                   |
| `stevearc/conform.nvim`             | Formatters                                 |
| `mfussenegger/nvim-lint`            | Linters                                    |
| `nvim-treesitter/nvim-treesitter`   | Syntax highlighting (main branch)          |

## Language Declaration Schema

Language definitions are passed to `langs.setup()` in `lua/plugins/lang-system.lua`:

```lua
lua = {
  filetypes = { "lua" },           -- Required: filetypes this language handles
  treesitter = "lua",              -- Optional: parser name or array
  dependencies = { "html" },            -- Optional: languages this dependencies on
  lsp = {                          -- Optional: LSP configuration
    name = "lua_ls",               -- lspconfig server name
    config = { ... },              -- passed to lspconfig setup
    mason = false,                 -- set false for system-installed servers
  },
  formatter = {                    -- Optional: formatter configuration
    name = "stylua",               -- conform formatter name (executable name)
    extra_args = { ... },          -- appended to formatter args
    config = { ... },              -- conform formatter overrides (filetypes etc.)
    mason = false,                 -- set false for system-installed tools
  },
  linter = {                       -- Optional: linter configuration
    name = "shellcheck",           -- nvim-lint linter name (executable name)
    extra_args = { ... },
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

### Language Dependencies

Languages can declare dependencies on other languages using the `dependencies` field:

```lua
typescript = {
  filetypes = { "typescript", "typescriptreact" },
  treesitter = { "typescript", "tsx" },
  dependencies = { "html" },  -- Will install html tools first
  lsp = { name = "ts_ls" },
},
```

Dependency behavior:

- **Install**: Dependencies are installed recursively before the language itself
- **Ensure installed**: Dependencies are automatically added to `ensure_installed` expansion
- **Uninstall**: Blocked if other languages depend on it (use `!` to force)
- **Status**: `:LanguageStatus` shows dependencies and checks their installation

## Commands

| Command                      | Description                                  |
| ---------------------------- | -------------------------------------------- |
| `:LanguageInstall [name]`    | Install tools for a language (includes deps) |
| `:LanguageInstallCurrent`    | Install tools for current buffer             |
| `:LanguageUninstall [name]`  | Uninstall tools for a language               |
| `:LanguageUninstall! [name]` | Force uninstall (ignores dependents)         |
| `:LanguageUninstallCurrent`  | Uninstall tools for current buffer           |
| `:LanguageList`              | List all defined languages                   |
| `:LanguageStatus`            | Show installation status (includes deps)     |
| `:AutoFormatToggle`          | Toggle format-on-save                        |

## Adding a New Language

1. If the language has sensible defaults, add to `languages.lua`:

   ```lua
   lua = {
     filetypes = { "lua" },
     treesitter = "lua",
     lsp = { name = "lua_ls" },
     formatter = { name = "stylua" },
   },
   ```

2. Add user overrides to `lua/plugins/lang-system.lua` if needed:

   ```lua
   opts = {
     languages = {
       lua = {
         formatter = { name = "other_formatter" },  -- Override default
       },
     },
   }
   ```

3. Add to `ensure_installed` for auto-install on startup:

   ```lua
   opts = {
     ensure_installed = { ..., "lua" }
   }
   ```

## Adding a New Tool (Formatters/Linters)

1. Check the tool exists in [conform.nvim formatters](https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md) or [nvim-lint linters](https://github.com/mfussenegger/nvim-lint#available-linters) — names match the executable
2. Add to the language definition with `name` matching the executable
3. Mason package name usually matches the executable name

## Tool Name Mappings

`mappings.lua` maps lspconfig server names to Mason package names for names that fail mechanical derivation (see [Mapping Defaults](#mapping-defaults)). If LSP auto-install fails, the override may be missing.

## Verification

There is no automated test suite yet. To smoke-test the language system headlessly:

```bash
XDG_CONFIG_HOME=/tmp/scratch nvim --headless \
  +"lua print(vim.inspect(require('lang-system').status()))" +qa
```
