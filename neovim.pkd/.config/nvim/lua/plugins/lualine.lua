return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local function get_time()
      return os.date("%-I:%M %p")
    end

    local function get_repo_or_dir_name()
      if not vim.g.cached_repo_name or vim.fn.getcwd() ~= vim.g.cached_cwd then
        local git_toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):match("(.*)\n")

        if git_toplevel and git_toplevel ~= "" then
          vim.g.cached_repo_name = "󰊢 " .. vim.fn.fnamemodify(git_toplevel, ":t")
        else
          vim.g.cached_repo_name = " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end
        vim.g.cached_cwd = vim.fn.getcwd()
      end

      return vim.g.cached_repo_name
    end

    local function tmux_indicator()
      if os.getenv("TMUX") then
        return ""
      else
        return ""
      end
    end

    local function macro_indicator()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return " " .. reg
    end

    return {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          "NvimTree",
          "packer",
        },
        always_last_session = true,
        lsp_progress = {
          enabled = true,
        },
      },

      -- Define the base sections
      sections = {
        lualine_a = { "mode" },
        lualine_b = { get_repo_or_dir_name },
        lualine_c = {
          { "branch", icon = "" },
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = true,
            always_visible = false,
          },
          "lsp_progress",
        },
        lualine_x = {
          {
            tmux_indicator,
            color = {
              fg = "#7AA87F",
              bg = nil,
              gui = "bold",
            },
          },
          {
            macro_indicator,
            color = {
              fg = "#cb2000",
              bg = nil,
              gui = "bold",
            },
          },
          -- "encoding",
          "diff",
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

      -- Since you're using Tabby for the tabline, ensure lualine's tabline is empty
      tabline = {},
      extensions = {},
    }
  end,
}
