# Yubikey

## Tools

- **Yubico Authenticator** - `yubico-authenticator`
  - GUI yubikey manager and authenticator
- **Yubico config CLI** - `ykman`
  - Manage yubikey from CLI
- **Yubico PIV tool** - `yubico-piv-tool`
  - Manages yubico PIV things
- **Lib FIDO2** - `libfido2`
  - Library for using FIDO2

## General Setup

- Use authenticator app to rename key
- Use authenticator to change:
  - FIDO2 PIN
  - PUK
  - Management Key

## SSH Key

> [!NOTE]
> From https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html

> [!CAUTION]
> Must use ssh that is linked to libfido2, e.g. /opt/homebrew/bin/ssh on macos

### Key Generation

Generate ssh key with:

```bash
ssh-keygen -t ed25519-sk -O resident -C "SSH key"
```

Move generated keys to `~/.ssh/keys/yubico_ssh` and `~/.ssh/keys/yubico_ssh.pub`

Copy the public key to a remote server:

```bash
ssh-copy-id -i ~/.ssh/keys/yubico_ssh user@host
```

OR manually place `ssh_yubico_ssh.pub` in `~/.ssh/authorized_hosts` on the remote server.

### SSH Config

Use the following to set up automatic yubikey usage:

```bash
echo -e "\nHost *\n\tIdentityFile ~/.ssh/keys/yubico_ssh\n\tIdentityAgent none" >> ~/.ssh/config
```

|            Config Elements            | Description                                                  |
| :-----------------------------------: | :----------------------------------------------------------- |
|               `Host *`                | Apply these settings to all hosts unless otherwise specified |
| `IdentityFile ~/.ssh/keys/yubico_ssh` | Sets yubico key reference as default auth method             |
|         `IdentityAgent none`          | Disables ssh agent, which tends to mess with yubikeys        |

### Portable Usage

#### Extract Keys

Use `ssh-keygen -K` to extract a reference to yubikey private key file and public key.

#### SSH Operations

Use `<ssh command> -i ./id_ed25519_sk_rk` on ssh commands to trigger yubikey for authentication.

#### Git Operations

Use `GIT_SSH_COMMAND="ssh -i $PWD/id_ed25519_sk_rk" git ...` to use the key with git operations.

### Quality of Life

We can add ssh key commands in the two static password slots to repurpose it to store helpful commands.

1. Clear the short touch slot to avoid accidental triggers.
   a. _Optionally add static password here_

```bash
ykman otp static 1 --keyboard-layout us --no-enter << EOF

y
EOF
```

2. Add `ssh-keygen -K` to the long touch slot.

```bash
ykman otp static 2 --keyboard-layout us << EOF
ssh-keygen -K
y
EOF
```

## VMWare VM

When connecting yubikey over USB with a VM running you should be prompted to optionally connect it to the VM. Now it should work in the VM.
