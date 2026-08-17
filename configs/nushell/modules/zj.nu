# Module for integrating nushell and zellij
# provides:
#  - tab renaming hooks
#  - session manager sub-commands
#
# Usage:
#   `use zj.nu`
#   `zj`              # show help table
#   `zj dev`          # attach to running "dev" (shorthand for `zj attach`)
#   `zj new`          # start new auto-named session
#   `zj new my-proj`   # start named session
#   `zj ls`           # list running sessions
#   `zj ls --all`     # list all sessions (including exited)
#   `zj attach dev`   # attach to running "dev"
#   `zj recover old`  # recover exited "old"
#   `zj kill dev`     # kill running "dev"
#   `zj kill --all`   # kill all running sessions
#   `zj delete old`   # delete exited "old"
#   `zj delete --all` # delete all exited sessions
#   `zj rename foo`   # rename current session

# ========== Internal Helpers ==========

# assert zellij session state
def assert-session [
  state: bool # true = must be in session, false = must not be
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

# completer for exited sessions
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

# completer for running sessions
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

# ========== Exported Commands ==========

# Show available commands, or attach to a running session (shorthand for `zj attach`).
export def main [
  session?: string@sessions-completer  # running session to attach to
] {
  if $session != null {
    assert-session false
    zellij attach $session
  } else {
    scope commands
    | where name starts-with "zj " and name != "zj main"
    | update name { $in | str replace "zj " "" }
    | select name description
    | %rename command description
    | table -e
  }
}

# Start a new zellij session.
#
# Examples
#
#   `zj new`          # auto-named session
#   `zj new my-proj`  # named session
export def new [
  session?: string  # optional session name
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
# `zj ls` shows running sessions only.
# `zj ls --all` includes exited sessions.
export def ls [
  --all (-a)  # include exited sessions
] {
  assert-session false
  let sessions = (parse-sessions)
  if $all { $sessions } else {
    $sessions | where live
  }
}

# Attach to a running session.
export def attach [
  name: string@sessions-completer  # running session to attach to
] {
  assert-session false
  zellij attach $name
}

# Recover an exited session.
export def recover [
  name: string@dead-sessions-completer  # exited session to recover
] {
  assert-session false
  zellij attach $name
}

# Kill running session(s).
#
# Examples
#
#   `zj kill dev`   # kill one running session
#   `zj kill --all` # kill all running sessions
export def kill [
  session?: string@sessions-completer  # running session to kill
  --all (-a)                            # kill all running sessions
] {
  assert-session false
  # exactly one of [session, --all] required
  if ($all and $session != null) or (not $all and $session == null) {
    error make "Specify either a session name or --all"
  }
  if $all {
    zellij kill-all-sessions
  } else {
    zellij kill-session $session
  }
}

# Delete exited session(s).
#
# Examples
#
#   `zj delete old`   # delete one exited session
#   `zj delete --all` # delete all exited sessions
export def delete [
  session?: string@dead-sessions-completer  # exited session to delete
  --all (-a)                                # delete all exited sessions
] {
  assert-session false
  # exactly one of [session, --all] required
  if ($all and $session != null) or (not $all and $session == null) {
    error make "Specify either a session name or --all"
  }
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
#   `zj rename my-project`
#
#   Rename with multiple words:
#   `zj rename my cool project`
export def rename [
  name: string # new session name
  ...args: string
] {
  assert-session true
  let name = ([$name] | append $args) | str join " "
  zellij action rename-session $name
}
