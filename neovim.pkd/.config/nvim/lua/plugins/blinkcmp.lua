-- Docs: https://cmp.saghen.dev/

return {
  "saghen/blink.cmp",

  opts = {
    fuzzy = {
      implementation = "lua",
    },
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Enter>"] = { "accept", "fallback" },
    },
    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
  },
}
