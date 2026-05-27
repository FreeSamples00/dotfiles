# Zellij auto-tab-rename module
# Renames zellij tabs based on the running command or current directory
# Requires: zellij >= 0.39.0 (for `action rename-tab`)
#
# Hooks injected via `export-env`:
#   - pre_execution: rename tab to the command being run
#   - pre_prompt:    rename tab to current directory basename (when back at prompt)
#
# Both hooks are gated on $env.ZELLIJ — no side-effects outside zellij

# Commands that don't make useful tab names (navigation / shell builtins)
const skip_commands = [
  "z"
  "cd"
  "__zoxide_z"
  "__zoxide_zi"
  "zellij"
  "e"
  "reload"
  "c"
  "cls"
  "exit"
  "source"
]

# Rename the current zellij tab (fire-and-forget, suppresses all output)
def rename-tab [name: string] {
  try { ^zellij action rename-tab $name out> /dev/null err> /dev/null }
}

# ── Pre-execution: name tab after the running command ─────────
# Uses `commandline` to read the current REPL input, extracts the
# first word, and renames the tab if it's not in the skip list.
def pre-exec-rename [] {
  let cmd = (
    commandline
    | str trim
    | split row " "
    | first
    | str trim
  )
  if ($cmd | is-not-empty) and ($cmd not-in $skip_commands) {
    rename-tab $cmd
  }
}

# ── Pre-prompt: name tab after the current directory ──────────
# When we return to the prompt (command finished), show the
# basename of the working directory instead of the stale command.
def pre-prompt-rename [] {
  rename-tab ($env.PWD | path basename)
}

# ── Inject hooks into nushell config ──────────────────────────
# export-env runs once when the module is loaded, appending our
# hooks to any existing hooks without clobbering them.
export-env {
    if "ZELLIJ" in $env {
        $env.config = ($env.config | upsert hooks.pre_execution {|c|
            let existing = $c | get -o hooks.pre_execution | default []
            $existing | append {|| pre-exec-rename }
        })
        $env.config = ($env.config | upsert hooks.pre_prompt {|c|
            let existing = $c | get -o hooks.pre_prompt | default []
            $existing | append {|| pre-prompt-rename }
        })
    }
}
