def session-completer [
] {
  tmux list-sessions
  | parse '{value}: {description}'
}

export def attach [
  session?: string@session-completer # session to attach to
] {
  if $session != null {
    tmux attach-session -t $session
  } else {
    tmux attach-session
  }
}

export def list [] {
  tmux list-sessions
  | parse "{name}: {windows} windows (created {time}){attached}"
  | update time {|| $in | into datetime | date humanize}
  | update attached {||
      $in | str trim
      | str replace --all --regex '[()]' ""
      | if $in == attached {true} else {false}
    }
  | if ($in | length) == 0 {$in | ignore} else {$in}
}

export def new [
  name?: string # session name
  --background (-b) # create in background
] {
  mut args = []
  if $name != null { $args = $args | append [-s $name] } else {[]}
  if $background { $args = $args | append [-d] } else {[]}
  tmux new-session ...$args nu
}

export def kill [
  ...sessions: string@session-completer # sessions to delete
] {
  $sessions
  | each {|| tmux kill-session -t $in} | ignore
}
