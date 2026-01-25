vim.pack.add({
    { src = "https://github.com/nvimdev/dashboard-nvim" },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("dashboard").setup({
            theme = 'doom',
            config = {
                center = {
                    {
                        icon = ' ',
                        desc = 'find file',
                        key = 'f',
                        action = 'Pick files'
                    },
                    {
                        icon = ' ',
                        desc = 'open file tree',
                        key = 'o',
                        action = 'lua MiniFiles.open(MiniFiles.get_latest_path())'
                    }
                },
                vertical_center = true, -- 是否垂直居中
            }
        })
    end
})
