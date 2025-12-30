# use `config nu --doc | nu-highlight` to retrieve documentation
# https://www.nushell.sh/book/configuration.html

$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""

$env.config = {
  # ----- Misc Settings -----
  show_banner: false # disable default banner
  rm: {
    always_trash: false # toggle rm sending to trash dir
  }
  recursion_limit: 100 # max recursion depth before killing process

  # ----- Commandline Editor Settings -----
  buffer_editor: [ "nvim" ] # add arguments as other elements
  edit_mode: "vi" # emacs or vi

  # shape options:
  # - inherit
  # - {blink_}block
  # - {blink_}underline
  # - {blink_}line
  cursor_shape: {
    emacs: "block"
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
      enable: false

      max_results: 10

      # uses carapace for external completions
      # completer: {|spans|
      #   carapace $spans.0 nushell ...$spans | from json
      # }
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
    abbreviated_row_count: 15
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

# ----- Starship Prompt -----
use ~/.cache/starship/init.nu

# ----- Zoxide Init -----
source ~/.cache/zoxide.nu

# ----- Theme -----
source theme.nu

# ----- Menus -----

$env.config.menus ++= [{
    name: completion_menu
    marker: ""
    only_buffer_difference: false
    style: {
        text: green
        selected_text: { attr: "r" }
        description_text: yellow
        match_text: { fg: "#FF453A" }
        selected_match_text: { fg: "#FF453A", attr: "r" }
    }
    type: {
        layout: ide
        min_completion_width: 0
        max_completion_width: 50
        padding: 0
        border: true
        cursor_offset: 0
        description_mode: "prefer_right"
        min_description_width: 0
        max_description_width: 50
        max_description_height: 10
        description_offset: 1
        correct_cursor_pos: true
    }
}]
