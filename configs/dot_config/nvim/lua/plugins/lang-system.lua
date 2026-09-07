--- Language System Plugin Configuration
---
--- Defines plugin specs for:
--- - lang-system (local plugin with keybinds and commands)
--- - Mason (package manager for LSP/formatters/linters)
--- - nvim-treesitter (syntax highlighting + textobjects)
--- - nvim-lspconfig (LSP client with mason-lspconfig bridge)
--- - conform.nvim (formatters) + nvim-lint (linters)
---
--- Default definitions: lua/lang-system/languages.lua and mappings.lua
--- Override them via the opts table below.

local lang_system = require("lang-system")

return {
  {
    "lang-system",
    dir = vim.fn.stdpath("config") .. "/lua/lang-system", -- local plugin
    name = "lang-system",
    main = "lang-system",
    lazy = false,
    priority = 100, -- load before Mason/lspconfig
    keys = {
      { "<leader>dm", "<cmd>Mason<cr>", desc = "Mason UI" },
      { "<leader>dls", "<cmd>LanguageStatus<cr>", desc = "Status" },
      { "<leader>dll", "<cmd>LanguageList<cr>", desc = "List" },
      { "<leader>dli", "<cmd>LanguageInstallCurrent<cr>", desc = "Install Current" },
      { "<leader>dlu", "<cmd>LanguageUninstallCurrent<cr>", desc = "Uninstall Current" },
    },
    opts = {
      ensure_installed = { "nvim_core", "configs_group", "bash" }, -- auto-install on startup
      languages = {},
    },
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = { "lang-system" }, -- ensure lang-system loads first
    config = function()
      lang_system.setup_mason()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
      "lang-system",
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" }, -- textobject motions
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
      "williamboman/mason-lspconfig.nvim", -- Mason ↔ lspconfig bridge
    },
    config = function()
      lang_system.setup_lspconfig()
    end,
  },

  {
    "stevearc/conform.nvim",
    lazy = false, -- guarantees :Format and format_on_save for scripted `nvim +w` too
    dependencies = { "lang-system" },
    config = function()
      lang_system.setup_conform()
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "lang-system" },
    config = function()
      lang_system.setup_nvimlint()
    end,
  },
}
