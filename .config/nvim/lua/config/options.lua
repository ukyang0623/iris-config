vim.g.have_nerd_font = true -- 终端是否已配置nerd font字体
-- opt配置
local set = vim.opt
set.number = true -- 显示行号
set.relativenumber = true -- 显示相对行号
set.cursorline = false -- 高亮光标所在行
set.expandtab = true -- 使用空格代替 Tab
set.tabstop = 4 -- Tab 键宽度为 4
set.shiftwidth = 4 -- 缩进宽度为 4
set.wrap = false -- 不自动换行
set.scrolloff = 10 -- 上下保留 10 行作为缓冲
set.signcolumn = "yes" -- 永远显示 sign column（诊断标记）
set.winborder = "rounded" -- 窗口边框样式
set.ignorecase = true -- 搜索忽略大小写
set.smartcase = true -- 当包含大写字母时，搜索区分大小写
set.hlsearch = true -- 搜索匹配高亮
set.incsearch = true -- 增量搜索
set.foldmethod = "expr" -- 折叠方式使用表达式
set.foldexpr = "nvim_treesitter#foldexpr()" -- 使用 Treesitter 表达式折叠
set.foldlevel = 99 -- 打开文件时默认不折叠
set.mouse = "a" -- 鼠标模式
set.showmode = false -- 不再显示mode（在status line中已经显示）
set.breakindent = true -- 换行时自动缩进
set.undofile = true -- 保留文件撤销历史
set.updatetime = 500 -- 触发CursorHold的时间间隔（ms）
set.timeoutlen = 300 -- 按键映射组合的超时时间（ms）
set.splitright = true -- 设置vsplit的方向
set.splitbelow = true -- 设置split的方向
set.list = true -- 显示非法的非可见字符
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- 非法非可见字符显示样式
set.inccommand = 'split' -- 命令的更改会在preview中显示（nosplit在原位置显示）
set.confirm = true -- 文件未保存退出时给出保存操作提示而不仅是警告
-- 剪切板配置
vim.g.clipboard = "xclip"
vim.schedule(function()
    set.clipboard = "unnamedplus"
end)
-- session设置
set.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
-- set.laststatus = 0 -- 设置laststatus不显示
-- set.cmdheight = 0
-- tabline设置
set.showtabline = 2
