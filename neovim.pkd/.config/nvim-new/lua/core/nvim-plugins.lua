-- plugins that come with nvim

local map = require("helpers.keys").map

-- undotree
vim.cmd.packadd("nvim.undotree")
map("n", "<leader>U", "<cmd>Undotree<CR>", "Toggle Undotree")

-- difftool
--vim.cmd.packadd(""nvim.difftool")
