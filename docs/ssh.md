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

```sshconfig
Host <shorthand>
  ...
  RemoteCommand if (command -v nu > /dev/null); then exec nu; fi
  RequestTTY yes
```
