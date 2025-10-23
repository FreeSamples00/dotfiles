-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ==================== 'd' without yanking ====================

-- Normal mode
vim.keymap.set("n", "d", '"_d', {
  remap = false, -- Equivalent to 'noremap'
  silent = true, -- Prevents messages like "Invalid key" if you type 'd' too fast alone
  desc = "Delete without yanking",
})

-- Visual mode
vim.keymap.set("v", "d", '"_d', {
  remap = false, -- Equivalent to 'noremap'
  silent = true,
  desc = "Delete visual selection without yanking",
})

-- ==================== 'c' without yanking ====================

-- Normal mode
vim.keymap.set("n", "c", '"_c', {
  remap = false, -- Equivalent to 'noremap'
  silent = true, -- Prevents messages like "Invalid key" if you type 'd' too fast alone
  desc = "Delete without yanking",
})

-- Visual mode
vim.keymap.set("v", "c", '"_c', {
  remap = false, -- Equivalent to 'noremap'
  silent = true,
  desc = "Delete visual selection without yanking",
})

-- ==================== 'p' without yanking ====================

-- Visual mode
vim.keymap.set("x", "p", [["_dP]], {
  desc = "Paste without copying overwritten text",
})
vim.keymap.set("x", "P", [["_dP]], {
  desc = "Paste without copying overwritten text",
})

-- ==================== Terminal Emulator ====================

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, buffer = 0 })
  end,
})

-- ==================== Neovide ====================

if vim.g.neovide then
  -- Paste (normal / visual)
  vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
  vim.keymap.set("v", "<D-v>", '"+p', { noremap = true, silent = true })

  -- Paste in insert mode (Ctrl-R + reads + register)
  vim.keymap.set("i", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Paste in command-line mode (e.g. after ':')
  vim.keymap.set("c", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Copy with Cmd+C in visual mode
  vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true })
end
