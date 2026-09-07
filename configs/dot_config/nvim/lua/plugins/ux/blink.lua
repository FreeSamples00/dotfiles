--- blink.cmp: completion with LSP, snippets, buffer, and path sources
--- Replaces nvim-cmp + cmp-nvim-lsp/buffer/path/lua + LuaSnip + cmp_luasnip
---
--- Keymap parity with the previous nvim-cmp config:
---   C-k/C-j   select prev/next item
---   C-d/C-f   scroll documentation
---   CR        confirm only explicitly selected item (no auto-select)
---   Tab/S-Tab select item, else jump snippet placeholder, else fallback

-- prebuilt fuzzy binary from the pinned release; must load before LSP attaches
-- so its capabilities are registered with every client

local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠲",
  Interface = "󰰃",
  Module = "󰏓",
  Property = "󰜷",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "󰉻",
  Keyword = "󰌋",
  Snippet = "󰘍",
  Color = "󰏘",
  File = "󰈔",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "󱐋",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = false,
  priority = 995, -- before lang-system (100) / lspconfig; after colorscheme (1000)
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    appearance = { kind_icons = kind_icons },
    completion = {
      list = {
        -- no preselect: CR only confirms an explicitly selected item,
        -- otherwise falls back to inserting a newline (old cmp select=false)
        selection = { preselect = false, auto_insert = false },
      },
      menu = {
        border = "rounded",
        winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } } },
      },
      documentation = {
        auto_show = true,
        window = { border = "rounded" },
      },
    },
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
    },
  },
}
