--- Snacks setup: toggle mappings, debug helpers, help window in floating split
--- vim.g.autoformat_enabled is the cross-module toggle for format-on-save (see core/autocmds)

local wrap_options = require("helpers.utils").wrap_options

return {
  "folke/snacks.nvim",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- debug helpers
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- UI toggles (<leader>u prefix)
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.option("colorcolumn", { name = "Color Column", off = "", on = "80" }):map("<leader>uv")

        -- readonly/modifiable toggle (safety lock; won't override natively read-only buffers)
        Snacks.toggle
          .new({
            name = "Readonly",
            get = function()
              return vim.b.modifiable_locked == true
            end,
            set = function(state)
              if vim.bo.readonly then
                Snacks.notify.error("Can't toggle read-only", { title = "Readonly" })
                return
              end
              if state then
                vim.bo.modifiable = false
                vim.b.modifiable_locked = true
                Snacks.notify("Enabled **Readonly**", { title = "Readonly", level = vim.log.levels.INFO })
              else
                vim.bo.modifiable = true
                vim.b.modifiable_locked = false
                Snacks.notify("Disabled **Readonly**", { title = "Readonly", level = vim.log.levels.WARN })
              end
            end,
            notify = false, -- custom notifications in set() for edge-case messages
          })
          :map("<leader>uR")

        -- git signs toggle
        Snacks.toggle
          .new({
            name = "Git Signs",
            get = function()
              return require("gitsigns.config").config.signcolumn
            end,
            set = function(state)
              require("gitsigns").toggle_signs(state)
            end,
          })
          :map("<leader>uG")

        -- format-on-save toggle (reads vim.g.autoformat_enabled from core/autocmds)
        Snacks.toggle
          .new({
            name = "Auto Format",
            get = function()
              return vim.g.autoformat_enabled ~= false
            end,
            set = function(state)
              vim.g.autoformat_enabled = state
            end,
          })
          :map("<leader>uf")

        -- inline image toggle
        Snacks.toggle
          .new({
            name = "Inline Images",
            get = function()
              return Snacks.image.config.doc.inline
            end,
            set = function(state)
              Snacks.image.config.doc.inline = state
              local langs = Snacks.image.langs()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) then
                  local ft = vim.bo[buf].filetype
                  if vim.tbl_contains(langs, ft) then
                    Snacks.image.placement.clean(buf)
                    pcall(vim.api.nvim_del_augroup_by_name, "snacks.image.inline." .. buf)
                    vim.b[buf].snacks_image_attached = nil
                    if state then
                      Snacks.image.doc.attach(buf)
                    end
                  end
                end
              end
            end,
          })
          :map("<leader>ui")

        -- colorizer toggle
        Snacks.toggle
          .new({
            name = "Colorizer",
            get = function()
              return vim.b.colorizer_enabled ~= false
            end,
            set = function(state)
              vim.b.colorizer_enabled = state
              if state then
                require("colorizer").attach_to_buffer(0)
              else
                require("colorizer").detach_from_buffer(0)
              end
            end,
          })
          :map("<leader>uc")
      end,
    })

    -- open :help in a floating window instead of a split
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.txt",
      callback = function()
        if vim.bo.filetype == "help" then
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then -- not already floating
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_win_close(win, false)
            Snacks.win({
              buf = buf,
              border = "rounded",
              title = " Help ",
              width = 0.9,
              height = 0.8,
              wo = vim.tbl_extend("force", wrap_options, {
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              }),
            })
          end
        end
      end,
    })
  end,
}
