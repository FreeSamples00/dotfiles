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
