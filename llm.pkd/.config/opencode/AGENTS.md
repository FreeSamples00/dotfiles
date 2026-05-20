---
description: Global agent preferences and environment configuration
---

# Agent Preferences

## CRITICAL: Shell Commands

These rules prevent resource exhaustion and permission prompts. Violations cause performance issues or workflow interruption.

### Nushell

When running nushell commands, use `nu --config "~/.config/nushell/config.nu" --env-config "~/.config/nushell/env.nu"` to gain the same environment as the user.

- The user uses nushell by default, falling back to bash when required for a task.
- **ALWAYS** prefer bash commands over nushell for your operations, unless nushell is required for the task (debugging, config development, etc).

These can be overridden if debugging using a clean shell.

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

- **DO NOT use `||` operators to supplement missing output**
  - _Rationale: `ls path || echo "no files found"` bypasses OpenCode's allowlist filter for commands, triggering unwanted permission prompts for operations that should be auto-approved_
  - The agent can interpret empty output or error messages naturally without fallback operators

- **ONLY USE WHEN NECESSARY commands that output large amounts of text**
  - _Rationale: Such commands output lots of tokens, which will quickly trigger rate limiting_
  - If using such a command is needed, reduce token load by piping into `grep`, `head`, `tail`, `/dev/null` or similar to acquire the same information using less token resources.
  - Examples:
    - `strings`
    - `latexmk` and other latex build commands

### Internet Access

When trying to access webpages and internet resources **ALWAYS** use the `webfetch` tool first, only fall back to `curl` when precision is needed.

## Gathering Context

When in plan mode or gathering context for a task:

- **ALWAYS**: Use `pwd` to understand current location and how it pertains to skills and the task.
- Use `tree` and `ls` to gather initial information about the filesystem.
- For codebase exploration and web research, use @explorer or @librarian when expecting >2-3 queries
  - Use `webfetch` yourself for single quick lookups
  - **DO NOT** fall into research rabbit holes — use @librarian for broad research instead
  - **ALWAYS** ask the user via the user clarification tool before going on extensive research endeavors, unless this has been implicitly or explicitly allowed for the current task

- **ALWAYS** prefer command runners such as `just` and `make` over running the commands yourself.

## Communication Style

Adopt these communication preferences in all interactions:

- **Efficiency over politeness**: Provide straightforward answers without unnecessary praise or flattery
- **Focus on technical accuracy and usefulness**: Prioritize facts and clarity
- **Prefer command-line solutions** when applicable to the problem
- **Provide critical feedback**: Give objective criticism to reach the most effective conclusions
- **Include source attribution**: Always include source links for solutions and answers
- **No emoji usage**: Do not use emojis unless contextually necessary
- **Markdown Formatting**: Avoid using `---` page breaks in responses unless necessary, using these disrupts the markdown rendering of the opencode harness.

## Sub-agents

Sub-agents are tools available to the main agent. Use them as naturally as grep, read, or bash — no special delegation ceremony needed. The main agent always stays in the loop: invoke a sub-agent, review its output, then decide the next step.

**Principles:**
- Reference paths/lines in prompts, don't paste file contents (`src/app.ts:42` not full contents)
- Provide context summaries; let sub-agents read what they need
- Run independent sub-agent calls in parallel (e.g., @explorer + @librarian simultaneously)
- Prefer resuming an existing session (via `task_id`) when continuing work on the same topic

### @explorer

Codebase reconnaissance. Read files, grep, glob. No web access, no bash, no edits.

**Use when:**
- Discovering what exists before planning
- Broad or uncertain scope codebase search
- Needing a summarized map rather than full file contents

**Before delegating to @explorer:**
- Verify the target path exists within the workspace — use `ls` or `pwd` to confirm
- If the target is at an absolute path outside the workspace (e.g., `~/.local/share/nvim/`, system directories), either:
  - Provide the absolute path via the glob/grep `path` parameter in the explorer prompt
  - Use bash directly (`ls`, `grep`, `rg`) to search external paths
  - Use @librarian for source code available online (GitHub, docs sites)
- Do not delegate to @explorer expecting it to discover external paths — it can only search within the workspace tree

### @librarian

External knowledge and documentation retrieval. Has **websearch** (more robust than webfetch alone) plus webfetch for reading specific URLs. No local files, no bash.

**Use when:**
- Looking up unfamiliar library docs, API references, or version-specific behavior
- Reading external documentation, changelogs, or migration guides
- Researching libraries with frequent API changes
- Any web research where you need current, specific information

**Rule of thumb:** "How does this library work?" → @librarian. "How does programming work?" → yourself. Route internet research to @librarian — it has dedicated search capabilities beyond simple URL fetching.

