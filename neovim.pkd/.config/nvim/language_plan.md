# Plan for language tool management

## TODOS

- [ ] make status command show in a snacks float window
- [ ] use snacks for a management UI:
  - [ ] left pane: language list (w/ status)
  - [ ] right pane: language config location in languages.lua
  - [ ] style: same as rest of snacks pickers, disable search
  - [ ] binds:
    - [ ] i: install selected language
    - [ ] X: uninstall selected language

## Global Config

`core/languages.lua` defines mappings of languages to tools:

```lua
M.languages = {
  python = {
    filetypes = { "python", "py" },
    treesitter = { "python", ... }, -- allow multiple grammars (e.g. ts & tsx)
    lsp = {
      name = "pylsp",
      enabled = true,
      config = { ... }
    },
    formatter = {
      name = "black",
      enabled = true,
      config = { .. }
    },
    linter = {
      name = "flake8",
      enabled = true,
      config = { ... }
    },
    dap = {
      name = "debugpy",
      enabled = false,
      config = { ... }
    }
  }
}
```

- Treesitter
- LSP
- Formatter
- dap
- linter

one tool per category per language, if a tool supports multiple languages ignore that functionality and only configure the tool -> language specified

field for filetypes/extensions that should also map to the language

always allow null for an entry, this must be caught be the rest of config

also maintain `ensure_installed` list for languages always needed (at least lua)

all instances should get the ensure_installed languages, list of additionally installed languages should be managed (perhaps near where plugins are installed)

## language install

command that installs all required tools defined for a language

- `LanguageInstall <language>` install language
- `LanguageInstall` use picker
- `LanguageList` list all defined languages
- `LanguageStatus` installation/configuration status

Runs:

- on startup for `ensure_installed`
- lazily when opening a filetype that is defined in the config
  - perhaps prompt for user choice
- manually thru a command
  - ideally some kind of UI or picker

## plugin usage

new `language-tools.lua` plugin file that manages everything using lazy

treesitter and mason for installing tools

### treesitter

install and configure languages as needed

### LSP

install and configure languages as needed

define LSP keybinds to only be available if LSP is attached

one tool per category per language, if a tool supports multiple languages ignore that functionality and only configure the tool -> language specified

### Formatter

install and configure formatters as needed

define formatter keybinds and auto-format hook if formatter is available

### Linter

use null-ls to configure

### DAP

skip config for now, will set up later
