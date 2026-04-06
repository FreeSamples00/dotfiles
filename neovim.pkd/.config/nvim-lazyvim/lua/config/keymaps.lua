-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ==================== rebind U to redo ====================

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- ==================== remove annoying keymaps ====================

-- Disable Ex mode
vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "gQ", "<Nop>")

-- remap command window
vim.keymap.set("n", "q:", "<Nop>")
vim.keymap.set("n", "q/", "<Nop>")
vim.keymap.set("n", "q?", "<Nop>")
vim.keymap.set("n", "<Leader>h:", "q:", { desc = "Command history" })
vim.keymap.set("n", "<Leader>h/", "q/", { desc = "Search history" })
vim.keymap.set("n", "<Leader>h?", "q?", { desc = "Search history" })

-- ==================== emacs movements for commandline ====================

-- cmd arrow
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

-- opt arrow
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")

-- opt delete
vim.keymap.set("c", "<M-BS>", "<C-w>")

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

-- ==================== `xx` to cut line ====================

vim.keymap.set("n", "xx", "yydd", {
  remap = false,
  silent = true,
  desc = "Yank line then delete it",
})

-- ==================== Terminal Emulator ====================

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, buffer = 0 })
  end,
})

-- ==================== Toggle Word Wrap ====================

vim.keymap.set("n", "<leader>W", ":set wrap!<CR>", {
  remap = false,
  silent = true,
  desc = "Toggle Word Wrap",
})

-- ==================== Neovide ====================

if vim.g.neovide then
  -- Paste (normal / visual)
  vim.keymap.set({ "n", "v" }, "<D-v>", '"+p', { noremap = true, silent = true })

  -- Paste in insert mode (Ctrl-R + reads + register)
  vim.keymap.set("i", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Paste in command-line mode (e.g. after ':')
  vim.keymap.set("c", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Copy with Cmd+C in visual mode
  vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true })

  -- resize neovide font
  vim.keymap.set({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
