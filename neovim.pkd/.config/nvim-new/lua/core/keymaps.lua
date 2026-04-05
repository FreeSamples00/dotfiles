local map = require("helpers.keys").map

map("n", "<esc>", "<cmd>nohlsearch<cr><esc>", "Esc + clear hl")

map("n", "U", "<C-r>", "Redo")

---- remove annoying keymaps ----

-- Disable Ex mode
vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "gQ", "<Nop>")

-- remap command window
vim.keymap.set("n", "q:", "<Nop>")
vim.keymap.set("n", "q/", "<Nop>")
vim.keymap.set("n", "q?", "<Nop>")

-- remove join line
vim.keymap.set("n", "J", "<Nop>")

---- emacs movements for commandline ----

-- cmd arrow
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

-- opt arrow
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")

-- opt delete
vim.keymap.set("c", "<M-BS>", "<C-w>")

---- 'd' without yanking ----

-- Normal mode
vim.keymap.set("n", "d", '"_d', {
  remap = false,
  silent = true,
  desc = "Delete without yanking",
})
-- Visual mode
vim.keymap.set("v", "d", '"_d', {
  remap = false,
  silent = true,
  desc = "Delete visual selection without yanking",
})

---- 'c' without yanking ----

-- Normal mode
vim.keymap.set("n", "c", '"_c', {
  remap = false,
  silent = true,
  desc = "Delete without yanking",
})

-- Visual mode
vim.keymap.set("v", "c", '"_c', {
  remap = false,
  silent = true,
  desc = "Delete visual selection without yanking",
})

---- 'p' without yanking ----

map("x", "p", [["_dp]], "Paste without copying")
map("x", "P", [["_dp]], "Paste without copying")

---- `xx` to cut line ----

vim.keymap.set("n", "xx", "yydd", {
  remap = false,
  silent = true,
  desc = "Yank line then delete it",
})

-- Deleting buffers
local buffers = require("helpers.buffers")
map("n", "<leader>bd", buffers.delete_this, "Close Buffer")
map("n", "<leader>bo", buffers.delete_others, "Close Other Buffers")
map("n", "<leader>bD", buffers.delete_all, "Close All Buffers")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Toggle auto-format on save
map("n", "<leader>uf", "<cmd>AutoFormatToggle<cr>", "Toggle auto-format")

-- Clear after search
map("n", "<leader>ur", "<cmd>nohl<cr>", "Clear highlights")

-- LSP commands
local noice = require("noice.lsp")
map("n", "J", vim.diagnostic.open_float, "LSP Diagnostics")
map("n", "<leader>lk", noice.signature, "Help")
map("n", "<leader>ld", vim.lsp.buf.definition, "Goto definition")
map("n", "<leader>lD", vim.lsp.buf.declaration, "Goto declaration")
map("n", "<leader>lr", vim.lsp.buf.references, "Goto references")
map("n", "<leader>lR", vim.lsp.buf.rename, "Rename Symbol")
map("n", "<leader>lD", vim.diagnostic.open_float, "Diagnostics")
map("n", "<leader>lt", vim.lsp.buf.type_definition, "Goto type definition")
