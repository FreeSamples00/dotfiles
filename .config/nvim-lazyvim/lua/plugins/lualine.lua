return {
  "nvim-lualine/lualine.nvim",
  -- Add nvim-web-devicons as a dependency for file icons
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    -- Start with the base options for slanted look and icons
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      icons_enabled = true,
      theme = "auto", -- 'auto' will try to match your colorscheme, or pick one like 'onedark', 'catppuccin', etc.
      component_separators = { left = "", right = "" }, -- Your chosen separators for components
      section_separators = { left = "", right = "" }, -- Your chosen slanted separators for sections
      disabled_filetypes = {
        "NvimTree",
        "packer",
      },
      always_last_session = true,
      lsp_progress = {
        enabled = true,
        spinner_symbols = { "", "", "" },
      },
    })

    local function get_repo_or_dir_name()
      -- Try to get the Git top-level directory
      -- 'git rev-parse --show-toplevel' outputs the path, or errors if not in a repo.
      -- We capture stderr to /dev/null and remove newline.
      local git_toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):match("(.*)\n")

      if git_toplevel and git_toplevel ~= "" then
        -- If in a Git repo, return the basename of the top-level directory
        return " " .. vim.fn.fnamemodify(git_toplevel, ":t")
      else
        -- If not in a Git repo, return the basename of the current working directory
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
    end

    -- Define the base sections
    opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
      lualine_a = { "mode" },
      lualine_b = { get_repo_or_dir_name },
      lualine_c = {
        { "branch" },
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
    -- Ensure lualine_x exists as a table before inserting
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

    return opts
  end,
}
