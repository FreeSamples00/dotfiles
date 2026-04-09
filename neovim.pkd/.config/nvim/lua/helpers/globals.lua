local M = {}

M.text_filetypes = {
  "text",
  "markdown",
  "tex",
  "quarto",
  "mail",
}

M.ignored_filetypes = {
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
  "undotree",
  "snacks_picker_list",
  "snacks_picker_input",
}

M.lsp_icons = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

M.lsp_ensure_installed = {
  "lua_ls",
  "pylsp",
  "marksman",
  "texlab",
}

M.treesitter_ensure_installed = {
  "c",
  "cpp",
  "go",
  "lua",
  "python",
  "rust",
  "vimdoc",
  "vim",
  "nu",
  "markdown",
  "markdown_inline",
  "json",
  "yaml",
  "toml",
}

return M
