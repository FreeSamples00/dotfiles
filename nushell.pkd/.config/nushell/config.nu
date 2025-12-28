# use `config nu --doc | nu-highlight` to retrieve documentation
# https://www.nushell.sh/book/configuration.html

$env.config = {
  # ----- Misc Settings -----
  show_banner: false # disable default banner
  rm: {
    always_trash: false # toggle rm sending to trash dir
  }
  recursion_limit: 100 # max recursion depth before killing process

  # ----- Commandline Editor Settings -----
  buffer_editor: [ "nvim" ] # add arguments as other elements
  edit_mode: "emacs" # emacs or vi

  # shape options:
  # - inherit
  # - {blink_}block
  # - {blink_}underline
  # - {blink_}line
  cursor_shape: {
    emacs: "inherit"
    vi_insert: "line"
    vi_normal: "block"
  }

  # ----- History Settings -----
  history: {
    max_size: 5_000_000
    file_format: "sqlite"
    isolation: true # prevent active sessions from seeing eachothers history
  }

  # ----- Completions Settings -----
  completions: {
    algorithm: "fuzzy" # "prefix", "substring" or "fuzzy"
    sort: "smart"
    case_sensitive: false
    quick: true
    partial: true
    use_ls_colors: true

    external: {
      enable: true

      max_results: 50

      # uses carapace for external completions
      completer: {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }
    }
  }

  # ----- Terminal Integrations -----
  # Controls escape codes for terminal integrations
  use_kitty_protocol: true # use kitty protocol

  # ----- Error Settings -----
  display_errors: {
    exit_code: false
    termination_signal: false
  }

  # ----- Table Settings -----
  footer_mode: "auto" # display column names in footer if table larger than window
  table: {
    mode: "default" # theme
    index_mode: auto # only show index numbers when part of data
    trim: {
      methodology: "truncating" # truncate text in cell
      truncating_suffix: "…" # use this to indicate truncation
    }
    header_on_separator: true # place column name in table border
  }

  # ----- Datetime Settings -----
  datetime_format: {
    table: "%R %D" # HH:MM MM/DD/YY
    normal: "%R %D"
  }

  # ----- Filesize Units -----
  filesize: {
    unit: 'binary'
    show_unit: true # always show unit?
    precision: 1
  }

  # ----- Misc Display Settings -----
  float_precision: 2 # precision for all displayed floats
  ls: { use_ls_colors: true }

  # ----- Hooks -----
  hooks: {
    display_output: "table" # call table for output rendering, this respects table settings defined above
  }

}
