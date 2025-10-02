
# Gets the root of the current Git repository.
function git_root() {
  local root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ "$root_dir" == "" ]]; then
    echo "$(pwd)"
  else
    echo "$root_dir"
  fi
}

# Edits the project's .gitignore file.
function ignore() {
  $EDITOR "$(git_root)/.gitignore"
}

# Edits the project's TODO.md file.
function todo() {
  $EDITOR "$(git_root)/TODO.md"
}

# edit a project's README.md file
function readme() {
  $EDITOR "$(git_root)/README.md"
}

