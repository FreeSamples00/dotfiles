--- Editor options: indentation, display, search, clipboard, undo

-- add Mason bin to PATH for LSP/tools
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

local opts = {
  shiftwidth = 2, -- 2-space indentation
  tabstop = 2,
  softtabstop = 2,
  expandtab = true, -- spaces instead of tabs
  wrap = false, -- no wrapping by default (text filetypes override in autocmds)
  termguicolors = true, -- 24-bit color
  number = true,
  relativenumber = true,
  clipboard = "unnamedplus", -- system clipboard
  undofile = true, -- persistent undo across sessions
  confirm = true, -- confirm before abandoning unsaved changes
  scrolloff = 5, -- keep 5 lines visible around cursor
  fillchars = { eob = " " }, -- hide ~ at end of buffer
  wildmode = "list:full", -- show all completions, don't auto-select
  ignorecase = true, -- case-insensitive search
  smartcase = true, -- case-sensitive when uppercase present
  cursorline = true, -- highlight current line
  mouse = "a",
  mousemodel = "extend",
}

for opt, val in pairs(opts) do
  vim.opt[opt] = val
end

-- diff mode options
vim.opt.diffopt:append("inline:char") -- char-level DiffText highlighting
vim.opt.diffopt:append("linematch:60") -- align similar lines across buffers
vim.opt.diffopt:append("context:3") -- 3 lines of context around changes

-- OSC52 clipboard for SSH sessions
if os.getenv("SSH_CONNECTION") or os.getenv("SSH_TTY") then
  local osc52 = require("vim.ui.clipboard.osc52")
  -- zellij blocks osc52 paste signals, default to yank only
  if os.getenv("ZELLIJ") then
    vim.g.clipboard = {
      name = "OSC 52 (copy-only, zellij)",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = function()
          return vim.split(vim.fn.getreg('"'), "\n")
        end,
        ["*"] = function()
          return vim.split(vim.fn.getreg('"'), "\n")
        end,
      },
    }
  else
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end
