return {
  "MeanderingProgrammer/render-markdown.nvim",
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
  init = function()
    vim.api.nvim_set_hl(0, "RenderMarkdownCheckedStrike", {
      strikethrough = true,
      default = true,
    })
  end,
  opts = {
    heading = {
      width = "block",
      right_pad = 2,
      left_pad = 1,
      position = "inline",
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      border = true,
      signs = {},
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
    html = {
      enabled = true,
      comment = {
        conceal = false,
      },
    },
  },
}
