# Module for integrating nushell and zellij
# provides:
#  - tab renaming hooks
#  - helper command for quick usage

# ========== Hooks ==========

const do_hooks = false

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
    if "ZELLIJ" in $env and $do_hooks {
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

# ========== Helper Command ==========

# assert zellij session
def assert-session [
  state: bool # session state
] {
  if $state != ("ZELLIJ" in $env) {
    error make (
      if $state { "Must be in zellij session" } else { "Cannot be in zellij session" }
    )
  }
}

# Parse available zellij sessions
def parse-sessions []: nothing -> table<name: string, created: datetime, live: bool> {
  zellij ls -n
  | collect
  | parse --regex '(?<name>\S+) \[Created (?<created>.+)\] (?:\((?<live>\w+))?'
  | upsert live {|row|
    match $row.live {
      "EXITED" => false
      _ => true
    }
  }
  | update created {|row| $row.created | date from-human}
  | sort-by live created --reverse
}

# complete for exited sessions
def dead-sessions-completer [] {
  parse-sessions
  | where not live
  | each {
    {
      value: $in.name
      description: $"($in.created)"
    }
  }
}

# complete for running sessions
def sessions-completer [] {
  parse-sessions
  | where live
  | each {
    {
      value: $in.name
      description: $"($in.created)"
    }
  }
}

# Zellij session manager.
#
# Quick commands for managing zellij sessions
#
# Example
#
#   Start a new zellij session:
#   `z`
#
#   Start a named session:
#   `z my-project`
#
# Subcommands
#
#   `z` - start a new session (this command)
#   `z list` - list sessions
#   `z attach` - attach to a running session
#   `z recover` - recover a dead session
#   `z kill` - kill a running session
#   `z delete` - delete a dead session
#   `z rename` - rename the current session
export def z [
  session?: string # new session name
] {
  assert-session false
  if ($session | describe) == "string" {
    zellij --session $session
  } else {
    zellij
  }
}

# List zellij sessions.
#
# Shows running sessions by default. Use --all to include exited sessions.
#
# Example
#
#   List running sessions:
#   `z list`
#
#   List all sessions including exited ones:
#   `z list --all`
export def "z list" [
  --all (-a) # list dead sessions
] {
  assert-session false
  parse-sessions
  | if $all {
    $in
  } else {
    $in
    | where live
    | select name created
  }
}
export alias "z ls" = z list

# Attach to a running zellij session.
#
# Connects to an existing running session by name.
#
# Example
#
#   Attach to a session named "dev":
#   `z attach dev`
export def "z attach" [
  session: string@sessions-completer # session name
] {
  assert-session false
  zellij attach $session
}
export alias "z a" = z attach

# Recover an exited zellij session.
#
# Attaches to a previously exited session, restoring it.
#
# Example
#
#   Recover the session named "old-project":
#   `z recover old-project`
export def "z recover" [
  session: string@dead-sessions-completer # session name
] {
  assert-session false
  zellij attach $session
}

# Kill a running zellij session.
#
# Terminates a running session by name, or kills all sessions with --all.
#
# Example
#
#   Kill a session named "dev":
#   `z kill dev`
#
#   Kill all running sessions:
#   `z kill --all`
export def "z kill" [
  session?: string@sessions-completer # session name
  --all (-a) # kill all sessions
] {
  assert-session false
  if $all {
    zellij kill-all-sessions
  } else {
    zellij kill-session $session
  }
}

# Delete an exited zellij session.
#
# Permanently removes an exited session by name, or deletes all exited sessions with --all.
#
# Example
#
#   Delete an exited session named "old-project":
#   `z delete old-project`
#
#   Delete all exited sessions:
#   `z delete --all`
export def "z delete" [
  session?: string@dead-sessions-completer # session name
  --all (-a) # delete all sessions
] {
  assert-session false
  if $all {
    zellij delete-all-sessions
  } else {
    zellij delete-session $session
  }
}

# Rename the current zellij session.
#
# Changes the name of the session you are currently in. Must be run from inside a zellij session.
#
# Example
#
#   Rename the current session to "my-project":
#   `z rename my-project`
#
#   Rename with multiple words:
#   `z rename my cool project`
export def "z rename" [
  name: string # new session name
  ...args: string
] {
  assert-session true
  let name = ([$name] | append $args) | str join " "
  zellij action rename-session $name
}
