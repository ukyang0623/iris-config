-- IrisVim 配置
-- 插件管理：vim.pack
-- 默认主题：gruvbox
-- LSP：mason.nvim + nvim-lspconfig
-- 快速文件浏览：mini.pack, mini.files
-- 语法高亮和折叠：nvim-treesitter
-- 自动补全：blink.cmp(懒加载)
----------------------
-- 通用 Neovim 设置 --
----------------------
require("config.options")
require("config.keymaps")

----------------------
-- 自动命令 --
----------------------
-- 保存前自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end,
  pattern = "*",
})

-- 复制高亮提示
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight copying text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

----------------------
-- 启动加载的插件 --
----------------------
vim.pack.add({
  -- { src = "https://github.com/morhetz/gruvbox" }, -- 主题
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- 语法高亮和折叠
})

-- vim.cmd("colorscheme gruvbox")

----------------------
-- 补全 --
----------------------
-- blink.cmp 安装补全配置以及触发加载
vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
}, {
  load = function(plug_data)
    vim.api.nvim_create_autocmd("InsertEnter", {
      once = true,
      callback = function()
        vim.cmd.packadd(plug_data.spec.name)
        -- 加载 plugin 文件
        require("blink.cmp").setup({
          keymap = { preset = "super-tab" },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
          },
        })
      end,
    })
  end,
})

----------------------
-- 功能插件配置 --
----------------------
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.pick" },  -- 文件/缓冲区选择器
  { src = "https://github.com/nvim-mini/mini.files" }, -- 文件浏览器
}, { load = false })
-- 插件延迟加载（在读取文件或创建新文件时加载）
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- mini.pick 配置
    require("mini.pick").setup()
    -- mini.files 文件浏览器配置
    require("mini.files").setup({
      windows = {
        preview = true, -- 打开预览窗口
      },
    })
  end,
})

----------------------
-- LSP 配置 --
----------------------
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },  -- LSP 安装管理器
  { src = "https://github.com/neovim/nvim-lspconfig" }, -- LSP 配置
}, {
  load = function(plug_data)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "c", "cpp" },
      callback = function()
        vim.cmd.packadd(plug_data.spec.name)
        require("mason").setup()
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
  end,
})
-- 启用 LSP
vim.lsp.enable({ "lua_ls", "pyright", "clangd" })
