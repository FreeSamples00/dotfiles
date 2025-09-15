# My Dotfiles

## Dotfiles

1. run `./stow.sh test`
2. ensure all proposed links look good
3. run `./stow.sh link`

## Homebrew

To install [Homebrew](https://brew.sh/) packages:

1. Install brew (linux or macos): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install brew packages: `brew bundle --file=~/dotfiles/_dumps/Brewfile`

## Cronjobs

Cronjobs are dumped into `dotfiles/_dump/Cronjobs`

## Touch ID sudo

to enable touch ID for _sudo_, run:
`sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local`
