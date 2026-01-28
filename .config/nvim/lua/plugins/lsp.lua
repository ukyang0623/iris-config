vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim",  name = "lsp-mason.nvim" },     -- LSP 安装管理器
    { src = "https://github.com/neovim/nvim-lspconfig", name = "lsp-nvim-lspconfig" }, -- LSP 配置
})

require("mason").setup()
vim.lsp.enable({ "lua_ls", "clangd", "gopls" }) -- clangd放在after/ftplugin目录下好像有问题

vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("LuaFileType", { clear = true }),
    pattern = { "*.lua" },
    callback = function()
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT", path = vim.split(package.path, ";") }, -- Lua 运行时
                    diagnostics = { globals = { "vim" } },                                 -- 忽略全局变量 vim 的警告
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    format = { enable = true }, -- 启用格式化
                },
            },
        })

        vim.diagnostic.config({ virtual_text = true }) -- 行内文本提示
    end,
})
