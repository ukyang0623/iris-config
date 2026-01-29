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

-- 复制时自动高亮一段时间
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = 'Highlight when yanking (copying) text',
    group = groups.highlight_yank,
    callback = function()
        vim.hl.on_yank({ timeout = 500 })
    end,
})

-- 文件资源管理器打开时自动透明+画双线框
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.wo[win_id].winblend = 10
        local config = vim.api.nvim_win_get_config(win_id)
        config.border, config.title_pos = 'double', 'right'
        vim.api.nvim_win_set_config(win_id, config)
    end,
})

-- 文件资源管理器打开时自动设置位置+高度
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(args)
        local config = vim.api.nvim_win_get_config(args.data.win_id)

        -- Ensure fixed height
        config.height = 20
        config.row = 10

        -- Ensure no title padding
        local n = #config.title
        config.title[1][1] = config.title[1][1]:gsub('^ ', '')
        config.title[n][1] = config.title[n][1]:gsub(' $', '')

        vim.api.nvim_win_set_config(args.data.win_id, config)
    end,
})

-- 文件资源管理器打开时自动支持window/tab相关操作
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local map_split = function(buf_id, lhs, direction)
            local rhs = function()
                -- Make new window and set it as target
                local cur_target = MiniFiles.get_explorer_state().target_window
                local new_target = vim.api.nvim_win_call(cur_target, function()
                    vim.cmd(direction .. ' split')
                    return vim.api.nvim_get_current_win()
                end)

                -- MiniFiles.set_target_window(new_target)

                -- This intentionally doesn't act on file under cursor in favor of
                -- explicit "go in" action (`l` / `L`). To immediately open file,
                -- add appropriate `MiniFiles.go_in()` call instead of this comment.
                MiniFiles.go_in()
                -- MiniFiles.set_target_window(cur_target)
            end

            -- Adding `desc` will result into `show_help` entries
            local desc = 'Split ' .. direction
            vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
        end
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        map_split(buf_id, '<C-s>', 'belowright horizontal')
        map_split(buf_id, '<C-v>', 'belowright vertical')
        map_split(buf_id, '<C-t>', 'tab')
    end,
})

-- 文件资源管理器打开时自动mark常用目录
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
        local set_mark = function(id, path, desc)
            MiniFiles.set_bookmark(id, path, { desc = desc })
        end
        set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
        set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
        set_mark('~', '~', 'Home directory')
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
