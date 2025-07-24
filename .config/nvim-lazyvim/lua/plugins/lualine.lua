return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return os.date("%-I:%M %p")
          end,
        },
        lualine_x = {
          {
            function()
              if os.getenv("TMUX") then
                return ""
              else
                return ""
              end
            end,
            color = {
              fg = "#7AA87F",
              bg = nil,
              gui = "bold",
            },
          },
        },
      },
    },
  },
}
