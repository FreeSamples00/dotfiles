--- bullets.vim: auto bullet lists, checkbox toggling, and indentation
--- Manual key mappings (set_mappings=0) to avoid conflicts with other plugins

return {
  "bullets-vim/bullets.vim",
  lazy = true,
  ft = "markdown",
  keys = {
    { "<C-,>", "<cmd>BulletPromote<cr>", mode = { "i", "n" }, desc = "Bullet Left", ft = "markdown" },
    { "<C-.>", "<cmd>BulletDemote<cr>", mode = { "i", "n" }, desc = "Bullet Right", ft = "markdown" },
    { "<C-x>", "<cmd>ToggleCheckbox<cr>", mode = { "i", "n" }, desc = "Toggle Checkbox", ft = "markdown" },
    { "<cr>", "<cmd>InsertNewBullet<cr>", mode = { "i" }, desc = "New Bullet", ft = "markdown" },
    { "o", "<cmd>InsertNewBullet<cr>", desc = "New Bullet", ft = "markdown" },
    { "<leader>M,", "<cmd>BulletPromote<cr>", desc = "Bullet Left", ft = "markdown" },
    { "<leader>M.", "<cmd>BulletDemote<cr>", desc = "Bullet Right", ft = "markdown" },
    { "<leader>Mx", "<cmd>ToggleCheckbox<cr>", desc = "Toggle Checkbox", ft = "markdown" },
  },
  init = function()
    vim.g.bullets_delete_last_bullet_if_empty = 2 -- clean up empty trailing bullets
    vim.g.bullets_nested_checkboxes = 0 -- no nested checkbox logic
    vim.g.bullets_checkbox_markers = " x" -- simple checked/unchecked
    vim.g.bullets_outline_levels = { "num", "abc", "std-" } -- outline numbering
    vim.g.bullets_renumber_on_change = 0 -- don't auto-renumber
    vim.g.bullets_set_mappings = 0 -- manual mappings only (see keys above)
  end,
}
