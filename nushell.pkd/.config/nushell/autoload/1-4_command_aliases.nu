# Nvim wrapper
def e [...args: path] { nvim ...$args }

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }

# macos copy wrapper
def copy [
  --raw (-r) # Copy raw data
  --format (-f): string@[json md csv yaml] = json # Copy as format
]: any -> nothing {
  if $raw {
    $in | pbcopy
  } else {
    try {
      let data = $in
      match $format {
        "json" => ($data | to json | pbcopy)
        "md" => ($data | to md | pbcopy)
        "csv" => ($data | to csv | pbcopy)
        "yaml" => ($data | to yaml | pbcopy)
        $other => $"Format '($format)' not recognized"
      }
    } catch {$"Could not convert to ($format)"}
  }
}

# macos paste wrapper
def paste [
  --format (-f): string@[csv html json md toml tsv xml yaml yml] # Output format
]: nothing -> any {
  if $format != null {
    try {
      match $format {
        "csv" => (pbpaste | to csv)
        "html" => (pbpaste | to html)
        "json" => (pbpaste | to json)
        "md" => (pbpaste | to md)
        "toml" => (pbpaste | to toml)
        "tsv" => (pbpaste | to tsv)
        "xml" => (pbpaste | to xml)
        "yaml" => (pbpaste | to yaml)
        "yml" => (pbpaste | to yml)
        $other => $"Format '($other)' not recognized"
      }
    } catch { $"Could not convert to ($format)" }
  }
}
