# New Neovim Config TODOs

- [ ] add docs in README

- [ ] binding + ui for new file
  - [ ] snacks pick dir + enter filename
  - [ ] plugin?

## Plugins

- Look into [nanotee/zoxide.vim: A small (Neo)Vim wrapper for zoxide](https://github.com/nanotee/zoxide.vim)

## Keybinds

- [ ] create grouping for comment operations
  - [ ] likely <leader>c or C
  - [ ] see comment options under "gc"

## Language System

- [ ] add description per language

- languages live in `lua/plugins/lang-system.lua` (single source of truth);
  wiring in `lua/lang-system/init.lua`

### UI (deferred)

- snacks picker over the languages table:

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
  - d: uninstall language (via Mason)
  - u: update all tools
  - o: open language config location

- command to install language from current filetype (not in UI)

## Treesitter

If treesitter-nvim deprecation causes problems, consider switching to a maintained option

- [tree-sitter-manager](https://github.com/romus204/tree-sitter-manager.nvim)
