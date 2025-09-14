-- Docs: https://cmp.saghen.dev/

return {
  "saghen/blink.cmp",

  opts = {
    completion = {
      list = {

        -- manually select items from list, text only inserted on acceptance
        selection = { preselect = false, auto_insert = false },
      },
    },
  },
}
