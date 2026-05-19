--- render-markdown: pretty markdown rendering with heading blocks, checkboxes, and code blocks
--- Checked items get strikethrough via custom highlight

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
      width = "block", -- full-width heading background
      right_pad = 2,
      left_pad = 1,
      position = "inline",
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      border = true,
      signs = {}, -- no sign column icons
    },
    code = {
      border = "none", -- clean code blocks
    },
    checkbox = {
      unchecked = {
        icon = "󰄱 ",
      },
      checked = {
        icon = "󰄵 ",
        scope_highlight = "RenderMarkdownCheckedStrike", -- strikethrough completed items
      },
    },
    html = {
      enabled = true,
      comment = {
        conceal = false, -- don't hide HTML comments
      },
    },
  },
}
