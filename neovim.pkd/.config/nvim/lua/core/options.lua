local opts = {
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  expandtab = true,
  wrap = false,
  termguicolors = true,
  number = true,
  relativenumber = true,
  clipboard = "unnamedplus", -- use system clipboard
  undofile = true,
  confirm = true,
  autowrite = true,
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

vim.opt.fillchars = { eob = " " }
