local truncate_path = require("helpers.utils").truncate_path

local check_updates
do
  local num_updates = nil
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.filetype == "snacks_dashboard" then
        num_updates = nil
        Snacks.dashboard.update()
      end
    end,
  })
  check_updates = function()
    if num_updates ~= nil then
      return num_updates
    end
    local ok, Checker = pcall(require, "lazy.manage.checker")
    if not ok then
      num_updates = 0
      return 0
    end
    Checker.fast_check({ report = false })
    num_updates = #Checker.updated
    return num_updates
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { key = "q", action = ":qa", hidden = true },
          {
            key = "U",
            desc = "Update Plugins",
            action = ":Lazy update",
            hidden = true,
            enabled = function()
              return check_updates() > 0
            end,
          },
        },
      },
      sections = {
        { section = "header", padding = 1 },
        function()
          local stats = require("lazy.stats").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          return {
            align = "center",
            text = {
              { "💤 ", hl = "" },
              { "Loaded ", hl = "keyword" },
              { stats.loaded .. "/" .. stats.count, hl = "special" },
              { " plugins in ", hl = "keyword" },
              { ms .. "ms", hl = "special" },
            },
            padding = 0,
          }
        end,
        function()
          local updates = check_updates()
          if updates == 0 then
            return { padding = 0 }
          end
          return {
            align = "center",
            text = {
              { "📦 ", hl = "keyword" },
              { tostring(updates), hl = "special" },
              { " ", hl = "keyword" },
              { "Updates available", hl = "keyword" },
            },
            padding = 1,
          }
        end,
        {
          title = " " .. truncate_path(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"), 45),
          padding = 1,
          align = "center",
        },
        { section = "keys", gap = 1, padding = 0 },
      },
    },
  },
}
