vim.pack.add({
    { src = "https://github.com/nanozuki/tabby.nvim", name = "tabline-tabby" },
    { src = "https://github.com/tiagovla/scope.nvim", name = "tabline-scope.nvim" },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("tabby").setup({
        })
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("scope").setup({
        })
    end
})
