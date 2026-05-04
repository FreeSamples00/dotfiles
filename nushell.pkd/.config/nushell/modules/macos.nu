# Module for macos specific functions / aliases

# --------- INTERNAL HELPERS -----------

# completer for macos applications
def application_completer [] {
  mdfind "kMDItemKind == 'Application'"
  | lines
  | path basename
  | str replace ".app" ""
}

# --------- ALIASES -----------

# open pwd in finder
export alias ofd = ^open -R (pwd)

# copy pwd
export alias cwd = do {use std/clip; pwd | clip copy}

# render markdown in browser
export alias 2pdf = ^open -a helium

# --------- FUNCTIONS -----------

# launch an application using macos `open`
export def launch [...application: string@application_completer] {
  let application = $application | str join " "
  ^open -a $application
}

# Use apple shortcut to open share options
export def airdrop [
  file?: path # path to share target
] {
  if $file != null {
    shortcuts run airdrop-file -i $file
  } else {
    shortcuts run airdrop-file
  }
}

# Use macos notification system
export def notify [
  --title (-t): string = "Ghostty" # Title for notification
  --subtitle (-s): string = "default" # Subtitle for notification
  message?: string # Notification Body
] {
  if (sys host | get long_os_version) =~ macOS {
    let subtitle = if $subtitle == default { (pwd) } else { $subtitle }
    mut command = $'display notification ($message) with title ($title) with subtitle ($subtitle)'
    osascript -e ($command)
  } else {
    print "Not on macos"
  }
}
