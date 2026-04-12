vim.filetype.add({
  pattern = {
    [".*.tex"] = "tex",
    [".*.bib"] = "tex",
    [".*.aux"] = "tex",
    ["dot%-(.+)"] = function(_, _, ext)
      return ext
    end,
  },
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
