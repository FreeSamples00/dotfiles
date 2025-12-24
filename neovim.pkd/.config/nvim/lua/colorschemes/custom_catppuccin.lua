return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("catppuccin").load()
      end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      no_italic = false,
      term_colors = true,
      transparent_background = false,
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
        -- NOTE: Change colors to match terminal theme
        mocha = {
          base = "#1E1E1E",
          mantle = "#1E1E1E",
          crust = "#000000",
        },
      },
      -- NOTE: Custom yellow highlighting for markup italics (also yellow color, not default that matched bold)
      custom_highlights = function(colors)
        return {
          ["@markup.italic"] = { fg = colors.yellow, style = { "italic" } },
        }
      end,
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        dropbar = {
          enabled = true,
          color_mode = true,
        },
      },
    },
  },
}
