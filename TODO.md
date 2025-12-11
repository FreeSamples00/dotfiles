# Dotfile TODOs

## `dot`

- [ ] add ykey subcommand
  - [ ] --ssh-install
    - extract keys `ssh-keygen -K`
    - move keys to .ssh/keys/yubico{.pub} (mkdir -p)
  - [ ] --ssh-remove
  - [ ] `echo -e "\nHost *\n\tIdentityFile ~/.ssh/keys/yubico_ssh\n\tIdentityAgent none" >> ~/.ssh/config`
    - delete yubico keys from .ssh/keys
  - [ ] --commands
    - set yubico static passwords
    - allow input for setting shortpress?

- [ ] add brew subcommand
  - [ ] --dump (same as current dump scheme)
  - [ ] --install (use curl to install)
  - [ ] --bundle (install brew packages from brewfile)

- [ ] add cron subcommand
  - [ ] --dump (same as scheme)
  - [ ] --deploy (deploy cronjobs to crontab)
    - [ ] fuzzy selection / filter or match stow pattern?

## Packages

- [ ] add ssh.pkd?
  - [ ] evaluate exposed data
  - [ ] add local `.gitignore` with `./keys/*`

## Aesthetics

- [ ] customize `grc`

## Misc

- [ ] remove all of ghidraMCP

- [ ] use noseyparker or other secret sniffer as precommit hook?

- [ ] update readme
  - [ ] command changes
  - [ ] add sections for major features
