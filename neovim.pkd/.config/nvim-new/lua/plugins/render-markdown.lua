vim.api.nvim_set_hl(0, "RenderMarkdownCheckedStrike", {
  strikethrough = true,
  default = true,
})

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
  ---@module 'render-markdown'
  ---@type render.md.UserConfig

  opts = {

    latex = {
      enabled = false,
      render_modes = false,
      converter = { "utftex", "latex2text" },
      highlight = "RenderMarkdownMath",
      position = "above",
      top_pad = 1,
      bottom_pad = 1,
    },

    heading = {
      -- background coloring
      width = "block",
      right_pad = 2,
      left_pad = 1,

      -- symbols
      position = "inline",
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },

      border = true,
    },

    code = {
      border = "none",
    },

    checkbox = {
      unchecked = {
        icon = "󰄱 ",
      },
      checked = {
        icon = "󰄵 ",
        scope_highlight = "RenderMarkdownCheckedStrike",
      },
    },
  },
}
