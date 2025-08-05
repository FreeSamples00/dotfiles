return {
  "bullets-vim/bullets.vim",

  config = function()
    vim.g.bullets_delete_last_bullet_if_empty = 2
    vim.g.bullets_nested_checkboxes = 0
    vim.g.bullets_checkbox_markers = " x"
    vim.g.bullets_outline_levels = { "num", "abc", "std-" }

    vim.keymap.set("i", "<C-h>", "<cmd>BulletPromote<cr>", { desc = "Promote bullet" })
    vim.keymap.set("i", "<C-l>", "<cmd>BulletDemote<cr>", { desc = "Demote Bullet" })
    vim.keymap.set({ "i", "n" }, "<C-x>", "<cmd>ToggleCheckbox<cr>", { desc = "Toggle Checkbox" })
  end,
}
