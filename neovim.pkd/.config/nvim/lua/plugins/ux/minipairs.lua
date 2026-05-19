--- mini.pairs: auto-pairing for brackets and quotes
--- closeopen action + word-char skip prevents unwanted pairs after identifiers

return {
  "nvim-mini/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- skip pairing after word chars
    skip_ts = { "string" }, -- skip inside treesitter strings
    skip_unbalanced = true,
    markdown = true,
    mappings = {
      -- closeopen: close if unmatched open exists, else open pair
      -- neigh_pattern: only pair when not after a word char (e.g. foo" won't add closing quote)
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    require("mini.pairs").setup(opts)
  end,
}
