--- Language System Plugin Configuration
---
--- Defines plugin specs for:
--- - lang-system (local plugin with keybinds and commands)
--- - Mason (package manager)
--- - nvim-treesitter (syntax highlighting)
--- - nvim-lspconfig (LSP client)
--- - none-ls (formatters, linters)
---
--- Default definitions are in lua/lang-system/languages.lua and mappings.lua.
--- Override them via the opts table below.

local lang_system = require("lang-system")

return {
  {
    "lang-system",
    dir = vim.fn.stdpath("config") .. "/lua/lang-system",
    name = "lang-system",
    main = "lang-system",
    lazy = false,
    priority = 100,
    keys = {
      { "<leader>dm", "<cmd>Mason<cr>", desc = "Mason UI" },
      { "<leader>dls", "<cmd>LanguageStatus<cr>", desc = "Status" },
      { "<leader>dll", "<cmd>LanguageList<cr>", desc = "List" },
      { "<leader>dli", "<cmd>LanguageInstallCurrent<cr>", desc = "Install Current" },
      { "<leader>dlu", "<cmd>LanguageUninstallCurrent<cr>", desc = "Uninstall Current" },
    },
    opts = {
      ensure_installed = { "nvim_core", "configs_group", "bash", "nu" },
      languages = {},
    },
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = { "lang-system" },
    config = function()
      lang_system.setup_mason()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
      "lang-system",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      lang_system.setup_treesitter()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "lang-system",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "RRethy/vim-illuminate",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      lang_system.setup_lspconfig()
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      lang_system.setup_null_ls()
    end,
  },
}