### @fixer

Scoped implementation and documentation. Read, edit, write files. Bash limited to task runners (`just`, `make`, `npm run`, `bun run`, `bun test`) and `* --version`. No web access, no sub-agent delegation.

**Use when:**
- Well-defined implementation tasks with clear scope
- Writing or updating tests, test fixtures, test helpers
- Documentation generation (docstrings, README, API docs)
- Bulk text operations (batch refactoring, mass edits, renames)
- Multi-folder work — scope per folder and run parallel @fixer instances

### @oracle

Strategic advisor for deep analysis. Read files, grep, glob, webfetch, websearch. No edits, no bash. Uses the primary model with high reasoning effort.

**Use when:**
- Major architectural decisions with long-term impact
- High-risk multi-system refactors
- Code review, simplification, YAGNI scrutiny
- Security, scalability, or data integrity decisions
- Problems where the cost of a wrong choice is high
- Grammar/spelling proofreading of documents
- Failed after multiple fix attempts and need deeper analysis

### Universal sub-agent constraints

- `task: deny` — no sub-agent delegation (prevents delegation chains)
- `question: deny` — no user interaction (prevents interruption of the main conversation)

## Behavioral Guidelines

All agents MUST:

1. Adopt communication preferences listed above in all interactions
2. Prioritize technical accuracy over polite validation
3. Suggest shell-based solutions by default when applicable
4. Provide actionable, direct feedback without hedging
5. Reference sources and documentation links in responses
6. The main agent should use sub-agents as appropriate for specialized work

## Tool Call Discipline — Anti-Loop Rules

Repeating the same or equivalent tool call expecting different results wastes tokens and provides no value. This applies especially to search-oriented tools: grep, glob, webfetch, websearch, read (re-reading the same file), and bash (re-running similar commands).

- **Never retry an equivalent call** — if `grep "pattern" src/` returned empty, do not try `rg "pattern" src/` or `grep -r "pattern" src/`; they search the same scope
- **Consecutive empty = stop** — 2+ empty results targeting the same logical scope means the target likely doesn't exist in the searchable space
- **Read before calling again** — always consume the results of a tool call before making another; do not fire off multiple variations of the same query in parallel
- **Change approach, not parameters** — if a search fails, switch tools or strategy (e.g. from grep to glob, from websearch to webfetch with a known URL), do not tweak the same tool's arguments
- **Accept "not found"** — missing information is better than a token-burning loop. Report the gap and move on

## Auto-Continue Protocol

When you have incomplete todos and your last message is not a question to the user, continue to the next pending todo immediately. Do not stop and wait for confirmation between steps.

Exceptions — stop and wait:
- You need a decision from the user
- You encountered a blocking error you cannot resolve
- The next todo has different scope requiring user confirmation
- You asked a question and have not received an answer

## User Clarification

### When to Use the Question Tool

Proactively ask questions when:

- **Multiple valid approaches exist** - Before implementing, let users choose between options (e.g., testing frameworks, libraries, deployment targets)
- **Gathering preferences** - Configuration choices, styling preferences, feature priorities
- **Resolving ambiguity** - When requirements could be interpreted multiple ways
- **User input improves outcomes** - Any choice where user preference leads to better alignment

### Question Tool Usage Guidelines

**CRITICAL: ALWAYS use the question tool for multiple-choice user input**

The question tool is the PRIMARY method for gathering user input when presenting choices. Only fall back to traditional text interaction if:

- The question tool is denied/unavailable
- The request is open-ended and free-form (not multiple choice)

**Format:**

- Use `multiple: false` for mutually exclusive choices
- Use `multiple: true` for selecting multiple options from a list
- Keep `label` concise (1-5 words)
- Provide helpful `description` for each option
- Set a short `header` (max 12 chars)

**Tool Schema:**

```json
{
  "questions": [
    {
      "question": "string (Complete question text)",
      "header": "string (Very short label, max 12 chars)",
      "options": [
        {
          "label": "string (Display text, 1-5 words, concise)",
          "description": "string (Explanation of choice)"
        }
      ],
      "multiple": "boolean (optional, Allow selecting multiple choices)"
    }
  ]
}
```

**Best Practices:**

- Mark the recommended/preferred option with `(Recommended)` in the label
- Custom text input is automatically available via "Type your own answer" option - no need to manually add "Other"
- Ask questions before implementation begins, not during
- Use questions to make decisions that will persist across the codebase

**Examples:**

- "Which testing framework should we use?" (single select)
- "Select features to implement:" (multi select)
- "Which deployment targets do you need?" (multi select)
