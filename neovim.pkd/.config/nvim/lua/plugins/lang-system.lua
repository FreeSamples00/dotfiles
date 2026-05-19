--- Language System Plugin Configuration
---
--- Defines plugin specs for:
--- - lang-system (local plugin with keybinds and commands)
--- - Mason (package manager for LSP/formatters/linters)
--- - nvim-treesitter (syntax highlighting + textobjects)
--- - nvim-lspconfig (LSP client with mason-lspconfig bridge + neodev + illuminate + cmp-nvim-lsp)
--- - none-ls (formatters and linters, loaded on LspAttach)
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
      ensure_installed = { "nvim_core", "configs_group", "bash", "nu" }, -- auto-install on startup
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
    lazy = false,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
      "lang-system",
      "nvim-treesitter/nvim-treesitter-textobjects", -- textobject motions
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
      "folke/neodev.nvim", -- Lua dev enhancements for neovim config
      "RRethy/vim-illuminate", -- highlight word under cursor references
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    },
    config = function()
      lang_system.setup_lspconfig()
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "LspAttach", -- lazy load with LSP
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim", -- extra formatter/linter sources
    },
    config = function()
      lang_system.setup_null_ls()
    end,
  },
}
