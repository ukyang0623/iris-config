-- opt配置
local set = vim.opt
set.number = true                           -- 显示行号
set.relativenumber = true                   -- 显示相对行号
set.cursorline = true                       -- 高亮光标所在行
set.expandtab = true                        -- 使用空格代替 Tab
set.tabstop = 2                             -- Tab 键宽度为 2
set.shiftwidth = 2                          -- 缩进宽度为 2
set.wrap = false                            -- 不自动换行
set.scrolloff = 5                           -- 上下保留 5 行作为缓冲
set.signcolumn = "yes"                      -- 永远显示 sign column（诊断标记）
set.winborder = "rounded"                   -- 窗口边框样式
set.ignorecase = true                       -- 搜索忽略大小写
set.smartcase = true                        -- 当包含大写字母时，搜索区分大小写
set.hlsearch = false                        -- 搜索匹配不高亮
set.incsearch = true                        -- 增量搜索
set.foldmethod = "expr"                     -- 折叠方式使用表达式
set.foldexpr = "nvim_treesitter#foldexpr()" -- 使用 Treesitter 表达式折叠
set.foldlevel = 99                          -- 打开文件时默认不折叠

vim.g.mapleader = " "                       -- 设置 leader 键为空格
