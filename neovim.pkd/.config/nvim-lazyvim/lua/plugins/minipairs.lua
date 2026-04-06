return {
  "nvim-mini/mini.pairs",
  event = "VeryLazy",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
    -- Don't pair when left character is a word character
    -- e.g., foo" won't add closing quote, but "foo" will
    mappings = {
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    LazyVim.mini.pairs(opts)
  end,
}
