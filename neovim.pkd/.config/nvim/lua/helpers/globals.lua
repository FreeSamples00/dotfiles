local M = {}

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
  "snacks_picker_input"
}

M.lsp_icons = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

return M
