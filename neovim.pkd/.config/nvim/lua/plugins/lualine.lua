return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    -- get formatted time
    local function get_time()
      return os.date("%-I:%M %p")
    end

    -- get dirname or root folder of git (cached to avoid flickering cursor)
    local function get_repo_or_dir_name()
      if not vim.g.cached_repo_name or vim.fn.getcwd() ~= vim.g.cached_cwd then
        local git_toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):match("(.*)\n")
        if git_toplevel and git_toplevel ~= "" then
          vim.g.cached_repo_name = "󰊢 " .. vim.fn.fnamemodify(git_toplevel, ":t")
        else
          vim.g.cached_repo_name = " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end
        vim.g.cached_cwd = vim.fn.getcwd()
      end
      return vim.g.cached_repo_name
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
        },
        always_last_session = true,
        lsp_progress = { enabled = true },
      },

      -- Sections
      sections = {
        -- Left side | left -> right
        lualine_a = { "mode" },
        lualine_b = { get_repo_or_dir_name },
        lualine_c = {
          {
            "branch",
            icon = "",
          },
          "diff",
        },

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
