--- Snacks dashboard: startup screen with plugin stats, update check, and cwd section
--- Update checks run asynchronously so the dashboard renders immediately,
--- then re-renders with update counts once checks complete.

local truncate_path = require("helpers.utils").truncate_path

local lazy_update_count -- cached Lazy update count, nil = not yet checked
local mason_update_count -- cached Mason update count, nil = not yet checked
local checks_scheduled = false -- prevent duplicate async check scheduling

--- Run update checks synchronously (fast when cached, slow when first run)
--- Returns lazy_count, mason_count
local function run_checks()
  -- Lazy check
  if lazy_update_count == nil then
    local ok, Checker = pcall(require, "lazy.manage.checker")
    if ok then
      Checker.fast_check({ report = false })
      lazy_update_count = #Checker.updated
    else
      lazy_update_count = 0
    end
  end

  -- Mason check
  if mason_update_count == nil then
    local ok, registry = pcall(require, "mason-registry")
    if ok then
      local outdated = 0
      for _, pkg in ipairs(registry.get_installed_packages()) do
        local installed_ver = pkg:get_installed_version()
        local latest_ver = pkg:get_latest_version()
        if installed_ver and latest_ver and installed_ver ~= latest_ver then
          outdated = outdated + 1
        end
      end
      mason_update_count = outdated
    else
      mason_update_count = 0
    end
  end

  return lazy_update_count, mason_update_count
end

--- Schedule async update checks and re-render dashboard on completion.
--- Called when counts are nil (first render / dashboard re-entry).
--- Guards against duplicate scheduling via checks_scheduled flag.
local function schedule_checks()
  if checks_scheduled then
    return
  end
  checks_scheduled = true
  vim.schedule(function()
    checks_scheduled = false
    run_checks()
    pcall(Snacks.dashboard.update)
  end)
end

do
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.filetype == "snacks_dashboard" then
        -- Reset caches so next render triggers async re-check
        lazy_update_count = nil
        mason_update_count = nil
        Snacks.dashboard.update()
      end
    end,
  })
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
                -- Run checks synchronously here since we need the outdated list
                local lazy_n, mason_n = run_checks()
                if mason_n > 0 then
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
              end
            end,
            hidden = true,
            enabled = function()
              -- Use cached counts when available; hide key while checks pending
              if lazy_update_count == nil and mason_update_count == nil then
                schedule_checks() -- trigger async check so key appears on re-render
                return false
              end
              return (lazy_update_count or 0) > 0 or (mason_update_count or 0) > 0
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
          -- If counts aren't cached yet, render nothing and schedule async checks.
          -- The dashboard will re-render with counts once checks complete.
          if lazy_update_count == nil and mason_update_count == nil then
            schedule_checks()
            return { padding = 0 }
          end
          local lazy_updates = lazy_update_count or 0
          local mason_updates = mason_update_count or 0
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
