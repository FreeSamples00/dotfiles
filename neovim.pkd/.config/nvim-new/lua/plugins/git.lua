-- Git related plugins
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {},
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPost",
    config = function()
      require("git-conflict").setup({
        default_mappings = {
          ours = "co",
          theirs = "ct",
          none = "c0",
          both = "cb",
          next = "cn",
          prev = "cp",
        },
      })
    end,
  },
}
