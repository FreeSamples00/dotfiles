--- Lualine: custom statusline with mode, filename, git diff, diagnostics, macro/SSH indicators, clock
--- Uses helpers.globals for ignored_filetypes and lsp_icons

local globals = require("helpers.globals")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local function get_time()
      return os.date("%-I:%M %p")
    end

    -- shows recording register when macro is active
    local function macro_indicator()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return " " .. reg
    end

    -- shows icon when in an SSH session
    local function ssh_indicator()
      if vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY then
        return "󰒋"
      end
      return ""
    end

    return {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = {
          left = "",
          right = "",
        },
        section_separators = {
          left = "",
          right = "",
        },
        disabled_filetypes = globals.ignored_filetypes, -- hide in special windows
        always_last_session = true,
        lsp_progress = { enabled = true },
      },

      sections = {
        -- left: mode → filename → diff
        lualine_a = { "mode" },
        lualine_b = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 0, -- relative path
            shorting_target = 20,
            symbols = {
              modified = "󰏫",
              readonly = "󰍁",
              unnamed = "[Unnamed]",
              newfile = "",
            },
          },
        },
        lualine_c = { "diff" },

        -- right: macro → SSH → diagnostics → progress → clock
        lualine_x = {
          {
            macro_indicator,
            color = { fg = "#cb2000", bg = nil, gui = "bold" },
          },
          {
            ssh_indicator,
            color = { fg = "#FFD709", bg = nil, gui = "bold" },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = globals.lsp_icons, -- shared diagnostic icons
            colored = true,
            always_visible = false,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { get_time },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      tabline = {},
      extensions = {},
    }
  end,
}
