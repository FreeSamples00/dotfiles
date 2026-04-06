# New Neovim Config TODOs

- [ ] make `:w` and `:x` save all buffers
- [ ] use AI to diff features between this and lazyvim, ensure nothing important is missed
- [x] look into deprecation warnings: `:checkhealth vim.deprecated`
- [ ] Configure inline hints?
- [ ] bottom right LSP loading things have wrong background color
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

## Colorscheme issues

Currently overrides (highlights specifically) to the catppuccin config do not stick to file buffers. They do however work in temp buffers like `Mason`.

This is likely due to treesitter overriding things when a buffer is detected?

**changes needed**

- [ ] current line background
- [ ] highlight current line number
- [ ] ...
