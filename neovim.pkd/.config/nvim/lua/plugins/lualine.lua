return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    -- get formatted time
    local function get_time()
      return os.date("%-I:%M %p")
    end

    -- indicator for macro being recorded
    local function macro_indicator()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return " " .. reg
    end

    -- indicator for ssh connection
    local function ssh_indicator()
      if vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY then
        return "󰒋"
      end
      return ""
    end

    -- actual line settings
    return {

      -- general settings
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
        disabled_filetypes = {
          "NvimTree",
          "packer",
          "atone",
          "Outline",
          "lazy",
          "mason",
          "help",
          "Trouble",
          "toggleterm",
          "oil",
          "spectre_panel",
        },
        always_last_session = true,
        lsp_progress = { enabled = true },
      },

      -- Sections
      sections = {
        -- Left side | left -> right
        lualine_a = { "mode" },
        lualine_b = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 0,
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

        -- Right Side | left -> right
        lualine_x = {
          {
            macro_indicator,
            color = {
              fg = "#cb2000",
              bg = nil,
              gui = "bold",
            },
          },
          {
            ssh_indicator,
            color = {
              fg = "#FFD709",
              bg = nil,
              gui = "bold",
            },
          },
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
            colored = true,
            always_visible = false,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { get_time },
      },

      -- disabled sections
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      -- disable top things
      tabline = {},
      extensions = {},
    }
  end,
}
