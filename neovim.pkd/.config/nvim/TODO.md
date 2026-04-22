# New Neovim Config TODOs

- [ ] add docs in README

- [ ] highlight the external parens for block cursor is in

- [ ] why are some UI elements hidden when lazy has to install something?
  - [ ] linenumbers

## Snacks

Continue to explore this plugin, seems to have lots

- [ ] make undotree cumulative?
  - [ ] switch back to that one that makes a cumulative diff

- [ ] there is a preview panel option for the file explorer, look into setting this up

## Keybinds

- [ ] create grouping for comment operations
  - [ ] likely <leader>c or C
  - [ ] see comment options under "gc"

- [ ] remove J line merging

## Language System

- [ ] get nushell LSP working

- [ ] implement regression and unit testing?
  - [ ] LLM accessible scripts:
    - [ ] linting, formatting, etc
    - [ ] unit and regression testing

- [ ] add description per language

### UI

- use snacks picker
  - split pane:
    - left: language name
    - right:
      - configured tools list
      - status of tools / language (live)
      - configured filetypes
      - keybind reference
  - have search bar, start in normal mode

- keybinds:
  - i: install language
  - X: cleans tools (deletes everything that is not defined in ensure_installed)
  - d: uninstall language
  - u: update all tools
  - o: open language config location
  - \*: some way to open configuration location

- command to install language from current filetype (not in UI)

## Treesitter

If treesitter-nvim deprecation causes problems, consider switching to a maintained option

- [tree-sitter-manager](https://github.com/romus204/tree-sitter-manager.nvim)
