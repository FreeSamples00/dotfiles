# add completers to external commands

# ----- JC (JSON converter) -----
def jc-completer [spans: list<string>]: nothing -> table<string: any, string: any> {
  let span = $spans | last # last element
  let spans = $spans | drop 1 # rest
  ^jc --help
  | parse -r '^\s*(?:-\w,?\s*)?(?<value>--[\w-]+)\s+(?<description>.+)$'
  | collect
  | where $it.value not-in $spans
  | where $it.value =~ $span # filter to user input
}

@complete jc-completer
export extern "jc" []
