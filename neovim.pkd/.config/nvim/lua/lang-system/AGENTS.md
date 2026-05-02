# Language System - Agent Guidelines

## Reference

| Resource       | Location                      | When to Use                                    |
| -------------- | ----------------------------- | ---------------------------------------------- |
| Language Defs  | `languages.lua`               | Adding/modifying language configurations       |
| Tool Mappings  | `mappings.lua`                | LSP→Mason name mapping, null-ls source loading |
| Core Functions | `functions.lua`               | Install/status logic, dependency resolution    |
| Entry Point    | `init.lua`                    | Setup, commands, LSP/null-ls/treesitter setup  |
| User Config    | `lua/plugins/lang-system.lua` | User overrides (not in this directory)         |

## Workflow

### 1. Adding a New Language

1. Check `mappings.lua` for LSP→Mason name mapping (add if missing)
2. Check `mappings.lua` for formatter/linter null-ls source (add if needed)
3. Add definition to `languages.lua` with required fields
4. Document in README.md if it has sensible defaults

### 2. Adding a New Tool (Formatter/Linter)

1. Check if tool exists in `null_ls.builtins.formatting` or `null_ls.builtins.diagnostics`
2. If using none-ls-extras, add to `mappings.lua` with `provider = "extras"`
3. If builtin name differs from config name, add to `mappings.lua` with `provider = "builtin"`

### 3. Modifying Existing Language

1. Check if change should be a default (all users) or override (your config only)
2. Defaults → edit `languages.lua`
3. Overrides → edit user config in `lua/plugins/lang-system.lua`

### 4. Completions of feature/fix

1. verify that feature works as intended
2. if applicable update or create tests
3. if applicable update or create documentation

### 5. Running Tests

1. Run `just test` before committing changes to `functions.lua`
2. Add tests for new functions in `functions.lua`
3. Update fixtures in `tests/fixtures/` if language schema changes
4. Test files follow `*_spec.lua` naming convention

## Constraints

- **ALWAYS** check `mappings.lua` before adding LSP/tools - names often differ
- **NEVER** configure LSP servers directly in lspconfig - use language definitions
- **NEVER** add tools without verifying Mason package name exists
- **NEVER** skip dependency declarations - they ensure correct install order
- Tool names in language defs use Mason package names, not lspconfig names

## Patterns

### Language Definition

```lua
lang_name = {
  filetypes = { "ext" },           -- Required: matched filetypes
  treesitter = "parser",           -- Optional: parser name or array
  dependencies = { "other_lang" }, -- Optional: install order
  lsp = { name = "server_name" },  -- Optional: lspconfig server name
  formatter = { name = "tool" },   -- Optional: Mason package name
  linter = { name = "tool" },      -- Optional: Mason package name
}
```

### Tool with Non-Default Mason Name

```lua
-- In mappings.lua:
M.lsp_to_mason = {
  tsserver = "typescript-language-server",  -- lspconfig name → Mason name
}
```

### Tool from none-ls-extras

```lua
-- In mappings.lua:
M.tool_to_nullls = {
  formatting = {
    prettier = { source = "prettier", provider = "extras" },
  },
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

| Symptom                        | Check                                       |
| ------------------------------ | ------------------------------------------- |
| LSP not found                  | `lsp_to_mason` mapping missing or incorrect |
| Formatter/linter not loading   | `tool_to_nullls` mapping missing            |
| Tool not installing            | Mason package name differs from tool name   |
| Dependency not installed first | Add to `dependencies` array in language def |
