-- atone.nvim undotree
return {
  "XXiaoA/atone.nvim",
  cmd = "Atone",
  lazy = true,
  keys = {
    { "<leader>U", "<cmd>Atone toggle<cr>", mode = "n", desc = "Toggle Undotree" },
  },
  opts = {
    layout = {
      direction = "right",
      width = "adaptive",
    },
    ui = {
      border = "single",
      compact = true
    }
  },
}
