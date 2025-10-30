-- Docs: https://cmp.saghen.dev/

return {
  "saghen/blink.cmp",

  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    completion = {
      list = {
        -- manually select items from list, text only inserted on acceptance
        selection = { preselect = false, auto_insert = false },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = {
        menu = { auto_show = true },
      },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
  },
}
