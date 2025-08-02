return {
  "bullets-vim/bullets.vim",
  config = function()
    vim.g.bullets_delete_last_bullet_if_empty = 2

    vim.keymap.set("v", "<leader>m#", "<cmd>RenumberSelection<CR><Esc>", { desc = "Renumber lists in selection" })
    vim.keymap.set("n", "<leader>mx", "<cmd>ToggleCheckbox<cr>", { desc = "Toggle checkbox" })
    vim.keymap.set("i", "<C-,>", "<cmd>BulletPromote<cr>", { desc = "Promote bullet" })
    vim.keymap.set("i", "<C-.>", "<cmd>BulletDemote<cr>", { desc = "Demote Bullet" })
    vim.keymap.set({ "i", "n" }, "<C-x>", "<cmd>ToggleCheckbox<cr>", { desc = "Toggle Checkbox" })
  end,
}
