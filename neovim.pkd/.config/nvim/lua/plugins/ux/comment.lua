--- Commenting: ts-comments for treesitter-aware comment detection,
--- Comment.nvim for full commenting keymaps including block mode (gb/gbc)
---
--- ts-comments overrides commentstrings based on treesitter context,
--- handling multiple comment styles and embedded languages correctly.
--- Comment.nvim provides the actual commenting operations (gcc/gbc, gc/gb)
--- and uses ts-comments' commentstrings under the hood.

return {
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
