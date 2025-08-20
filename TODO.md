# Config TODOs

## Shell

- [ ] `project_root` command to return either git root dir or current dir
  - [x] add to `ignore`
  - [x] create a `todo` just like `ignore`
  - [ ] add to other things

- [ ] `difftastic` for new diff tool (smarter diffing)
  - see [documentation](https://difftastic.wilfred.me.uk/git.html) for git

- [ ] `mergiraf` for git merges

- [ ] switch from `p10k` prompt to `starship`:
  - [ ] left side:
    - [ ] shortened working directory
    - [ ] branch
    - [ ] git changes
    - [ ] prompt arrow w/ return code coloring
  - [ ] right side:
    - [ ] time
    - [ ] time spent running (if over limit)
    - [ ] tmux indicator
    - [ ] message about unexpected return codes
    - [ ] ssh client indicator
  - [ ] compress old prompts?

## Neovim

- [ ] change completion keybinds:
  - [ ] `ctrl + y`: accept completion
  - [ ] `ctrl + n`: dismiss completion menu
  - [ ] `ctrl + space`: manually trigger completions
  - [ ] `ctrl + j`: cycle completions (down)
  - [ ] `ctrl + k`: cycle completions (up)

- [ ] lualine elements to add:
  - [ ] macro recording indicator

## O/S

- [ ] start using `nix` for package management and declarative setup

- [ ] stop using `onedrive`:
  - [ ] host projects on github
  - [ ] switch to icloud?
