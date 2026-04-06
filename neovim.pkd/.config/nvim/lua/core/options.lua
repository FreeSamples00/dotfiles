-- set default options

-- options to apply
local opts = {
  shiftwidth = 2,            -- set sane tabbing
  tabstop = 2,               -- |
  softtabstop = 2,           -- |
  expandtab = true,          -- replace tab chars with spaces
  wrap = false,              -- disable linewrapping by default
  termguicolors = true,      -- enable 24bit color if supported
  number = true,             -- enable line numbers
  relativenumber = true,     -- enable relative line numbers
  clipboard = "unnamedplus", -- use system clipboard
  undofile = true,           -- enable undofile to track changes across sessions
  confirm = true,            -- enable confirm menu on things like saving before quiting
  scrolloff = 5,             -- keep n lines on screen above and below cursor at all times
  fillchars = { eob = " " }  -- remove `~` from end of buffer
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.opt[opt] = val
end
