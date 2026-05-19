return {
  "folke/todo-comments.nvim",
  event = "BufReadPost",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "XXX" } })
      end,
      desc = "Comments: Todo/Fix",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Comments: Tagged",
    },
  },
  opts = {},
}
