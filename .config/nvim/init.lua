require("config.options")
require("config.keymaps")
require("config.autocmds")

-- vim.pack
-- nvim-treesitter: 语法高亮和折叠
-- mason.nvim: LSP 安装管理器
-- nvim-lspconfig: LSP 配置
-- blink.cmp: 自动补全
-- mini.pick: file/buffer选择器
-- mini.files: 文件浏览器
--
require("plugins.boot")
require("plugins.lsp")
require("plugins.completion") -- loaded at events
require("plugins.file")
require("plugins.theme")
require("plugins.debugging") -- loaded at filetypes

-- open file -> load plugin -> enable lsp
require("plugins.markdown") -- loaded at filetype
