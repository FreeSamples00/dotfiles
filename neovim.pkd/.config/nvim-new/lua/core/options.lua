local opts = {
  shiftwidth = 4,
  tabstop = 4,
  expandtab = true,
  wrap = false,
  termguicolors = true,
  number = true,
  relativenumber = true,
  clipboard = "unnamedplus", -- use system clipboard
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

-- enable undofile
vim.opt.undofile = true

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 200 })
  end,
})
