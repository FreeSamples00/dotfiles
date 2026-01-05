---
description: Global agent preferences and environment configuration
---

# Agent Preferences

## CRITICAL: System Constraints

These rules prevent resource exhaustion and permission prompts. Violations cause performance issues or workflow interruption.

### Search and File Operations

**Search Scope - NEVER search from home directory**

- **NEVER run searches from the home directory** (`~` or `/Users/scc`)
  - _Rationale: Prevents indexing entire filesystem, causing excessive CPU/battery usage_
  - Instead: Navigate to specific project directory first
- **ALWAYS limit search scope** when working outside project directories
  - Use `--max-depth` flag with explicit depth limit
  - Ask user to confirm scope before executing broad searches
- **Before using `rg`, `grep`, or the Grep tool**:
  - Verify current directory is a project root or subdirectory
  - If in home directory, ask user to confirm scope before executing

**Bash Command Constraints**

- **DO NOT use `||` operators with `ls` commands**
  - _Rationale: `ls path || echo ...` bypasses OpenCode's allowlist filter for `ls` commands, triggering unwanted permission prompts for operations that should be auto-approved_
  - The agent can interpret empty output or error messages naturally without fallback operators

- **ONLY USE WHEN NECESSARY commands that output large amounts of text**
  - _Rationale: Such commands output lots of tokens, which will quickly trigger rate limiting_
  - If using such a command is needed, reduce token load by piping into `grep`, `head`, `tail`, `/dev/null` or similar to acquire the same information using less token resources.
  - Examples:
    - `strings`
    - `latexmk` and other latex build commands

### File Access Pattern - Dotfiles Structure

**Configuration files use a symlinked dotfiles pattern. Read from source to avoid session boundary prompts.**

**Structure**: All config directories in `~/dotfiles/` with `.pkd` extension are symlinked to their standard locations using a custom GNU stow wrapper.

**Pattern**:

- Source: `~/dotfiles/<name>.pkd/`
- Symlinked to: Standard locations (`~/.config/<name>/`, `~/.<name>/`, etc.)

**File Operations Rule**:

- **PREFER reading from** `~/dotfiles/*.pkd/*` over standard locations (`~/.config/`, `~/`, etc.)
  - _Rationale: Configs exist in `~/dotfiles/_.pkd/` and are symlinked to standard locations. Reading from source avoids session boundary prompts\*
- **Apply same pattern for writes**: Write to `~/dotfiles/*.pkd/*` rather than symlinked locations
- Standard locations are accessible if needed, but source paths avoid extra confirmation

**Known configs following this pattern**:

- Nushell: `~/dotfiles/nushell.pkd/.config/nushell/`
- Neovim: `~/dotfiles/neovim.pkd/.config/nvim/`
- OpenCode: `~/dotfiles/opencode.pkd/.config/opencode/`

_Note: Other configs may follow this pattern. When encountering a `.pkd` directory, assume it follows the same symlinking structure._

## Environment Configuration

### Shell: Nushell

**Primary shell**: `nushell` (you have access to bash for tool execution)

**IMPORTANT - Autoloading**:

- Autoloading is managed through nushell itself and is **working correctly**
- Nushell autoloads all `$XDG_CONFIG_HOME/autoload/*.nu` files during its boot process
- **DO NOT** attempt to "fix" autoloading
- **DO NOT** waste time investigating how files in the `autoload` directory are loaded as it is within nushell itself, not the configuration
- Other files autoloaded by nushell:
  - `config.nu`
  - `login.nu` (only if session has been set as a login session)
  - `env.nu`

**Documentation Resources**:
| Type | URL |
|------|-----|
| Basics | https://www.nushell.sh/book/ |
| Commands | https://www.nushell.sh/commands/ |
| Language Reference | https://www.nushell.sh/lang-guide/ |

**Shell Operations**:
| Operation | Command/Location |
|-----------|------------------|
| Config Location | `~/dotfiles/nushell.pkd/.config/nushell/` |
| Get command help | `help <command>` |
| Invoke nushell | `nu -c "<command>"` |

### Package Manager: Homebrew

**System**: macOS package manager

**Common Operations**:
| Purpose | Command |
|---------|---------|
| Search packages | `brew search <package>` |
| List installed | `brew list` |
| Package information | `brew info <package>` |

### Editor: Neovim (LazyVim)

**Configuration**: Heavily customized LazyVim distribution with Lazy package manager (no longer synced to lazyvim distribution source)

| Property        | Value                                 |
| --------------- | ------------------------------------- |
| Config Location | `~/dotfiles/neovim.pkd/.config/nvim/` |
| Alias           | `e`                                   |

### Hardware Specifications

**Machine**: MacBook Pro M4 Pro

| Component | Specification |
| --------- | ------------- |
| CPU & GPU | M4 Pro        |
| RAM       | 48GB          |

## Communication Style

Adopt these communication preferences in all interactions:

- **Efficiency over politeness**: Provide straightforward answers without unnecessary praise or flattery
- **Focus on technical accuracy and usefulness**: Prioritize facts and clarity
- **Prefer command-line solutions** when applicable to the problem
- **Provide critical feedback**: Give objective criticism to reach the most effective conclusions
- **Include source attribution**: Always include source links for solutions and answers
- **No emoji usage**: Do not use emojis unless contextually necessary

## Behavioral Guidelines

All agents MUST:

1. Adopt communication preferences listed above in all interactions
2. Prioritize technical accuracy over polite validation
3. Suggest shell-based solutions by default when applicable
4. Provide actionable, direct feedback without hedging
5. Reference sources and documentation links in responses

## Examples: Critical Rules in Practice

### Search Operations

**❌ INCORRECT - Searching from home directory:**

```bash
# Current directory: /Users/scc
rg "import" --type ts
```

_Violation: Will index entire home directory, burning CPU and battery_

**✅ CORRECT - Navigate to project first:**

```bash
cd ~/projects/my-app
rg "import" --type ts
```

**✅ CORRECT - Explicit scope with depth limit:**

```bash
rg "import" --type ts --max-depth 3 ~/projects/specific-dir
```

### Bash Command Patterns

**❌ INCORRECT - Using || with ls:**

```bash
ls /some/path || echo "Directory not found"
```

_Violation: Bypasses OpenCode's ls allowlist, triggers permission prompt_

**✅ CORRECT - Direct ls command:**

```bash
ls /some/path
```

_Agent can interpret empty output or error messages naturally_

### File Access Patterns

**❌ SUBOPTIMAL - Reading from standard locations:**

```bash
cat ~/.config/nvim/init.lua
```

_Works but triggers session boundary prompt for confirmation_

**✅ PREFERRED - Read from dotfiles source:**

```bash
cat ~/dotfiles/neovim.pkd/.config/nvim/init.lua
```

_Direct access to source, avoids extra confirmation prompt_

**✅ PREFERRED - Write to dotfiles source:**

```bash
# Writing a new config file
echo "config content" > ~/dotfiles/opencode.pkd/.config/opencode/custom.json
```

_Write to source; symlink ensures it appears in standard location_
