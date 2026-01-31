vim.g.irisvim_start_time = vim.loop.hrtime()

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.usercmds")

-- vim.pack
-- nvim-treesitter: 语法高亮和折叠
-- mason.nvim: LSP 安装管理器
-- nvim-lspconfig: LSP 配置
-- blink.cmp: 自动补全
-- mini.pick: file/buffer选择器
-- mini.files: 文件浏览器
--
--
-- open nvim -> VimEnter（未展示dashboard） -> UIEnter（展示dashboard）
-- open file -> BufReadPre -> BufRead/BufReadPost -> BufWinEnter -> FileType -> BufEnter
-- switch mode -> normal -> InsertEnter -> insert -> InsertLeave -> normal
require("plugins.file") -- loaded after VimEnter
require("plugins.lsp")
require("plugins.boot")
require("plugins.completion") -- loaded at events
require("plugins.theme")
require("plugins.debugging")  -- loaded at filetypes

-- open file -> load plugin -> enable lsp
require("plugins.markdown")   -- loaded at filetype

require("plugins.git")        -- loaded after VimEnter
-- require("plugins.tips")   -- loaded after VimEnter
require("plugins.jump")       -- loaded after VimEnter
require("plugins.tabline")    -- loaded after VimEnter
require("plugins.session")    -- loaded after VimEnter
require("plugins.statusline") -- loaded after VimEnter
require("plugins.ui")         -- loaded after VimEnter
require("plugins.dashboard")
