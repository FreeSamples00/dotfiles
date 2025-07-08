-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Normal mode: Remap 'd' to delete without yanking (black-hole register)
vim.keymap.set("n", "d", '"_d', {
  remap = false, -- Equivalent to 'noremap'
  silent = true, -- Prevents messages like "Invalid key" if you type 'd' too fast alone
  desc = "Delete without yanking (black hole)",
})

-- Visual mode: Remap 'd' to delete visual selection without yanking
vim.keymap.set("v", "d", '"_d', {
  remap = false, -- Equivalent to 'noremap'
  silent = true,
  desc = "Delete visual selection without yanking (black hole)",
})

-- Visual mode: remap 'p' & 'P' to put replace text w/out yanking the replaced text
vim.keymap.set("x", "p", [["_dp]], {
  desc = "Paste without copying overwritten text (visual)",
})
vim.keymap.set("x", "P", [["_dp]], {
  desc = "Paste without copying overwritten text (visual)",
})

vim.keymap.set("n", "gb", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "gB", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
