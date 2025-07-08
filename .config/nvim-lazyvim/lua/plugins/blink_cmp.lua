return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Ensure blink.cmp is disabled by default.
      -- We'll use a buffer-local variable to control its state.
      -- Initialize it to false if it's not set.
      if vim.b.blink_cmp_enabled == nil then
        vim.b.blink_cmp_enabled = false
      end

      -- The 'enabled' option controls when blink.cmp is active.
      -- It will only be active when vim.b.blink_cmp_enabled is true.
      opts.enabled = function()
        return vim.b.blink_cmp_enabled
      end

      -- Define a function to manually trigger completion:
      -- 1. Temporarily enable blink.cmp.
      -- 2. Trigger completion (usually by sending a dummy character or just letting it re-evaluate).
      -- 3. Hide the completion window immediately after it appears.
      local function manual_blink_completion()
        local cmp = require("blink.cmp")

        -- Enable blink.cmp temporarily
        vim.b.blink_cmp_enabled = true

        -- Trigger completion. In blink.cmp, simply calling it (or letting it
        -- re-evaluate after `enabled` becomes true) should cause it to show.
        -- We might need a small delay or a redraw to ensure it picks up the change.
        -- A common way to force a re-evaluation is to send a dummy keystroke.
        vim.cmd("redraw") -- Redraw might help blink.cmp detect the state change

        -- Hide the completion window after it's been triggered.
        -- We'll set a timer to do this slightly after it would appear.
        vim.defer_fn(function()
          cmp.hide()
          -- Optionally, disable blink.cmp again after the manual trigger.
          -- If you want it to stay enabled until you hide it yourself, remove this line.
          vim.b.blink_cmp_enabled = false
        end, 100) -- Adjust delay if needed (e.g., 50ms-200ms)
      end

      -- Set a keybinding for manual triggering (e.g., <C-Space>)
      vim.keymap.set({ "i" }, "<C-Space>", manual_blink_completion, {
        desc = "Manually Trigger Blink Completion",
      })

      return opts
    end,
  },
}
