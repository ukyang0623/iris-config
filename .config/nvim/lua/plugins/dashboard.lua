--                   
vim.pack.add({
    { src = "https://github.com/nvimdev/dashboard-nvim", name = "dashboard-dashboard-nvim" },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- 获取Irisvim启动时间
        local function get_startup_time()
            if vim.g.irisvim_start_time then
                local now = vim.loop.hrtime()
                local elapsed_ns = now - vim.g.irisvim_start_time
                local elapsed_us = elapsed_ns / 1000    -- 纳秒转微秒
                local elapsed_ms = elapsed_ns / 1000000 -- 纳秒转毫秒

                if elapsed_us < 1000 then
                    return string.format("%.2fµs", elapsed_us)
                elseif elapsed_ms < 1000 then
                    return string.format("%.2fms", elapsed_ms)
                else
                    return string.format("%.2fs", elapsed_ms / 1000)
                end
            end

            return "N/A"
        end

        -- 生成 footer
        local function generate_footer()
            local startup_ms = get_startup_time()
            return {
                '',
                '🚀 Startup: ' .. startup_ms .. ' | ' ..
                '💻 ' .. vim.fn.hostname() .. ' | ' ..
                'Neovim V' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch,
                '',
            }
        end

        require("dashboard").setup({
            theme = 'doom',
            config = {
                header = {
                    '',
                    ' ██╗██████╗ ██╗███████╗██╗   ██╗██╗███╗   ███╗',
                    ' ██║██╔══██╗██║██╔════╝██║   ██║██║████╗ ████║',
                    ' ██║██████╔╝██║███████╗██║   ██║██║██╔████╔██║',
                    ' ██║██╔══██╗██║╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║',
                    ' ██║██║  ██║██║███████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
                    ' ╚═╝╚═╝  ╚═╝╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
                    '',
                },
                center = {
                    {
                        icon = ' ',
                        desc = 'find file',
                        key = 'f',
                        action = 'Pick files'
                    },
                    {
                        icon = ' ',
                        desc = 'open file explorer',
                        key = 'o',
                        action = 'lua MiniFiles.open(MiniFiles.get_latest_path())'
                    },
                    --                    {
                    --                        icon = ' ',
                    --                        desc = 'change theme',
                    --                        key = 'c',
                    --                        action = ''
                    --                    },
                    {
                        icon = ' ',
                        desc = 'show plugins info',
                        key = 's',
                        action = 'IrisvimPlugins'
                    }
                },
                footer = generate_footer(),
                vertical_center = true, -- 是否垂直居中
            }
        })
    end
})
