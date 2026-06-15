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

---@type string[] Snacks window filetypes that trigger :qa when all real windows close
M.autoclose_filetypes = {
  "snacks_picker_input",
  "snacks_picker_list",
  "snacks_layout_box",
}

---@type string[] Lua patterns matching directory basenames that act as cwd stop points
---When inside a git repo, walk from shell cwd upward toward git root;
---first matching directory becomes the cwd. No match → git root (original behavior).
M.cwd_stop_patterns = {
  "%.pkd$", -- dotfiles package dirs: neovim.pkd, ghostty.pkd, etc.
}

---@type table<string, string> Diagnostic icons (used in lualine)
M.lsp_icons = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

return M
