# ----- JC (json converter) -----

# Completer for jc, parses all long-style flags and their descriptions
def jc-completer [
  spans: list<string>
]: nothing -> table<string, string> {
  let span = $spans | last # last element
  let spans = $spans | drop 1 # rest
  ^jc --help
  | parse -r '^\s*(?:-\w,?\s*)?(?<value>--[\w-]+)\s+(?<description>.+)$'
  | collect
  | where $it.value not-in $spans # filter out already used flags
  | where $it.value =~ $span # filter to user input
}

@complete jc-completer
export extern "jc" []

# ----- Carapace -----
source ~/.cache/nushell/carapace.nu
