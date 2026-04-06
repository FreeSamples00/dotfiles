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
      position = "inline",
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
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
