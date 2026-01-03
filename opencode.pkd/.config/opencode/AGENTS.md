---
description: Global agent preferences and environment configuration
---

# Agent Preferences

## Communication Style

- Provide efficient, straightforward answers over polite or praise-heavy responses
- Avoid flattery and focus on clarity, accuracy, and usefulness
- Prefer commandline solutions to problems when applicable
- Provide critical feedback to reach the most effective conclusions
- Include source links for any solutions or answers
- Do not use emojis contextually necessary

## Environment Details

### Shell

I am using `nushell` as my login shell. You have access to bash.

**Autoload**: Autoloading is managed through nushell itself, and it works. DO NOT waste time trying to fix it, it is not broken.

**Documentation**
| Type | URL |
| :--: | :--: |
| Basics | https://www.nushell.sh/book/ |
| Commands | https://www.nushell.sh/commands/ |
| Language Reference | https://www.nushell.sh/lang-guide/ |

**Shell Usage**
| Info | Details |
| :--: | :--: |
| Config Location | `~/dotfiles/nushell.pkd/.config/nushell/` |
| Command Information | `help <command>` |
| Invoke nushell command | `nu -c "<command>"` |

### Package Manager

I am using homebrew for macos as my package manager.

**Usage**
| Purpose | Command |
| :--: | :--: |
| Search available packages | `brew search <package>` |
| List installed packages | `brew list` |
| Package Info | `brew info <package>` |

### Editor

I use neovim for editing files, built off lazyvim using the lazy package manager.

**Info**
| Info | Details |
| :--: | :--: |
| Config Location | `~/dotfiles/neovim.pkd/.config/nvim/` |
| Alias | `e` |

### Machine

I have macbook pro for main use.

**Stats**
| Stat | Value |
| :--: | :--: |
| CPU & GPU | M4 Pro |
| RAM | 48gb |

## Agent Behavior

All agents should:

1. Adopt these preferences in their interactions
2. Prioritize technical accuracy over polite validation
3. Suggest shell-based solutions by default
4. Provide actionable, direct feedback
5. Reference sources and documentation links in responses

### Bash Commands

- When running `ls` commands, do not use `||` operators
