--- Noice: enhanced UI for messages, cmdline, and popupmenu
--- Command palette layout (cmdline + popupmenu together), long messages to split

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    require("noice").setup(opts)

    -- Scroll Noice's LSP popups (hover/signature) without leaving the buffer.
    -- Falls back to the native key when no popup is open (feedkeys with the
    -- "n" flag does not remap, so C-j movement / C-k digraphs are preserved).
    local map = require("helpers.keys").map
    local function popup_scroll(delta, fallback)
      if not require("noice.lsp").scroll(delta) then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(fallback, true, true, true), "n", false)
      end
    end
    map("n", "<C-j>", function()
      popup_scroll(4, "<C-j>")
    end, "Scroll LSP popup down")
    map("n", "<C-k>", function()
      popup_scroll(-4, "<C-k>")
    end, "Scroll LSP popup up")
    map("n", "<C-Down>", function()
      popup_scroll(4, "<C-Down>")
    end, "Scroll LSP popup down")
    map("n", "<C-Up>", function()
      popup_scroll(-4, "<C-Up>")
    end, "Scroll LSP popup up")
  end,
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
