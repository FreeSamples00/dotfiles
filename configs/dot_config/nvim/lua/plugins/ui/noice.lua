--- Noice: enhanced UI for messages, cmdline, and popupmenu
--- Command palette layout (cmdline + popupmenu together), long messages to split

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- rich docs in completion
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true, -- cmdline + popupmenu positioned together
      long_message_to_split = true, -- overflow to split window
      inc_rename = false,
      lsp_doc_border = "rounded", -- bordered LSP hover/signature
    },
    views = {
      hover = {
        -- Noice defaults size the hover popup to the longest unbreakable
        -- line (up to 120 cols), making prose wrap across a full-width
        -- window. Cap the width and add breakindent + showbreak so wrapped
        -- lines read like the rest of the config (help, notifications).
        size = { max_width = 80 },
        win_options = require("helpers.utils").wrap_options,
      },
    },
    messages = {
      enabled = true,
      view = "notify",
    },
    notify = {
      enabled = true,
      view = "notify",
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
}
