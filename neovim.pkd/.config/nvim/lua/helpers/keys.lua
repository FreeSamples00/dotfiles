--- Keymap helpers: consistent silent+desc wrappers for global, LSP, and DAP mappings

local M = {}

---@param mode string|table Mode(s) for the mapping
---@param lhs string LHS key sequence
---@param rhs string|function RHS key sequence or callback
---@param desc string Description for which-key
function M.map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

---@param lhs string LHS key sequence
---@param rhs string|function RHS key sequence or callback
---@param bufnr number Buffer number for buffer-local mapping
---@param desc string Description for which-key
function M.lsp_map(lhs, rhs, bufnr, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

---@param mode string|table Mode(s) for the mapping
---@param lhs string LHS key sequence
---@param rhs string|function RHS key sequence or callback
---@param desc string Description for which-key
function M.dap_map(mode, lhs, rhs, desc)
  M.map(mode, lhs, rhs, desc)
end

---@param global_key string Leader key
---@param local_key string Local leader key
function M.set_leaders(global_key, local_key)
  vim.g.mapleader = global_key
  vim.g.maplocalleader = local_key
  M.map({ "n", "v" }, global_key, "<nop>")
  M.map({ "n", "v" }, local_key, "<nop>")
end

return M
