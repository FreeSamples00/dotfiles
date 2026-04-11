return {
  {
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
    },
  },
  {
    "bullets-vim/bullets.vim",
    lazy = true,
    ft = "markdown",
    keys = {
      { "<C-,>", "<cmd>BulletPromote<cr>", mode = { "i", "n" }, desc = "Promote bullet" },
      { "<C-.>", "<cmd>BulletDemote<cr>", mode = { "i", "n" }, desc = "Demote bullet" },
      { "<C-x>", "<cmd>ToggleCheckbox<cr>", mode = { "i", "n" }, desc = "Toggle checkbox" },
    },
    init = function()
      vim.g.bullets_delete_last_bullet_if_empty = 2
      vim.g.bullets_nested_checkboxes = 0
      vim.g.bullets_checkbox_markers = " x"
      vim.g.bullets_outline_levels = { "num", "abc", "std-" }
      vim.g.bullets_renumber_on_change = 0
    end,
  },
}
