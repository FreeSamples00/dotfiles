local M = {}

-- List of other tools (for mason-tool-installer.nvim)
M.other_tools = {
  "stylua", -- Lua formatter
  "black", -- Python formatter
  "isort", -- Python import sorter
  "prettier", -- General formatter
  "shellcheck", -- Shell script linter
  "shfmt", -- Shell script formatter
  "debugpy", -- Python debugger
  "asmfmt",
  "beautysh",
  "clang-format",
  "mdformat",
  "prettier",
  "ruff",
  "shfmt",
  "stylua",
  "taplo",
  "asm-lsp",
  "bash-language-server",
  "clangd",
  "java-language-server",
  "json-lsp",
  "lua-language-server",
  "marksman",
  "pyright",
  "ruff",
  "rust-analyzer",
  "taplo",
  "yaml-language-server",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- Configure Mason
    require("mason").setup()

    -- -- Configure mason-lspconfig with your defined LSP servers
    -- require("mason-lspconfig").setup({
    --   ensure_installed = M.lsp_servers, -- Use the list from your module
    --   -- Other mason-lspconfig options
    -- })

    -- Configure mason-tool-installer with your defined other tools
    require("mason-tool-installer").setup({
      ensure_installed = M.other_tools, -- Use the list from your module
      -- Other mason-tool-installer options
    })
  end,
}
