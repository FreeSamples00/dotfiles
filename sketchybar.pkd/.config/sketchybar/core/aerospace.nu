#!/usr/bin/env nu -n

# Timeout for aerospace CLI calls. Prevents orphaned processes from hanging
# when the daemon connection is lost.
# See: https://github.com/nikitabobko/AeroSpace/discussions/1682
const timeout_secs = 3

# Run an aerospace command with a kill timeout.
# Returns trimmed stdout, or empty string on timeout/error.
# Prints error to stdout on failure.
export def aero [args: list<string>] {
  let result = ^timeout --signal=KILL $timeout_secs aerospace ...$args | complete
  if $result.exit_code < 0 {
    let cmd = $args | str join " "
    print $"aero: timed out or killed: ($cmd)"
    return ""
  }
  if $result.exit_code != 0 {
    let cmd = $args | str join " "
    print $"aero: exit ($result.exit_code): ($cmd)"
    return ""
  }
  $result.stdout | str trim
}
