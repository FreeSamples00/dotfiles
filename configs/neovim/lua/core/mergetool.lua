--- Mergetool keybindings: only active when $MERGED is set (git mergetool)
--- Layout: LOCAL | MERGED | REMOTE — work in the MERGED (middle) buffer
---
---   <     get hunk from LOCAL       >     get hunk from REMOTE
---   g<    take entire file LOCAL    g>    take entire file REMOTE
---   n     next conflict             N     previous conflict
---   q     save & quit             Q     abort mergetool
---   ?     show help popup
---
---   H     jump to LOCAL window      L     jump to REMOTE window

local augroup = vim.api.nvim_create_augroup("Mergetool", { clear = true })

local function setup_mergetool()
  if not vim.env.MERGED then
    return
  end

  vim.notify("**MERGING** - `?` for help", vim.log.levels.INFO, { title = "Mergetool" })

  -- Rebalance window widths on terminal resize
  vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
      vim.cmd("wincmd =")
    end,
  })

  vim.schedule(function()
    -- Find the MERGED buffer by path
    local merged_path = vim.fn.resolve(vim.fn.fnamemodify(vim.env.MERGED, ":p"))
    local merged_buf = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local buf_path = vim.fn.resolve(vim.api.nvim_buf_get_name(buf))
      if buf_path == merged_path then
        merged_buf = buf
        break
      end
    end

    if not merged_buf then
      vim.notify("Mergetool: could not find MERGED buffer for " .. merged_path, vim.log.levels.WARN)
      return
    end

    -- Balance all diff window widths on open
    vim.cmd("wincmd =")

    local function bmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = merged_buf, silent = true, desc = desc })
    end

    local function diffget_and_next(source)
      vim.cmd.diffget(source)
      vim.cmd.diffupdate()
      pcall(vim.cmd.normal, { "]c", bang = true })
    end

    -- Hunk operations
    bmap("<", function()
      diffget_and_next("local")
    end, "Merge: get hunk from LOCAL")
    bmap(">", function()
      diffget_and_next("remote")
    end, "Merge: get hunk from REMOTE")

    bmap("g<", function()
      vim.cmd("%diffget local")
      vim.cmd.diffupdate()
    end, "Merge: take all from LOCAL")
    bmap("g>", function()
      vim.cmd("%diffget remote")
      vim.cmd.diffupdate()
    end, "Merge: take all from REMOTE")

    -- Conflict navigation
    bmap("n", function()
      vim.cmd.normal({ "]c", bang = true })
    end, "Merge: next conflict")
    bmap("N", function()
      vim.cmd.normal({ "[c", bang = true })
    end, "Merge: prev conflict")

    -- Undo
    bmap("u", function()
      vim.cmd.undo()
      vim.cmd.diffupdate()
      pcall(vim.cmd.normal, { "[c", bang = true })
    end, "Merge: undo diffget")

    -- Quit
    bmap("q", "<cmd>wqa<cr>", "Merge: save & quit")
    bmap("Q", "<cmd>cquit<cr>", "Merge: abort")

    -- Help popup (centered, color-coded with Catppuccin palette)
    local wrap_options = require("helpers.utils").wrap_options
    local colors = require("catppuccin.palettes").get_palette("mocha")

    local hl_groups = {
      MergeHelpKey = { fg = colors.peach },
      MergeHelpTitle = { fg = colors.mauve, bold = true },
      MergeHelpSep = { fg = colors.surface2 },
      MergeHelpDesc = { fg = colors.text },
      MergeHelpLayout = { fg = colors.blue },
    }
    for name, opts in pairs(hl_groups) do
      vim.api.nvim_set_hl(0, name, opts)
    end

    local K, D, T, S, L_hl = "MergeHelpKey", "MergeHelpDesc", "MergeHelpTitle", "MergeHelpSep", "MergeHelpLayout"

    local help_lines = {
      {},
      { { "  LAYOUT", T } },
      { { "  ═══════", S } },
      { { "  ", D }, { "LOCAL", L_hl }, { " │ ", D }, { "MERGED", L_hl }, { " │ ", D }, { "REMOTE", L_hl } },
      {},
      { { "  MERGE ACTIONS", T } },
      { { "  ═════════════", S } },
      { { "  ", D }, { "> / <", K }, { "       take hunk from REMOTE / LOCAL", D } },
      { { "  ", D }, { "g> / g<", K }, { "     take file from REMOTE / LOCAL", D } },
      { { "  ", D }, { "u", K }, { "           undo", D } },
      { { "  ", D }, { "q", K }, { "           save & quit", D } },
      { { "  ", D }, { "Q", K }, { "           abort mergetool", D } },
      {},
      { { "  NAVIGATION", T } },
      { { "  ═══════════", S } },
      { { "  ", D }, { "n / N", K }, { "       next / previous conflict", D } },
      { { "  ", D }, { "H / L", K }, { "       jump left / right", D } },
      {},
      {},
      { { "  ───────────────────────", S } },
      { { "  ", D }, { "?", K }, { "           help", D } },
    }

    local ns = vim.api.nvim_create_namespace("mergetool_help")

    bmap("?", function()
      local text_lines = {}
      for _, line in ipairs(help_lines) do
        local s = ""
        for _, seg in ipairs(line) do
          s = s .. seg[1]
        end
        table.insert(text_lines, s)
      end

      Snacks.win({
        border = "rounded",
        title = " Mergetool Help ",
        width = 49,
        height = 22,
        text = text_lines,
        on_buf = function(self)
          for i, line in ipairs(help_lines) do
            local col = 0
            for _, seg in ipairs(line) do
              if seg[2] then
                vim.api.nvim_buf_add_highlight(self.buf, ns, seg[2], i - 1, col, col + #seg[1])
              end
              col = col + #seg[1]
            end
          end
        end,
        wo = vim.tbl_extend("force", wrap_options, {
          signcolumn = "yes",
          statuscolumn = " ",
          conceallevel = 3,
        }),
        keys = {
          q = "close",
          ["<esc>"] = "close",
          ["?"] = "close",
        },
      })
    end, "Merge: help")

    -- Global: directional window hopping
    vim.keymap.set("n", "H", "<C-w>h", { silent = true, desc = "Merge: jump to LOCAL" })
    vim.keymap.set("n", "L", "<C-w>l", { silent = true, desc = "Merge: jump to REMOTE" })
  end)
end

-- Handle both cases: VimEnter already fired or hasn't yet
if vim.v.vim_did_enter == 1 then
  setup_mergetool()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    once = true,
    callback = setup_mergetool,
  })
end
