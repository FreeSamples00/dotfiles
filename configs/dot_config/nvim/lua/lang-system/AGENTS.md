# Language System - Agent Guidelines

## Reference

| Resource       | Location                      | When to Use                                             |
| -------------- | ----------------------------- | ------------------------------------------------------- |
| Language Defs  | `languages.lua`               | Adding/modifying language configurations                |
| Tool Mappings  | `mappings.lua`                | Explicit LSP→Mason name overrides only                  |
| Core Functions | `functions.lua`               | Install/status logic, dependency resolution             |
| Entry Point    | `init.lua`                    | Setup, commands, LSP/conform/nvim-lint/treesitter setup |
| User Config    | `lua/plugins/lang-system.lua` | User overrides (not in this directory)                  |

## Workflow

### 1. Adding a New Language

1. Check `mappings.lua` for an LSP→Mason override (only needed if `get_mason_name()` derivation fails)
2. Add definition to `languages.lua` with required fields
3. Document in README.md if it has sensible defaults

### 2. Adding a New Tool (Formatter/Linter)

1. Check the tool exists in conform.nvim formatters or nvim-lint linters — names match executables
2. Add to the language definition with `name` matching the executable
3. Formatter/linter names need no mapping table; only LSP server names do

### 3. Modifying Existing Language

1. Check if change should be a default (all users) or override (your config only)
2. Defaults → edit `languages.lua`
3. Overrides → edit user config in `lua/plugins/lang-system.lua`

### 4. Completion of feature/fix

1. verify that feature works as intended
2. if applicable update or create tests
3. if applicable update or create documentation

## Constraints

- **ALWAYS** check `mappings.lua` before adding LSP servers - derived Mason names can be wrong
- **NEVER** configure LSP servers directly in lspconfig - use language definitions
- **NEVER** add tools without verifying Mason package name exists
- **NEVER** skip dependency declarations - they ensure correct install order
- LSP `name` fields use lspconfig names; formatter/linter `name` fields use executable names

## Patterns

### Language Definition

```lua
lang_name = {
  filetypes = { "ext" },           -- Required: matched filetypes
  treesitter = "parser",           -- Optional: parser name or array
  dependencies = { "other_lang" }, -- Optional: install order
  lsp = { name = "server_name" },  -- Optional: lspconfig server name
  formatter = { name = "tool" },   -- Optional: conform formatter (executable name)
  linter = { name = "tool" },      -- Optional: nvim-lint linter (executable name)
}
```

### Tool with Non-Default Mason Name

```lua
-- In mappings.lua (overrides only; derivation handles the rest):
M.lsp_to_mason = {
  dockerls = "dockerfile-language-server",  -- lspconfig name → Mason name
}
```

### System-Installed Tool

```lua
-- In language definition:
formatter = {
  name = "rustfmt",
  mason = false,  -- Uses system binary instead of Mason
}
```

### Disabled but Defined

```lua
linter = {
  name = "shellcheck",
  enable = false,   -- Defined but not active
  install = true,   -- Still installs with language
}
```

## Common Issues

| Symptom                        | Check                                        |
| ------------------------------ | -------------------------------------------- |
| LSP not found                  | `lsp_to_mason` override missing or incorrect |
| Formatter/linter not loading   | Executable not installed (check PATH/Mason)  |
| Tool not installing            | Mason package name differs from tool name    |
| Dependency not installed first | Add to `dependencies` array in language def  |
