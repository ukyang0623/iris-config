local groups = {
    ui = vim.api.nvim_create_augroup('UIEnhancements', { clear = true }),
    lsp = vim.api.nvim_create_augroup('LspConfig', { clear = true }),
    formatting = vim.api.nvim_create_augroup('AutoFormatting', { clear = true }),
    keymaps = vim.api.nvim_create_augroup('DynamicKeymaps', { clear = true }),
    startup = vim.api.nvim_create_augroup('StartupActions', { clear = true }),
    highlight_yank = vim.api.nvim_create_augroup('HighlightYank', { clear = true }),
    lsp_highlight = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
}

-- 文件保存前自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "format file before saving",
    group = groups.formatting,
    pattern = "*",
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = 'Highlight when yanking (copying) text',
    group = groups.highlight_yank,
    callback = function()
        vim.hl.on_yank({ timeout = 500 })
    end,
})

-- 配置文件保存后自动重载
-- vim.api.nvim_create_autocmd('BufWritePost', {
--     pattern = vim.fn.stdpath('config') .. '/*.lua',
--    callback = function(args)
--         print('配置已更新:', args.file)
--         vim.cmd('source ' .. args.file) -- 重载配置
--    end
-- })
