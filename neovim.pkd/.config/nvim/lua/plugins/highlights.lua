-- plugins that background highlight
return {
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>t",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Comments: Tagged",
      },
      {
        "<leader>T",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "XXX" } })
        end,
        desc = "Comments: Todo/Fix",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Comments: Tagged",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "XXX" } })
        end,
        desc = "Comments: Todo/Fix",
      },
    },
    opts = {},
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      lazy_load = true,
      parsers = {
        names = { enable = false },
        xterm = { enable = true },
      },
    },
  },
}
