# Commands to activate OSC (shell integration) features

# Tool for activating OSC features
#
# Subcommands:
#   progress: manage progress bar animations
#   notify: send OS notification from terminal
#   change-icon: change terminal title icon
#   change-title: change terminal window title
export def main [] {
  print "Use `--help` or `help osc`"
}

def progress-completer [] {
  [
    {value: off description: "Disable progress bar"}
    {value: update description: "Update progress (0-100)"}
    {value: error description: "Display error in progress; optionally update value"}
    {value: unknown description: "Indicate progress currently unknown"}
    {value: pause description: "Indicate pauses progress; optionall update value"}
  ]
}

# Use OSC 9;4 to update the progress bar
#
# Options:
#   - off: turn off progress bar
#   - update: change or start progress bar (needs value)
#   - error: indicate error (optional value)
#   - unknown: indicate unknown progress (no value)
#   - pause: indicate paused progress (optional value)
export def progress [
  state: string@progress-completer # State update to progress dislpay
  value?: int # Progress to display (0-100)
] {
  mut command = "\e]9;4"
  $command = $command + (match $state {
    off => ";0"
    update => ";1"
    error => ";2"
    unknown => ";3"
    pause => ";4"
  })
  if $value != null {
    $command = $command + $";($value)"
  }
  print -n $command
}

# Use OSC 9 to display a notification
export def notify [
  text: string # Text for notification
] {
  print -n $"\e]9;($text)\e"
}

# Use OSC 1 to change the window icon name
export def change-icon [
  icon: string # Icon name
] {
  print -n $"\e]1;($icon)\e"
}

# Use OSC 2 to change window title
export def change-title [
  title: string # Window title
] {
  print -n $"\e]2;($title)\e"
}
