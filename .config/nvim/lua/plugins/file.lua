vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.icons" }, -- 文件/文件夹图标
    { src = "https://github.com/nvim-mini/mini.pick" },  -- 文件/缓冲区选择器
    { src = "https://github.com/nvim-mini/mini.files" }, -- 文件浏览器
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("mini.icons").setup()
        local win_config = function()
            local height = math.floor(0.3 * vim.o.lines)
            local width = math.floor(0.3 * vim.o.columns)
            return {
                anchor = 'NW',
                height = height,
                width = width,
                row = math.floor(0.5 * (vim.o.lines - height)),
                col = math.floor(0.5 * (vim.o.columns - width)),
                border = "double",
            }
        end
        require("mini.pick").setup({
            window = {
                config = win_config
            }
        })
        require("mini.files").setup({
            -- Customization of explorer windows
            windows = {
                -- Maximum number of windows to show side by side
                max_number = 4,
                -- Whether to show preview of file/directory under cursor
                preview = true,
                -- Width of focused window
                width_focus = 30,
                -- Width of non-focused window
                width_nofocus = 30,
                -- Width of preview window
                width_preview = 80,
            },
        })
    end
})
