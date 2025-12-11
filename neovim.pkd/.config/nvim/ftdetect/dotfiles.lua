-- Maps dot-XXXXX → filetype XXXXX
vim.filetype.add({
  pattern = {
    ["dot%-(.+)"] = function(_, _, ext)
      return ext
    end,
  },
  -- add rc files as their filetype
  filename = {
    [".zshrc"] = "zsh",
    ["dot-zshrc"] = "zsh",
    [".bashrc"] = "bash",
    ["dot-bashrc"] = "bash",
    [".vimrc"] = "vim",
    ["dot-vimrc"] = "vim",
    [".screenrc"] = "screen",
    ["dot-screenrc"] = "screen",
  },
})
