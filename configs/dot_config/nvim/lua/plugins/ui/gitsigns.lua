--- Gitsigns: git hunks in the signcolumn with navigation and preview
---
--- Toggle all git signs with <leader>uG.

return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      -- hunk navigation
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function()
        gs.nav_hunk("last")
      end, "Last Hunk")
      map("n", "[H", function()
        gs.nav_hunk("first")
      end, "First Hunk")

      -- hunk preview
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")

      -- hunk text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
}
