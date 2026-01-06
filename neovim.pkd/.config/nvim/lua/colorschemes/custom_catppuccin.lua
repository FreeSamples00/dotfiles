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
      -- transparent_background = false,
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
        -- change colors to match terminal theme
        mocha = {
          base = "#1E1E1E",
          mantle = "#1E1E1E",
          crust = "#000000",
        },
      },
      custom_highlights = function(colors)
        return {
          -- custom yellow highlighting for markup italics (also yellow color, not default that matched bold)
          ["@markup.italic"] = { fg = colors.yellow, style = { "italic" } },
          -- Color active line, make bold
          CursorLineNr = { fg = colors.peach, style = { "bold" } },
          -- Tabby/Tabline highlights for transparent background
          TabLineSel = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          TabLine = { fg = colors.overlay0, bg = colors.crust },
          TabLineFill = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
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
