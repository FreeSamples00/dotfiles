--- Flash.nvim: fuzzy motion/jump with treesitter integration
---
--- Jump to any visible location in 2-3 keystrokes.
--- Shows labeled matches after typing a search pattern.

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    label = {
      style = "inline", -- insert label into text (doesn't overwrite match char)
      before = true, -- show label before the match
      after = false, -- no label after the match
      current = false,
      rainbow = {
        enabled = true, -- color-code labels by proximity/depth
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    -- Override rainbow highlights: fg instead of bg, bold+italic
    -- Flash creates these groups on-demand, so we wrap get_color
    -- to override each group right after Flash creates it.
    local rainbow_mod = require("flash.rainbow")
    local orig_get_color = rainbow_mod.get_color

    rainbow_mod.get_color = function(idx, shade)
      local hl = orig_get_color(idx, shade)
      if hl then
        local hl_data = vim.api.nvim_get_hl(0, { name = hl, link = false })
        if hl_data.bg then
          vim.api.nvim_set_hl(0, hl, {
            fg = hl_data.bg, -- swap: bg color → fg color
            bold = true,
            italic = true,
          })
        end
      end
      return hl
    end

    -- Base FlashLabel: use Substitute's bg as fg, bold+italic
    local function set_flash_label()
      local sub = vim.api.nvim_get_hl(0, { name = "Substitute", link = false })
      vim.api.nvim_set_hl(0, "FlashLabel", {
        fg = sub.bg or sub.fg,
        bold = true,
        italic = true,
      })
    end
    set_flash_label()

    -- Re-apply after colorscheme changes (Catppuccin overrides)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_flash_label,
    })
  end,
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
  },
}
