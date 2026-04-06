# New Neovim Config TODOs

- [ ] bottom right notifications
  - [ ] LSP notifications are doubled
  - [ ] this seems to work in lazyvim

- [ ] use AI to diff features between this and lazyvim, ensure nothing important is missed
- [ ] Configure inline hints?
- [ ] figure out how to get inline lsp hints

## Snacks

Continue to explore this plugin, seems to have lots

- [ ] open help windows in some kind of styled pop-up/split buffer
  - [ ] maybe use `snacks` preconfigured help split?

## Colorscheme issues

Currently overrides (highlights specifically) to the catppuccin config do not stick to file buffers. They do however work in temp buffers like `Mason`.

This is likely due to treesitter overriding things when a buffer is detected?

**changes needed**

- [ ] current line background
- [ ] highlight current line number
- [ ] ...
