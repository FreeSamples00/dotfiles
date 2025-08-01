return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Ensure blink.cmp is disabled by default.
      if vim.b.blink_cmp_enabled == nil or vim.b.blink_cmp_enabled == true then
        vim.b.blink_cmp_enabled = false
      end

      -- The 'enabled' option controls when blink.cmp is active.
      -- It will only be active when vim.b.blink_cmp_enabled is true.
      opts.enabled = function()
        return vim.b.blink_cmp_enabled
      end

      -- Function to toggle cmp completion
      local function toggle_blink_completion()
        local cmp = require("blink.cmp")

        if vim.b.blink_cmp_enabled == false then
          vim.b.blink_cmp_enabled = true
          cmp.show()
          vim.cmd("redraw")
        else
          vim.b.blink_cmp_enabled = false
          cmp.hide()
          vim.cmd("redraw")
        end
      end

      vim.keymap.set({ "i" }, "<C-c>", toggle_blink_completion, {
        desc = "Manually toggle blink cmp completion",
      })
    end,
  },
}
