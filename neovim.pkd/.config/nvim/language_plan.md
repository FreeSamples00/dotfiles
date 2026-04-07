# Plan for language tool management

## Global Config

`core/languages.lua` defines mappings of languages to tools:

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
