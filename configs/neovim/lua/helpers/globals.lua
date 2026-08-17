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
  "snacks_picker_preview",
  "snacks_layout_box",
}

---Cwd anchor list, walked up from shell cwd on VimEnter.
---List order = priority: first entry with a match wins (nearest on ties).
---`git` entry sets a ceiling at git_root; entries below it are inert in a repo.
---`git_only` entries are skipped when not in a repo.
---No match -> keep cwd. Bad pattern -> vim.notify once.
---@class cwd_anchor
---@field type "dir" | "child" | "git"  -- "dir"=own basename, "child"=any child entry name, "git"=repo root
---@field value string                 -- Lua pattern; ignored for "git"
---@field git_only? boolean            -- default false; ignored for "git"
M.cwd_anchors = {
  { type = "child", value = "^%.obsidian$" }, -- Obsidian vault root
  { type = "git" }, -- git repo root (fallback inside repo)
}

---@type table<string, string> Diagnostic icons (used in lualine)
M.lsp_icons = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

return M
