# Commands for quick and consistent tar archives

# Check magic bytes for gzip
def is-gzip [file: path] {
  open $file --raw | bytes starts-with 0x[1f 8b]
}

# Use gzip to validate
def validate-gzip [file: path] {
  return ((gzip -t $file | complete).exit_code == 0)
}

# Create tar archive
export def main [
  target: path        # target to archive
  destination: string # basename of resulting tgz file
  --timestamp (-t)    # append a timestamp to the filename
] {

  # apply timestamp
  let destination = $destination
  | if $timestamp { $"($in)-(date now | format date '%Y%m%d').tgz" } else { $"($in).tgz" }
  | path expand

  # prevent overwriting existing files
  if ($destination | path exists) {
    error make {msg: $"Destination '($destination)' already exists."}
  }

  # verify target exists
  if not ($target | path exists) {
    error make {msg: $"Target '($target)' does not exist."}
  }

  # Create archive
  let result = (tar --format=pax -czpf $destination $target | complete)
  if $result.exit_code != 0 {
    if ($destination | path exists) { rm $destination }
    error make {msg: $"Failed to archive '($target)': ($result.stderr)"}
  }

  print $"Archived: ($target) -> ($destination)"
}

# Extract tar archive
export def extract [
  target: path          # archive to extract
  destination: string   # dir to extract into
  --force (-f)          # extract into existing or populated directories
  --keep-root (-k)     # preserve the archive's top-level directory in the destination
] {

  # create full paths for tar
  let target = $target | path expand
  let destination = $destination | path expand
  let cwd = (pwd | path expand)

  # verify target exists
  if not ($target | path exists) {
    error make {msg: $"Target '($target)' does not exist."}
  }

  # check target is properly archived
  if not (is-gzip $target) {
    error make {msg: $"Target '($target)' is not a viable tar archive"}
  }

  if not (validate-gzip $target) {
    error make {msg: $"Target '($target)' failed gzip validation."}
  }

  # if destination exists, verify it's usable
  if ($destination | path exists) {
    if ($destination | path type) != "dir" {
      error make {msg: $"Destination '($destination)' exists and is not a directory."}
    }
    if not $force and (ls -a $destination | length) > 0 {
      error make {
        msg: $"Destination '($destination)' already contains files"
        help: "Use --force to override."
      }
    }
  }

  # create directory in case it does not exist
  mkdir $destination

  # inspect archive to detect a single wrapping directory
  let entries = (tar -tf $target | lines)
  let top_levels = ($entries | each { |e| $e | path split | first } | uniq)
  let single_wrap = (
    ($top_levels | length) == 1
    and ($entries | any { |e| ($e | path split | length) > 1 })
  )

  # strip the wrapping directory unless --keep-root is given or extracting to cwd
  let strip_args = if $single_wrap and not $keep_root and ($destination != $cwd) {
    [--strip-components 1]
  } else {
    []
  }

  # Extract archive
  let result = (tar -xzpf $target -C $destination ...$strip_args | complete)
  if $result.exit_code != 0 {
    error make {msg: $"Failed to extract '($target)': ($result.stderr)"}
  }

  print $"Extracted: ($target) -> ($destination)"
}
