# Module for managing piping in and out of the system clipboard

# USAGE: import with `use /path/to/clipboard.nu *`

use std/clip

# completer and type lister for copy
def to-completer [] {
  [
    {value: "csv", description: "Comma-separated values"}
    {value: "html", description: "HTML table"}
    {value: "json", description: "JSON"}
    {value: "md", description: "Markdown table"}
    {value: "msgpack", description: "MessagePack binary (base64 encoded)"}
    {value: "msgpackz", description: "Compressed MessagePack (base64 encoded)"}
    {value: "nuon", description: "Nushell Object Notation"}
    {value: "text", description: "Plain text"}
    {value: "toml", description: "TOML"}
    {value: "tsv", description: "Tab-separated values"}
    {value: "yaml", description: "YAML"}
    {value: "yml", description: "YAML"}
  ]
}

# completer and type lister for paste
def from-completer [] {
  [
    {value: "csv", description: "Comma-separated values"}
    {value: "json", description: "JSON"}
    {value: "msgpack", description: "MessagePack binary (base64 decoded first)"}
    {value: "msgpackz", description: "Compressed MessagePack (base64 decoded first)"}
    {value: "nuon", description: "Nushell Object Notation"}
    {value: "ssv", description: "Space-separated values (>= 2 space delimiters)"}
    {value: "toml", description: "TOML"}
    {value: "tsv", description: "Tab-separated values"}
    {value: "url", description: "URL-encoded form data"}
    {value: "xml", description: "XML"}
    {value: "yaml", description: "YAML"}
    {value: "yml", description: "YAML"}
  ]
}

# Pipe data into the system clipboard
#
# Copies piped input to the clipboard, optionally converting to a specified format.
# Clipboard Support: macOS (pbcopy), Windows (clip.exe), and Linux (wl-copy, xclip, xsel).
#
# Examples:
#   `"hello" | copy`                      # Copy plain text
#   `ls | copy -f json`                   # Copy directory listing as JSON
#   `{name: "bob"} | copy -f toml`        # Copy record as TOML
#   `[[a b]; [1 2]] | copy -f csv`        # Copy table as CSV
#   `open data.json | copy -f nuon`       # Convert JSON file to NUON and copy
export def copy [
  --format (-f): string@to-completer # Convert to this format before copying
]: any -> nothing {
  let data = $in
  let converter = if $format != null {
    match $format {
      csv => {|| to csv}
      html => {|| to html}
      json => {|| to json}
      md => {|| to md}
      msgpack => {|| to msgpack | encode base64 | str trim} # encode and trim newlines/whitespace
      msgpackz => {|| to msgpackz | encode base64 | str trim}
      nuon => {|| to nuon}
      text => {|| to text}
      toml => {|| # toml expects a record, this wraps tables for compatability
        let d = $in
        if ($d | describe | str starts-with "record") {
          $d
        } else {
          {data: $d}
        } | to toml
      }
      tsv => {|| to tsv}
      yaml|yml => {|| to yaml}
      _ => (error make {
          msg: $"Format `($format)` not supported."
          help: $"Use one of: (to-completer | get value)."
          label: {
            text: "unknown format"
            span: (metadata $format | get span)
          }
        }
      )
    }
  } else {
    {|| $in}
  }
  $data | do $converter | clip copy
}

# Pipe data out of the system clipboard
#
# Retrieves clipboard contents, optionally parsing from a specified format.
# Clipboard Support: macOS (pbcopy), Windows (clip.exe), and Linux (wl-copy, xclip, xsel).
#
# Examples:
#   `paste`                                    # Paste as plain text
#   `paste -f json`                            # Parse clipboard as JSON
#   `paste -f csv | where size > 100``         # Parse CSV and filter
#   `paste -f nuon | to json | save out.json`  # Convert NUON to JSON file
export def paste [
  --format (-f): string@from-completer # Convert from this format before pasting
]: nothing -> any {
  let converter = if $format != null {
    match $format {
      csv => {|| from csv}
      json => {|| from json}
      msgpack => {|| str trim | decode base64 | from msgpack} # trim whitespace/newlines then decode
      msgpackz => {|| str trim | decode base64 | from msgpackz}
      nuon => {|| from nuon}
      ssv => {|| from ssv}
      toml => {|| from toml}
      tsv => {|| from tsv}
      url => {|| from url}
      xml => {|| from xml}
      yaml|yml => {|| from yaml}
      _ => (error make {
            msg: $"Format `($format)` not supported."
            help: $"Use one of: (from-completer | get value)."
            label: {
              text: "unknown format"
              span: (metadata $format | get span)
            }
          }
        )
      }
    } else {
      {|| $in}
    }
  clip paste | do $converter
}
