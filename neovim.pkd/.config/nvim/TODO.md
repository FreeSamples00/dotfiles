# New Neovim Config TODOs

- [ ] add docs in README

- [ ] binding + ui for new file
  - [ ] snacks pick dir + enter filename
  - [ ] plugin?

## Plugins

- Look into [nanotee/zoxide.vim: A small (Neo)Vim wrapper for zoxide](https://github.com/nanotee/zoxide.vim)

- look into switching from nvim-cmp to blink-cmp `ses_18f71555effePbM5dirf05m4Hl`

## Keybinds

- [ ] create grouping for comment operations
  - [ ] likely <leader>c or C
  - [ ] see comment options under "gc"

## Language System

- [ ] add description per language

- [ ] move custom args and such to user conf instead of plugin?

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
