vim.pack.add({
    --    { src = "https://github.com/morhetz/gruvbox",             name = "theme-gruvbox" },    -- gruvbox主题
    --    { src = "https://github.com/catppuccin/nvim",             name = "theme-catppuccin" }, -- catppuccin主题
    { src = "https://github.com/EdenEast/nightfox.nvim", name = "theme-nightfox" },      -- nightfox主题
    --    { src = "https://github.com/rose-pine/neovim",            name = "theme-rose-pine" },  -- rose-pine主题
    --    { src = "https://github.com/folke/tokyonight.nvim",       name = "theme-tokyonight" }, -- tokyonight主题
    --    { src = "https://github.com/rebelot/kanagawa.nvim",       name = "theme-kanagawa" },   -- kanagawa主题
    --    { src = "https://github.com/projekt0n/github-nvim-theme", name = "theme-github" },     -- github主题
})

require("nightfox").setup({})
vim.cmd("colorscheme carbonfox")
-- vim.cmd.hi("statusline guibg=NONE")
-- vim.cmd.hi("Comment gui=ONE")
