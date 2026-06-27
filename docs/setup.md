# Setup

## Homebrew

To install [Homebrew](https://brew.sh/) packages:

1. Install brew (linux or macos): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install brew packages: `brew bundle --file=~/dotfiles/data/Brewfile`

## Touch ID Sudo

To enable touch ID for _sudo_, run:

```bash
sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
```

## Nushell

To set nushell as a login shell a custom script is needed to properly set the `XDG_CONFIG_HOME` environment variable, allowing nushell to access configs in `~/.config/nushell`

1. Create a symlink: `sudo ln -s /Users/scc/dotfiles/nushell.pkd/nushell-launcher.sh /usr/local/bin/nushell`
2. Add this script to allowed shells:
   a. `sudo vim /etc/shells`
   b. add `/usr/local/bin/nushell` to the end of the list
3. Change the shell: `chsh -s /usr/local/bin/nushell`

## Next Steps

After completing initial setup, see [Dotfiles Management](./dotfiles-stow.md) to install your configuration files.
