--- grug-far.nvim: search and replace across multiple files
---
--- Opens in a vsplit with live results as you type.
--- Internal actions use <localleader> (comma): ,r replace, ,s sync, ,t history, etc.

return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          visualSelectionUsage = "auto-detect",
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and Replace",
    },
  },
  opts = {
    headerMaxWidth = 80,
  },
}
