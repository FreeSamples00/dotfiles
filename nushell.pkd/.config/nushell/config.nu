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
    abbreviated_row_count: 25
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

# ----- Menus -----

$env.config.menus ++= [{
    name: completion_menu
    only_buffer_difference: false     # Search is done on the text written after activating the menu
    marker: "| "                      # Indicator that appears with the menu is active
    type: {
        layout: columnar              # Type of menu
        columns: 1                    # Number of columns where the options are displayed
        # col_width: 20                 # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2                # Padding between columns
        tab_traversal: "vertical"   # Direction in which pressing <Tab> will cycle through options, "horizontal" or "vertical"
    }
    style: {
        text: green                   # Text style
        selected_text: green_reverse  # Text style for selected option
        description_text: yellow      # Text style for description
    }
}]
