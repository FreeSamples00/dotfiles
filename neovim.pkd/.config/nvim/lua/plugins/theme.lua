--- Catppuccin theme (mocha) with transparent background + fallback bg.nvim

return {
  "typicode/bg.nvim",

  {
    "catppuccin/nvim",
    name = "catppuccin-custom",
    lazy = false,
    priority = 1000, -- load before other plugins
    auto_integrations = true,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
    opts = {
      flavour = "mocha",
      no_italic = false,
      term_colors = true,
      transparent_background = true, -- let terminal bg show through
      styles = { -- no extra styling on syntax groups
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
          base = "#1E1E1E", -- match terminal bg
          mantle = "#1E1E1E",
          crust = "#000000",
        },
      },
      highlight_overrides = {
        mocha = function(colors)
          return {
            ["@markup.italic"] = { fg = colors.yellow, style = { "italic" } },
            CursorLineNr = { fg = colors.peach, style = { "bold" } },
            PmenuSel = { bg = colors.surface0, fg = colors.peach, style = { "bold" } },
            CursorLine = { bg = colors.surface0 },
            NormalFloat = { bg = "NONE" }, -- transparent floats
            FloatBorder = { bg = "NONE" },
            FloatTitle = { bg = "NONE" },
          }
        end,
      },
      integrations = {
        dropbar = { enabled = true, color_mode = true },
        blink_cmp = { enabled = true, style = "bordered" },
        gitsigns = true,
        mason = true,
        noice = true,
        render_markdown = true,
        which_key = true,
        snacks = { enabled = true },
        harpoon = true,
        --TODO: lualine integration
      },
    },
  },
}
