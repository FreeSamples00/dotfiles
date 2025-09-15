# My Configuration

## 1. Homebrew

To install [Homebrew](https://brew.sh/) packages:

1. Install brew (linux or macos): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install brew packages: `brew bundle --file=~/dotfiles/_dumps/Brewfile`

## 2. Dotfiles

1. remove any stale symlinks or conflicting config files
2. run `./stow.sh test` (this will tell you if there are any conflicts)
3. ensure all proposed links look good
4. run `./stow.sh link`

## Cronjobs

Cronjobs are dumped into `dotfiles/_dump/Cronjobs`

## Touch ID sudo

to enable touch ID for _sudo_, run:
`sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local`
