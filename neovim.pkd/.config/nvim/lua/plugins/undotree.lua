local globals = require("helpers.globals")

return {
  "jiaoshijie/undotree",
  lazy = true,
  keys = {
    { "<leader>U", "<cmd>lua require('undotree').toggle()<cr>" },
  },
  opts = {
    position = "right",
    float_diff = "true",
    ignore_filetype = globals.ignored_filetypes,
    keymaps = {
      ["j"] = "move_next",
      ["k"] = "move_prev",
      ["gj"] = "move2parent",
      ["J"] = "move_change_next",
      ["K"] = "move_change_prev",
      ["<cr>"] = "action_enter",
      ["p"] = "enter_diffbuf",
      ["q"] = "quit",
      ["<esc>"] = "quit",
      ["S"] = "update_undotree_view",
    },
  },
}
