-- Miscelaneous fun stuff
return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "kazhala/close-buffers.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    opts = {
      preserve_window_layout = { "this", "nameless" },
    },
  },
  {
    "tpope/vim-sleuth",
    event = "BufReadPost",
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
}
