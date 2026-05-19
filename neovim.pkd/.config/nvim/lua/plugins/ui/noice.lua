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
      lsp_doc_border = true, -- bordered LSP hover/signature
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
