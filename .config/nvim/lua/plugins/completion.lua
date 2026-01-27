vim.pack.add({
    { src = "https://github.com/archie-judd/blink-cmp-words",  name = "completion-blink-cmp-words" },
    { src = "https://github.com/saghen/blink.cmp",             name = "completion-blink-cmp",      version = vim.version.range("1.*") },
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    group = vim.api.nvim_create_augroup("SetupCompletion", { clear = true }),
    once = true,
    callback = function()
        require("blink.cmp").setup({
            keymap = { preset = "super-tab" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        })
    end,
})
