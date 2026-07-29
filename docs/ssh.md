# SSH Setup

## Yubikey

To use yubikey SSH key authentication by default add this to the end of `~/.ssh/config`.

```sshconfig
Host *
  SendEnv COLORTERM
  IdentityFile ~/.ssh/keys/yubikey_ssh
  IdentityAgent none # macos SSH agent does not work with yubikey
```

## Nushell auto-detect

To automatically enter nushell over ssh, add the following to each host that may have nushell installed.
`sh -lc` is required to pick up any important env vars from the remote profile.

```sshconfig
Host <shorthand>
  ...
  RemoteCommand sh -lc 'if command -v nu >/dev/null 2>&1; then exec nu; else exec $SHELL; fi'
  RequestTTY yes
```
