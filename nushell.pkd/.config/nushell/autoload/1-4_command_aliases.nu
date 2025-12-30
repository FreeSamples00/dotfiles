# Nvim wrapper
def e [...args: path] { nvim ...$args }

# __zoxide_z wrapper
def cd --env --wrapped [...args: directory] { __zoxide_z ...$args }

# macos copy wrapper
def copy [
  --format (-f): string@[csv html json md msgpack msgpackz nuon text toml tsv xml yaml yml] # Copy as format
]: any -> nothing {
  if $format != null {
    try {
      let data = $in
      match $format {
        "csv" => ($data | to csv | pbcopy)
        "html" => ($data | to html | pbcopy)
        "json" => ($data | to json | pbcopy)
        "md" => ($data | to md | pbcopy)
        "msgpack" => ($data | to msgpack | pbcopy)
        "msgpackz" => ($data | to msgpackz | pbcopy)
        "nuon" => ($data | to nuon | pbcopy)
        "text" => ($data | to text | pbcopy)
        "toml" => ($data | to toml | pbcopy)
        "tsv" => ($data | to tsv | pbcopy)
        "xml" => ($data | to xml | pbcopy)
        "yaml" => ($data | to yaml | pbcopy)
        "yml" => ($data | to yml | pbcopy)
        $other => $"Format '($format)' not recognized"
      }
    } catch {$"Could not convert to ($format)"}
  } else {$in | pbcopy}
}

# macos paste wrapper
def paste [
  --format (-f): string@[csv json msgpack msgpackz nuon ods ssv toml tsv url xlsx xml yaml yml] # Format of clipboard
]: nothing -> any {
  if $format != null {
    try {
      match $format {
        "csv" => (pbpaste | from csv)
        "json" => (pbpaste | from json)
        "msgpack" => (pbpaste | from msgpack)
        "msgpackz" => (pbpaste | from msgpackz)
        "nuon" => (pbpaste | from nuon)
        "ods" => (pbpaste | from ods)
        "ssv" => (pbpaste | from ssv)
        "toml" => (pbpaste | from toml)
        "tsv" => (pbpaste | from tsv)
        "url" => (pbpaste | from url)
        "xlsx" => (pbpaste | from xlsx)
        "xml" => (pbpaste | from xml)
        "yaml" => (pbpaste | from yaml)
        "yml" => (pbpaste | from yml)
        $other => $"Format '($other)' not recognized"
      }
    } catch { $"Could not convert to ($format)" }
  } else {pbpaste}
}
