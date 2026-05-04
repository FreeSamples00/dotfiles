-- plugins that background highlight
return {
  { -- comment highlighting
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
  },
  { -- color code highlighting
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      lazy_load = true,
      parsers = {
        names = { enable = false },
        xterm = { enable = true },
        hex = {
          aarrggbb = true,
        },
      },
    },
  },
}
