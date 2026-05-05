local map = require("helpers.keys").map

---- Core Editing ----

-- Basic
map("n", "<esc>", "<cmd>nohlsearch<cr><esc>", "Esc + clear hl")
map("n", "U", "<C-r>", "Redo")

-- Navigation in wrapped lines
vim.keymap.set(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down a visual line", expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up a visual line", expr = true, silent = true }
)
vim.keymap.set({ "n", "x" }, "0", "g0", { desc = "Start of visual line" })
vim.keymap.set({ "n", "x" }, "^", "g^", { desc = "First non-blank of visual line" })
vim.keymap.set({ "n", "x" }, "$", "g$", { desc = "End of visual line" })

-- Indentation (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

---- Yank & Register Operations ----

-- Delete without yanking
vim.keymap.set("n", "d", '"_d', {
  remap = false,
  silent = true,
  desc = "Delete without yanking",
})
vim.keymap.set("v", "d", '"_d', {
  remap = false,
  silent = true,
  desc = "Delete visual selection without yanking",
})

-- Change without yanking
vim.keymap.set("n", "c", '"_c', {
  remap = false,
  silent = true,
  desc = "Delete without yanking",
})
vim.keymap.set("v", "c", '"_c', {
  remap = false,
  silent = true,
  desc = "Delete visual selection without yanking",
})

-- Paste without yanking
map("x", "p", [["_dp]], "Paste without copying")
map("x", "P", [["_dp]], "Paste without copying")

-- Cut line
vim.keymap.set("n", "xx", "yydd", {
  remap = false,
  silent = true,
  desc = "Yank line then delete it",
})

---- Interface ----

map("n", "<leader>bd", "<cmd>bdelete<CR>", "Close")
map("n", "<leader>br", "<cmd>edit!<CR>", "Revert")
map("n", "<leader>ur", "<cmd>nohl<cr>", "Clear highlights")

---- Command-line Mode (Emacs-style) ----

-- Navigation
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")

-- Editing
vim.keymap.set("c", "<M-BS>", "<C-w>")

---- Disabled Keymaps ----

-- Ex mode
vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "gQ", "<Nop>")

-- Command window
vim.keymap.set("n", "q:", "<Nop>")
vim.keymap.set("n", "q/", "<Nop>")
vim.keymap.set("n", "q?", "<Nop>")

-- Join lines
vim.keymap.set("n", "J", "<Nop>")
