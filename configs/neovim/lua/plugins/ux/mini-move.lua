--- mini.move: move text lines/blocks with Alt+hjkl

return {
  "echasnovski/mini.move",
  event = "VeryLazy",
  config = function()
    require("mini.move").setup()
  end,
}
