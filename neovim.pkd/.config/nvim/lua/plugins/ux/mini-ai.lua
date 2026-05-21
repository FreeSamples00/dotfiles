--- mini.ai: extended text objects with treesitter integration
---
--- Enhances a/i text objects for structural selection:
---   if/af → inside/around function
---   ic/ac → inside/around class
---   io/ao → inside/around block/conditional/loop
---   it/at → inside/around HTML tags
---   ia/aa → inside/around parameter/argument
---   id/ad → inside/around digits
---   iu/au → inside/around function call
---
--- Press a/i key twice to expand to outer scope (e.g. if→if = outer function).

return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- HTML tags
        d = { "%f[%d]%d+" }, -- digits
        u = ai.gen_spec.function_call(), -- function call ("usage")
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
    -- Register text objects with which-key for operator-pending and visual modes
    local wk = require("which-key")
    wk.add({
      { "i", group = "inside", mode = { "o", "x" } },
      { "a", group = "around", mode = { "o", "x" } },
      { "if", desc = "function", mode = { "o", "x" } },
      { "af", desc = "function", mode = { "o", "x" } },
      { "ic", desc = "class", mode = { "o", "x" } },
      { "ac", desc = "class", mode = { "o", "x" } },
      { "io", desc = "block/conditional/loop", mode = { "o", "x" } },
      { "ao", desc = "block/conditional/loop", mode = { "o", "x" } },
      { "it", desc = "HTML tag", mode = { "o", "x" } },
      { "at", desc = "HTML tag", mode = { "o", "x" } },
      { "ia", desc = "parameter", mode = { "o", "x" } },
      { "aa", desc = "parameter", mode = { "o", "x" } },
      { "id", desc = "digits", mode = { "o", "x" } },
      { "ad", desc = "digits", mode = { "o", "x" } },
      { "iu", desc = "function call", mode = { "o", "x" } },
      { "au", desc = "function call", mode = { "o", "x" } },
    })
  end,
}
