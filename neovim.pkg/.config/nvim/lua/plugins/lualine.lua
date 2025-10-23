return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
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
        spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧" },
      },
    })

    local function get_repo_or_dir_name()
      -- Try to get the Git top-level directory
      local git_toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):match("(.*)\n")

      if git_toplevel and git_toplevel ~= "" then
        return "󰊢 " .. vim.fn.fnamemodify(git_toplevel, ":t")
      else
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
    end

    -- Define the base sections
    opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
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
      lualine_x = { "encoding", "diff" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    })

    opts.inactive_sections = vim.tbl_deep_extend("force", opts.inactive_sections or {}, {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    })

    -- Since you're using Tabby for the tabline, ensure lualine's tabline is empty
    opts.tabline = {}
    opts.extensions = opts.extensions or {}

    -- Custom time for lualine_z
    opts.sections.lualine_z = {
      function()
        return os.date("%-I:%M %p")
      end,
    }

    -- TMUX indicator for lualine_x
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      function()
        if os.getenv("TMUX") then
          return ""
        else
          return ""
        end
      end,
      color = {
        fg = "#7AA87F",
        bg = nil,
        gui = "bold",
      },
    })

    -- MACRO indicator for lualine_x
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      function()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end -- not recording
        return " " .. reg
      end,
      color = {
        fg = "#cb2000",
        bg = nil,
        gui = "bold",
      },
    })

    return opts
  end,
}
