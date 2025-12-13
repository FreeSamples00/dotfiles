# My Configuration

## 1. Homebrew

To install [Homebrew](https://brew.sh/) packages:

1. Install brew (linux or macos): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install brew packages: `brew bundle --file=~/dotfiles/_dumps/Brewfile`

## 2. Dotfiles

_**NOTE:** You can manually select packages to link, see `./dot stow -h`_

1. remove any stale symlinks or conflicting config files
2. run `./dot stow -t -a` (this will tell you if there are any conflicts)
3. ensure all proposed links look good
4. run `./dot stow -a`

## Cronjobs

Cronjobs are dumped into `dotfiles/_dump/Cronjobs`

## Touch ID sudo

to enable touch ID for _sudo_, run:
`sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local`

## Yubikey

### Tools

- Yubico Authenticator - `yubico-authenticator`
  - GUI yubikey manager and authenticator
- Yubico config CLI - `ykman`
  - manage yubikey from cli
- yubico PIV tool - `yubico-piv-tool`
  - manages yubico PIV things
- Lib FIDO2 - `libfido2`
  - library for using FIDO2

### General

- Use authenticator app to rename key
- Use authenticator to change:
  - FIDO2 PIN
  - PUK
  - Management Key

### SSH Key

> [!NOTE]
> From https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html

> [!CAUTION]
> Must use ssh that is linked to libfido2, e.g. /opt/homebrew/bin/ssh on macos

#### Key Generation

Generate ssh key with `ssh-keygen -t ed25519-sk -O resident -C "SSH key"`

Move generated keys to `~/.ssh/keys/yubico_ssh` and `~/.ssh/keys/yubico_ssh.pub`

Copy the public key to a remote server with `ssh-copy-id -i ~/.ssh/keys/yubico_ssh user@host`
OR manually place `ssh_yubico_ssh.pub` in `~/.ssh/authorized_hosts` on the remote server

#### SSH Config

Use `echo -e "\nHost *\n\tIdentityFile ~/.ssh/keys/yubico_ssh\n\tIdentityAgent none" >> ~/.ssh/config` to set up automatic yubikey usage.

|            Config Elements            | Description                                                  |
| :-----------------------------------: | :----------------------------------------------------------- |
|               `Host *`                | Apply these settings to all hosts unless otherwise specified |
| `IdentityFile ~/.ssh/keys/yubico_ssh` | Sets yubico key reference as default auth method             |
|         `IdentityAgent none`          | Disables ssh agent, which tends to mess with yubikeys        |

#### Portable Usage

##### Extract Keys

Use `ssh-keygen -K` to extract a reference to yubikey private key file and public key.

##### SSH operations

Use `<ssh command> -i ./id_ed25519_sk_rk` on ssh commands to trigger yubikey for authentication.

##### Git operations

Use `GIT_SSH_COMMAND="ssh -i $PWD/id_ed25519_sk_rk" git ...` to use the key with git operations.

##### QUALITY OF LIFE

We can add ssh key commands in the two static password slots to repurpose it to store helpful commands.

1.  Clear the short touch slot to avoid accidental triggers.
    a. _Optionally add static password here_

```bash
ykman otp static 1 --keyboard-layout us --no-enter << EOF

y
EOF
```

2.  Add `ssh-keygen -K` to the long touch slot.

```bash
ykman otp static 2 --keyboard-layout us << EOF
ssh-keygen -K
y
EOF
```

### VMWare VM

When connecting yubikey over USB with a VM running you should be prompted to optionally connect it to the VM. Now it should work in the VM.
