local function show_plugins_in_float()
    -- 收集插件信息
    local plugins = {}
    local data_dir = vim.fn.stdpath('data')
    local patterns = {
        { path = data_dir .. '/site/pack/core/opt/*', type = 'opt' }
    }

    for _, pattern in ipairs(patterns) do
        for _, dir in ipairs(vim.fn.glob(pattern.path, true, true)) do
            if vim.fn.isdirectory(dir) == 1 then
                local name = vim.fn.fnamemodify(dir, ':t')

                -- 获取版本信息
                local version = 'unknown'
                local git_dir = dir .. '/.git'
                if vim.fn.isdirectory(git_dir) == 1 then
                    local handle = io.popen('cd "' ..
                        dir ..
                        '" && git describe --tags 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "unknown"')
                    if handle then
                        version = handle:read("*a"):gsub("%s+$", "")
                        handle:close()
                    end
                end

                if name and name ~= '' then
                    table.insert(plugins, {
                        name = name,
                        type = pattern.type,
                        version = version,
                        path = dir
                    })
                end
            end
        end
    end

    -- 按名称排序
    table.sort(plugins, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    -- 创建浮动窗口
    local width = 80
    local height = math.min(#plugins + 10, 30) -- 动态高度

    local buf = vim.api.nvim_create_buf(false, true)
    local ui = vim.api.nvim_list_uis()[1]

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((ui.width - width) / 2),
        row = math.floor((ui.height - height) / 2),
        style = 'minimal',
        border = 'rounded',
    })

    -- 设置窗口选项
    vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
    vim.api.nvim_win_set_option(win, 'wrap', false)

    -- 准备内容
    local lines = {
        '╔══════════════════════════════════════════════════════════════════════════════╗',
        '║                             IrisVim - Plugins Info                           ║',
        '╠══════════════════════════════════════════════════════════════════════════════╣',
        '║                                                                              ║',
        string.format('║  Total plugins: %-61d║', #plugins),
        '║                                                                              ║',
    }

    -- 添加标题行
    table.insert(lines, '║  ' .. string.format('%-30s %-10s %-30s', 'Plugin Name', 'Type', 'Version') .. '    ║')
    table.insert(lines, '║  ' .. string.rep('─', 74) .. '  ║')

    -- 添加插件信息
    for i, plugin in ipairs(plugins) do
        local line = string.format('%-30s %-10s %-30s',
            plugin.name:sub(1, 30),
            plugin.type:upper(),
            plugin.version:sub(1, 30))
        table.insert(lines, '║  ' .. line .. '    ║')
    end

    -- 添加底部边框
    for _ = #lines, height - 2 do
        table.insert(lines, '║' .. string.rep(' ', 78) .. '║')
    end

    table.insert(lines, '╚' .. string.rep('═', 78) .. '╝')

    -- 设置缓冲区内容
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- 设置缓冲区选项
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

    -- 添加键映射
    local function close_window()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
        callback = close_window,
        noremap = true,
        silent = true
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
        callback = close_window,
        noremap = true,
        silent = true
    })

    -- 设置高亮
    vim.api.nvim_buf_add_highlight(buf, -1, 'Title', 1, 4, 70)
    vim.api.nvim_buf_add_highlight(buf, -1, 'Number', 3, 17, 17 + #tostring(#plugins))

    -- 高亮标题行
    vim.api.nvim_buf_add_highlight(buf, -1, 'Type', 5, 4, 76)

    -- 自动关闭映射
    vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
        buffer = buf,
        callback = close_window,
        once = true
    })
end

vim.api.nvim_create_user_command('IrisvimPlugins', show_plugins_in_float,
    { desc = "show Irisvim plugins infomation in floating window" })



vim.api.nvim_create_user_command('RenameTabPage', function(input)
    local command_to_run = input.args -- 获取命令后的参数

    if command_to_run and command_to_run ~= "" then
        print("Executing: " .. command_to_run)
        vim.cmd('Tabby rename_tab' .. command_to_run)
    else
        -- 如果没有参数，提示用户输入
        local user_input = vim.fn.input("Rename tab: ")
        if user_input ~= "" then
            vim.cmd('Tabby rename_tab ' .. user_input)
        end
    end
end, { nargs = '?', desc = "rename the current tab" }) -- nargs='?' 表示参数可选
