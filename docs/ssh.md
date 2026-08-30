# SSH Setup

## SSH Config Structure

`~/.ssh/config` is managed by chezmoi and contains global defaults only:

```sshconfig
Include ~/.ssh/config.local

Host *
  SendEnv COLORTERM
  IdentityFile ~/.ssh/keys/yubikey_ssh
  IdentityAgent none
```

Per-machine host entries go in `~/.ssh/config.local` (not managed by chezmoi). SSH merges both files; entries in `config.local` are parsed before the `Host *` catch-all, so host-specific settings take precedence.

Example `~/.ssh/config.local`:

```sshconfig
Host helotrix
  HostName helotrix.mscsnet.mu.edu
  User schristensen34

Host argolis
  HostName university.example.edu
  User scc
```

## Yubikey

The yubikey SSH key is configured as the default identity for all hosts in the chezmoi-managed `~/.ssh/config`. See [yubikey.md](./yubikey.md) for key generation and setup.

Requirements:

- SSH must be linked to libfido2 (e.g., `/opt/homebrew/bin/ssh` on macOS)
- Key file at `~/.ssh/keys/yubikey_ssh` (and `.pub`)

## Nushell auto-detect over SSH

To automatically enter nushell on remote hosts that have it installed, add `RemoteCommand` and `RequestTTY` to host entries in `~/.ssh/config.local`:

```sshconfig
Host helotrix
  HostName helotrix.mscsnet.mu.edu
  User schristensen34
  RemoteCommand sh -lc 'if command -v nu >/dev/null 2>&1; then exec nu; else exec $SHELL; fi'
  RequestTTY yes
```

`sh -lc` is required to pick up environment variables from the remote profile before launching nushell.
