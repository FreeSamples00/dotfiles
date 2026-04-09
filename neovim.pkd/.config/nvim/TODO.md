# New Neovim Config TODOs

- [ ] bottom right notifications
  - [ ] LSP notifications are doubled
  - [ ] this seems to work in lazyvim

- [ ] use AI to diff features between this and lazyvim, ensure nothing important is missed
- [ ] Configure inline hints?
- [ ] figure out how to get inline lsp hints
- [ ] make sure all keybinds are wanted, have proper descriptions, and are in the right place
- [ ] highlight the external parens for block cursor is in

## LSP

- [ ] polish LSP system, currently autoenables and sets default config with overrides
- [x] look into an LSP config that doesn't require changing `lsp.lua` for every new LSP
- [x] make a global LSP list, use it in `lsp.lua` for:
  - [x] ensure installed
  - [x] enable & conf
- [ ] Look into ensuring formatters always work, is going thru LSP problematic?

## Snacks

Continue to explore this plugin, seems to have lots

- [ ] open help windows in some kind of styled pop-up/split buffer
  - [ ] maybe use `snacks` preconfigured help split?

- [ ] change dashboard "loaded in" time to dynamically change units (move to seconds instead of ms if needed)
- [ ] make undotree cumulative?
- [ ] show hidden files in smart search
  - [ ] in explorer too?
- [ ] bind `d` to delete buffer in buffer picker

## merge conflicts

setup something to help resolve merge conflicts

- plugin?

## Colorscheme issues

Currently overrides (highlights specifically) to the catppuccin config do not stick to file buffers. They do however work in temp buffers like `Mason`.

This is likely due to treesitter overriding things when a buffer is detected?

**changes needed**

- [ ] current line background
- [ ] highlight current line number
- [ ] ...
