# New Neovim Config TODOs

- [ ] add docs in README

- [ ] bottom right notifications
  - [ ] LSP notifications are doubled
  - [ ] this seems to work in lazyvim

- [ ] use AI to diff features between this and lazyvim, ensure nothing important is missed
- [ ] Configure inline hints?
- [ ] figure out how to get inline lsp hints
- [ ] make sure all keybinds are wanted, have proper descriptions, and are in the right place
- [ ] highlight the external parens for block cursor is in

- [ ] why are some UI elements hidden when lazy has to install something?
  - [ ] linenumbers

## Snacks

Continue to explore this plugin, seems to have lots

- [ ] open help windows in some kind of styled pop-up/split buffer
  - [ ] maybe use `snacks` preconfigured help split?

- [ ] change dashboard "loaded in" time to dynamically change units (move to seconds instead of ms if needed)
- [ ] make undotree cumulative?
  - [ ] switch back to that one that started with an a
- [ ] show hidden files in smart search
  - [ ] in explorer too?

- [ ] make enter in the keybinds picker open the bind location
- [ ] add snacks border to nvim news panel

- [ ] there is a preview panel option for the file explorer, look into setting this up

## Keybinds

- [ ] create grouping for comment operations
  - [ ] likely <leader>c or C
  - [ ] see comment options under "gc"

- [ ] remove opt + j line merging

## Language System

- [ ] Look into enabling formatters even if there is no LSP

- [ ] implement regression and unit testing?
  - [ ] LLM accessible scripts:
    - [ ] linting, formatting, etc
    - [ ] unit and regression testing

- [ ] add in code documentation
- [ ] add shorter documentation in README.md

- [ ] consider moving this to a plugin format that could be lazy loaded

### Bug log

#### TOML issues

```
 15:06          Notify          [LSP] Format request failed, no matching language servers.
```
