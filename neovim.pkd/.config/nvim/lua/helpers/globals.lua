--- Shared constants consumed across core and plugin modules

local M = {}

---@type string[] Filetypes that get spell+wrap settings (used in core/autocmds)
M.text_filetypes = {
  "text",
  "markdown",
  "tex",
  "quarto",
  "mail",
}

---@type string[] Filetypes where lualine and features are hidden
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

---@type table<string, string> Diagnostic icons (used in lualine)
M.lsp_icons = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

return M
