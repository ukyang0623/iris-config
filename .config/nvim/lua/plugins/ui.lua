vim.pack.add({
    { src = "https://github.com/MunifTanjim/nui.nvim", name = "ui-nui" },
    { src = "https://github.com/folke/noice.nvim",     name = "ui-noice" },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("noice").setup({
        })
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("noice").setup({
        })
    end
})
