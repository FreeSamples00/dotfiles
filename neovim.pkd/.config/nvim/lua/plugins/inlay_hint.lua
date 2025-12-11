return {
  "felpafel/inlay-hint.nvim",
  tag = "v1.0.0", -- Use a specific tag for stability
  event = "LspAttach",
  config = function()
    require("inlay-hint").setup({
      virt_text_pos = "eol", -- Set to 'eol' or 'right_align' for end-of-line hints
      -- You can also provide a custom display_callback for more granular control
      -- display_callback = function(line_hints, options)
      --   -- Custom logic here, similar to the example in the plugin's README
      -- end,
    })

    -- It's good practice to ensure inlay hints are enabled on LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("InlayHintAttach", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end,
}
