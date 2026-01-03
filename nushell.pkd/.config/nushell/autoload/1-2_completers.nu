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

# Completer for get-ignore, supplies project types
def ignore-completer [
  spans: list<string>
]: nothing -> table<value: string> {
  let cache = "~/.cache/nushell/ignore-cache.json" | path expand
  let list = if ($cache | path type) == file {
    open $cache
  } else {
    let data = (
      http get https://www.toptal.com/developers/gitignore/api/list
      | split words
      | wrap value
      | uniq
    )
    $data | save -f $cache
    $data
  }
  $list
  | where $it.value =~ ($spans | last)
}
