--- Snacks dashboard: startup screen with plugin stats, update check, and cwd section

local truncate_path = require("helpers.utils").truncate_path

local check_lazy_updates
local lazy_update_count -- cached Lazy update count, reset on dashboard re-entry
do
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.filetype == "snacks_dashboard" then
        lazy_update_count = nil
        mason_update_count = nil
        Snacks.dashboard.update()
      end
    end,
  })
  check_lazy_updates = function()
    if lazy_update_count ~= nil then
      return lazy_update_count
    end
    local ok, Checker = pcall(require, "lazy.manage.checker")
    if not ok then
      lazy_update_count = 0
      return 0
    end
    Checker.fast_check({ report = false })
    lazy_update_count = #Checker.updated
    return lazy_update_count
  end
end

local check_mason_updates
local mason_update_count -- cached Mason update count, reset on dashboard re-entry
do
  check_mason_updates = function()
    if mason_update_count ~= nil then
      return mason_update_count
    end
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
      mason_update_count = 0
      return 0
    end
    local outdated = 0
    for _, pkg in ipairs(registry.get_installed_packages()) do
      local installed_ver = pkg:get_installed_version()
      local latest_ver = pkg:get_latest_version()
      if installed_ver and latest_ver and installed_ver ~= latest_ver then
        outdated = outdated + 1
      end
    end
    mason_update_count = outdated
    return outdated
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
          { key = "l", action = ":Lazy", hidden = true },
          { key = "m", action = ":Mason", hidden = true },
          {
            key = "U",
            desc = "Update All",
            action = function()
              -- Lazy: async update, refresh dashboard on completion
              require("lazy.manage").update({ show = false }):wait(function()
                lazy_update_count = nil
                pcall(Snacks.dashboard.update)
              end)
              -- Mason: async per-package, refresh dashboard when all done
              local ok, registry = pcall(require, "mason-registry")
              if ok then
                local outdated = {}
                for _, pkg in ipairs(registry.get_installed_packages()) do
                  local installed_ver = pkg:get_installed_version()
                  local latest_ver = pkg:get_latest_version()
                  if installed_ver and latest_ver and installed_ver ~= latest_ver then
                    outdated[#outdated + 1] = pkg
                  end
                end
                if #outdated > 0 then
                  local done = 0
                  local total = #outdated
                  for _, pkg in ipairs(outdated) do
                    pkg:install({}, function()
                      done = done + 1
                      if done == total then
                        mason_update_count = nil
                        vim.schedule(function()
                          pcall(Snacks.dashboard.update)
                        end)
                      end
                    end)
                  end
                end
              end
            end,
            hidden = true,
            enabled = function()
              return check_lazy_updates() > 0 or check_mason_updates() > 0
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
          local lazy_updates = check_lazy_updates()
          local mason_updates = check_mason_updates()
          if lazy_updates == 0 and mason_updates == 0 then
            return { padding = 0 }
          end
          local text = { { "", hl = "keyword" } }
          if lazy_updates > 0 then
            text[#text + 1] = { "📦 " .. lazy_updates, hl = "special" }
          end
          if mason_updates > 0 then
            if lazy_updates > 0 then
              text[#text + 1] = { "  ", hl = "" }
            end
            text[#text + 1] = { "🔧 " .. mason_updates, hl = "special" }
          end
          return { align = "center", text = text, padding = 1 }
        end,
        {
          title = " " .. truncate_path(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"), 45), -- truncated cwd
          padding = 1,
          align = "center",
        },
        { section = "keys", gap = 1, padding = 0 },
      },
    },
  },
}
