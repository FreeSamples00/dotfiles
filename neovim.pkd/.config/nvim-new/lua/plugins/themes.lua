-- Themes
return {
  "typicode/bg.nvim",

  "ellisonleao/gruvbox.nvim",

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
    opts = {
      no_italic = false,
      term_colors = true,
      transparent_background = true,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#1E1E1E",
          mantle = "#1E1E1E",
          crust = "#000000",
        },
      },
      custom_highlights = function(colors)
        return {
          ["@markup.italic"] = { fg = colors.yellow, style = { "italic" } },
          CursorLineNr = { fg = colors.peach, style = { "bold" } },
          CursorLine = { bg = colors.surface0 },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },
        }
      end,
      integrations = {
        dropbar = {
          enabled = true,
          color_mode = true,
        },
      },
    },
  },

  {
    "rose-pine/nvim",
    name = "rose-pine",
  },

  "sainnhe/everforest",

  "savq/melange-nvim",
}
