# add completers to external commands

# ----- JC (JSON converter) -----
def _jc-completer [spans: list<string>]: nothing -> table<string: any, string: any> {
  let span = $spans | last # last element
  let spans = $spans | drop 1 # rest
  ^jc --help
  | parse -r '(?m)^\s*(?:(?<short>-\w),\s+)?(?<value>--\S+)\s+(?<description>.+)'
  | collect
  | where $it.value not-in $spans and $it.value =~ $span
}

@complete _jc-completer
export extern "jc" []

# ----- TDF (TUI pdf viewer) -----
def _tdf-completer [spans: list<string>]: nothing -> table<string: any, string: any> {
  let path = $spans | skip 1 | first | default -e ""
  ls ($"($path)*" | into glob) --mime-type
  | where type in ["application/pdf" "dir"]
  | sort-by type
  | each {|row|
    match $row.type {
      "application/pdf" => { value: $row.name, style: yellow}
      "dir" => { value: $"($row.name)/", style: light_blue}
    }
  }
}

@complete _tdf-completer
export extern tdf [
  file: string
]
