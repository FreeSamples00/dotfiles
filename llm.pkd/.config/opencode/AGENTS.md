---
description: Global agent preferences and environment configuration
---

# Agent Preferences

## Shell Commands

### Nushell

The user uses nushell by default. When running nushell commands, use `nu --config "~/.config/nushell/config.nu" --env-config "~/.config/nushell/env.nu"` to gain the same environment.

- **ALWAYS** prefer bash commands over nushell for your operations, unless nushell is required for the task (debugging, config development, etc).

### Search and File Operations

- **NEVER run searches from the home directory** (`~` or `/Users/scc`) — navigate to a specific project directory first
- **ALWAYS limit search scope** when working outside project directories — use `--max-depth` with explicit depth limit
- Before using `rg`, `grep`, or the Grep tool, verify current directory is a project root or subdirectory

**Bash Command Constraints**

- **DO NOT use `||` operators to supplement missing output** — empty output or error messages are fine; `||` bypasses the allowlist filter and triggers permission prompts
- **Minimize commands that output large amounts of text** — pipe into `grep`, `head`, `tail`, or `/dev/null` when possible (e.g., `strings`, `latexmk`)

### Internet Access

Use the `webfetch` tool first, only fall back to `curl` when precision is needed.

## Communication Style

- **Efficiency over politeness**: Straightforward answers without unnecessary praise or flattery
- **Technical accuracy first**: Prioritize facts and clarity
- **Prefer command-line solutions** when applicable
- **Provide critical feedback**: Objective criticism to reach effective conclusions
- **Include source attribution**: Always include source links
- **No emoji usage**: Do not use emojis unless contextually necessary
- **Avoid `---` page breaks** — disrupts markdown rendering in the opencode harness

## Tool Call Discipline

### Image Files

- **Do NOT read images directly** — the Read tool claims image support but the main agent cannot interpret visual content
- **ALWAYS delegate to the `@vision` subagent** for any image viewing, description, comparison, or verification task

### Task Tracking

- **Create a todo list** when a task has multiple distinct steps — especially for investigative or multi-file operations, and when steps are dependant upon each other
- **Do not recreate** todos that already exist in the current session

### Anti-Loop Rules

Repeating the same or equivalent tool call expecting different results wastes tokens and provides no value.

- **Never retry an equivalent call** — if `grep "pattern" src/` returned empty, do not try `rg "pattern" src/`; they search the same scope
- **Consecutive empty = stop** — 2+ empty results targeting the same logical scope means the target likely doesn't exist
- **Read before calling again** — always consume results before making another call; do not fire multiple variations in parallel
- **Change approach, not parameters** — if a search fails, switch tools or strategy, do not tweak the same tool's arguments
- **Accept "not found"** — missing information is better than a token-burning loop. Report the gap and move on
