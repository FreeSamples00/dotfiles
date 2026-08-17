# Helper for opencode

# ========= Helpers ===========

def session-completer [] {
  opencode session list --format json --max-count 50
  | from json
  | update updated {|row|
     $row.updated * 1_000_000 
     | into datetime 
    }
  | sort-by updated --reverse
  | select id title
  | rename value description
}

# ========= Exported ===========

export def main [
  session?: string@"session-completer" # Continue a session
  --stats # show opencode stats
] {
  if ($session | is-not-empty) {
    opencode --session $session
  } else if $stats {
    opencode stats
  } else {
    opencode
  }
}
