vim.pack.add({
  { src = "https://github.com/morhetz/gruvbox" }, -- gruvbox主题
  { src = "https://github.com/catppuccin/nvim" }, -- catppuccin主题
})

require("catppuccin").setup({
  transparent_background = true,
  term_colors = true,
  integrations = {
    aerial = true,
    diffview = true,
    mini = {
      enabled           = true,
      indentscope_color = "sky"
    }
  }
})
vim.cmd("colorscheme catppuccin")
-- vim.cmd.hi("statusline guibg=NONE")
-- vim.cmd.hi("Comment gui=ONE")
