-- Git related plugins
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "akinsho/git-conflict.nvim",
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
