# use `config nu --doc | nu-highlight` to retrieve documentation
# https://www.nushell.sh/book/configuration.html

# ----- Theme -----
source theme.nu

$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""

$env.config = {
  # ----- Misc Settings -----
  show_banner: false
  rm: {
    always_trash: false # toggle rm sending to trash dir
  }
  recursion_limit: 100 # max recursion depth before killing process

  # ----- Commandline Editor Settings -----
  buffer_editor: [ "nvim" ] # add arguments as other elements
  edit_mode: "vi" # emacs or vi

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
  }

  # ----- Terminal Integrations -----
  # Controls escape codes for terminal integrations
  use_kitty_protocol: true

  shell_integration: {
    osc2: true # dir/command in title
    osc8: true # clickable filepaths
    osc133: true # report prompt location and command status
    osc633: true # VSC version of 133
    reset_application_mode: true # syncs cursors, commonly over ssh
  }

  # ----- Error Settings -----
  display_errors: {
    exit_code: false
    termination_signal: false
  }

  # ----- Table Settings -----
  footer_mode: 20 # display column names in footer if table larger than window
  table: {
    mode: "default" # theme
    index_mode: auto # only show index numbers when part of data
    trim: {
      methodology: "truncating" # truncate text in cell
      truncating_suffix: "…" # use this to indicate truncation
    }
    header_on_separator: true # place column name in table border
    abbreviated_row_count: 15
    missing_value_symbol: "——"
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

  # ----- Menus -----
  menus: [
    {
      name: completion_menu
      marker: ""
      only_buffer_difference: false
      style: {
        text: $theme.text
        selected_text: { bg: $theme.surface1 fg: $theme.text }
        description_text: $theme.subtext0
        match_text: $theme.red
        selected_match_text: { bg: $theme.surface1 fg: $theme.red }
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
    }
    {
      name: history_menu
      marker: ""
      only_buffer_difference: false
      style: {
        text: $theme.text
        selected_text: { bg: $theme.surface1 fg: $theme.text }
        description_text: $theme.subtext0
      }
      type: {
        layout: list
        page_size: 10
      }
    }
  ]

  # ----- Hooks -----
  hooks: {
    display_output: "table" # call table for output rendering, this respects table settings defined above
  }
}

# ----- Starship Prompt -----
use ~/.cache/starship/init.nu

# ----- Zoxide Init -----
source ~/.cache/zoxide.nu
