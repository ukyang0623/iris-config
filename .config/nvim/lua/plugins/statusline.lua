vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim", name = "statusline-lualine" },
})

local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    yellow = '#fe8019',
    violet = '#d183e8',
    grey   = '#303030',
}

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("lualine").setup({
            options = {
                -- theme = 'auto',
                component_separators = '|',
                disabled_filetypes = { 'alpha', 'dashboard' },
                globalstatus = false,
                -- section_separators = { left = '', right = '' }
                -- section_separators = { left = '', right = '' },
                --                                  
                -- █ █
            },
            sections = {
                lualine_a = {},
                lualine_b = {
                },
                lualine_c = {
                    'diagnostics',
                    { 'filename', path = 1 },
                    'branch',
                    'diff',
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype', 'progress', 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = { { 'filename', path = 1 } },
                lualine_c = {},
                lualine_x = { 'filetype' },
                lualine_y = {},
                lualine_z = {}
            }
        })
    end
})

vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
