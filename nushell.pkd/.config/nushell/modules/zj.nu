# Module for integrating nushell and zellij
# provides:
#  - tab renaming hooks
#  - session manager command with flag-based actions
#
# Usage:
#   `use zj.nu`
#   `zj`              # start new session
#   `zj my-project`   # start named session
#   `zj -l`           # list running sessions
#   `zj -l --all`     # list all sessions (including exited)
#   `zj -a dev`       # attach to "dev"
#   `zj -r old`       # recover exited "old" session
#   `zj -k dev`       # kill "dev"
#   `zj -K`           # kill all running sessions
#   `zj -d old`       # delete exited "old" session
#   `zj -D`           # delete all exited sessions
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

# Zellij session manager.
#
# Start a new zellij session by default. Use flags for other actions.
# Only one action flag may be used at a time.
#
# Examples
#
#   Start a new session:
#   `zj`
#
#   Start a named session:
#   `zj my-project`
#
#   List running sessions:
#   `zj -l`
#
#   Attach to a running session:
#   `zj -a dev`
#
#   Recover an exited session:
#   `zj -r old-project`
#
#   Kill a running session:
#   `zj -k dev`
#
#   Kill all running sessions:
#   `zj -K`
#
#   Delete an exited session:
#   `zj -d old-project`
#
#   Delete all exited sessions:
#   `zj -D`
export def main [
  session?: string # new session name (default action)
  --list (-l)     # list sessions
  --attach (-a): string@sessions-completer  # attach to a running session
  --recover (-r): string@dead-sessions-completer  # recover an exited session
  --kill (-k): string@sessions-completer   # kill a running session
  --kill-all (-K) # kill all running sessions
  --delete (-d): string@dead-sessions-completer  # delete an exited session
  --delete-all (-D) # delete all exited sessions
] {
  # count action flags to enforce mutual exclusivity
  let action_count = [
    $list
    ($attach | is-not-empty)
    ($recover | is-not-empty)
    ($kill | is-not-empty)
    $kill_all
    ($delete | is-not-empty)
    $delete_all
  ] | where {|it| $it } | length

  if $action_count > 1 {
    error make "Only one action flag allowed at a time"
  }

  # dispatch based on which flag was provided
  if $list {
    assert-session false
    parse-sessions
  } else if ($attach | is-not-empty) {
    assert-session false
    zellij attach $attach
  } else if ($recover | is-not-empty) {
    assert-session false
    zellij attach $recover
  } else if ($kill | is-not-empty) {
    assert-session false
    zellij kill-session $kill
  } else if $kill_all {
    assert-session false
    zellij kill-all-sessions
  } else if ($delete | is-not-empty) {
    assert-session false
    zellij delete-session $delete
  } else if $delete_all {
    assert-session false
    zellij delete-all-sessions
  } else {
    # default: start a new session
    assert-session false
    if ($session | describe) == "string" {
      zellij --session $session
    } else {
      zellij
    }
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
export def "zj rename" [
  name: string # new session name
  ...args: string
] {
  assert-session true
  let name = ([$name] | append $args) | str join " "
  zellij action rename-session $name
}
