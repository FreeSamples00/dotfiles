# New Neovim Config TODOs

- [ ] bottom right notifications
  - [ ] doubled in the foremost display
  - [ ] also displayed by something else in background

- [ ] use AI to diff features between this and lazyvim, ensure nothing important is missed
- [x] look into deprecation warnings: `:checkhealth vim.deprecated`
- [ ] Configure inline hints?
- [ ] boundary for page scrolling
- [ ] lualine indicator for buffers?
- [ ] open help windows in some kind of styled pop-up/split buffer
  - [ ] maybe use `snacks` preconfigured help split?
- [ ] redo completion bindings in `cmp` to match `blink`
- [ ] move keybinds that are per plugin to the config, see lazy.nvim docs
- [x] Undotree (native)
  - [ ] replaced with `atone`
  - [ ] configure atone, possible live render on main buffer?
- [ ] difftool (native)
- [ ] add `shift + enter` in insert mode to newline without adding new comment prefix
- [x] force text files to have `scrolloff=1` and shift down on opening
- [x] change wrap icon to something less rigid looking
- [ ] add non-saved scratch buffers

## Colorscheme issues

Currently overrides (highlights specifically) to the catppuccin config do not stick to file buffers. They do however work in temp buffers like `Mason`.

This is likely due to treesitter overriding things when a buffer is detected?

**changes needed**

- [ ] current line background
- [ ] highlight current line number
- [ ] ...
