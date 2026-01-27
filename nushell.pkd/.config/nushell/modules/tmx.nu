
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
  | parse "{name}: {windows} windows (created {time})"
  | update time {|| $in | into datetime | date humanize}
  | if ($in | length) == 0 {$in | ignore} else {$in}
}

export def new [
  name?: string # session name
  --background (-b) # create in background
] {
  mut args = []
  if $name != null { $args = $args | append [-s $name] } else {[]}
  if $background { $args = $args | append [-d] } else {[]}
  tmux new-session ...$args
}

export def kill [
  ...sessions: string@session-completer # sessions to delete
] {
  $sessions
  | each {|| tmux kill-session -t $in} | ignore
}
