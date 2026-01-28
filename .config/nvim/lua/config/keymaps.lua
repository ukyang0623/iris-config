local keymap = vim.keymap.set
vim.g.mapleader = " " -- 设置 leader 键为空格
vim.g.maplocalleader = " "

-- 基本操作
keymap("i", "jk", "<Esc>", { noremap = true, desc = "back to normal mode" })
keymap({ "n", "v" }, "ds", "V", { noremap = true, desc = "change to visual mode with line" })
keymap({ "n", "v" }, "H", "^", { noremap = true, desc = "move to the home of the line" })
keymap({ "n", "v" }, "L", "$", { noremap = true, desc = "move to the end of the line" })
keymap({ "n", "v" }, "<C-a>", "ggVG", { noremap = true, desc = "select all region" })
keymap({ "n", "v", "i" }, "<C-z>", "<ESC>u", { noremap = true, desc = "undo" })
keymap("n", "<leader>nh", ":nohlsearch<CR>", { noremap = true, desc = "clean search highlight" })
keymap("n", "<leader>rs", ":restart<CR>", { noremap = true, desc = "restart nvim" })
keymap("n", "<A-Left>", "<C-o>", { noremap = true, desc = "back" })
keymap("n", "<A-Right>", "<C-i>", { noremap = true, desc = "forward" })
keymap("n", "q", "ddO", { noremap = true, desc = "reword form the home of the line" })
keymap("n", "<leader>q", vim.diagnostic.open_float, { noremap = true, desc = "Open diagnostic [Q]uickfix message" })
keymap("n", "<leader>ql", vim.diagnostic.setloclist, { noremap = true, desc = "Open diagnostic [Q]uickfix [L]ist" })
keymap("n", "<leader>pi", ":IrisvimPlugins<CR>", { noremap = true, desc = "Show [P]lugins [I]nfo" })
keymap("n", "<leader>da", ":Dashboard<CR>", { noremap = true, desc = "Show [Da]shboard" })
keymap("n", "s", "<Plug>(leap)", { noremap = true, desc = "jump to everywhere" })
keymap("n", "S", "<Plug>(leap-from-window)", { noremap = true, desc = "jump to every window" })
-- git操作
keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, desc = "open Lazy[G]it" })
-- 窗口操作
keymap("n", "sv", ":vs<CR><C-w>l", { noremap = true, desc = "vsplit" })
keymap("n", "sp", ":sp<CR><C-w>j", { noremap = true, desc = "split" })
keymap({ "n", "i", "v" }, "<C-q>", "<C-w>q", { noremap = true, desc = "close window" })
keymap({ "n", "i", "v" }, "<C-s>", "<ESC>:w<CR>", { noremap = true, desc = "save file" })
keymap("n", "sc", "<C-w>c", { noremap = true, desc = "close window (not the last window)" })
keymap("n", "so", "<C-w>o", { noremap = true, desc = "close other windows" })
-- 窗口间移动
keymap({ "n", "v" }, "<A-h>", "<C-w>h", { noremap = true, desc = "Move focus to the left window" })
keymap({ "n", "v" }, "<A-j>", "<C-w>j", { noremap = true, desc = "Move focus to the lower window" })
keymap({ "n", "v" }, "<A-k>", "<C-w>k", { noremap = true, desc = "Move focus to the upper window" })
keymap({ "n", "v" }, "<A-l>", "<C-w>l", { noremap = true, desc = "Move focus to the right window" })
keymap("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
keymap("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
keymap("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
keymap("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
-- 调整窗口大小
keymap("n", "<C-Up>", ":resize +2<CR>", { noremap = true, desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { noremap = true, desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Increase window width" })
-- 格式化
keymap("n", "<C-A-l>",
    function()
        vim.lsp.buf.format()
    end,
    { desc = "format" }
)
-- 快速跳转诊断
keymap("n", "<Shift-F2>",
    function()
        vim.diagnostic.jump({ wrap = true, count = -1 })
    end,
    { noremap = true, desc = "prev diagnostic" }
)
keymap("n", "<F2>",
    function()
        vim.diagnostic.jump({ wrap = true, count = 1 })
    end,
    { noremap = true, desc = "next diagnostic" }
)

-- 系统剪贴板
-- keymap({ "n", "v" }, "<leader>c", '"+y', { noremap = true, desc = "copy to system clipboard" })
-- keymap({ "n", "v" }, "<leader>x", '"+d', { noremap = true, desc = "cut to system clipboard" })
-- keymap({ "n", "v" }, "<leader>p", '"+p', { noremap = true, desc = "paste to system clipboard" })
-- 撤销
-- 行移动
-- keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, desc = "Move line down" })
-- keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, desc = "Move line up" })
-- keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move selection down" })
-- keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move selection up" })
-- 文件/插件快捷键
keymap("n", "<leader>e", ":lua MiniFiles.open(MiniFiles.get_latest_path())<CR>",
    { noremap = true, desc = "open file explorer" })
keymap("n", "<leader>f", ":Pick files<CR>", { noremap = true, desc = "open file picker" })
keymap("n", "<leader>h", ":Pick help<CR>", { noremap = true, desc = "open help picker" })
keymap("n", "<leader>b", ":Pick buffers<CR>", { noremap = true, desc = "open buffer picker" })
-- LSP 快捷键
keymap("n", "gd", vim.lsp.buf.definition, { noremap = true, desc = "[G]o to [d]efinition" })
keymap("n", "gD", vim.lsp.buf.declaration, { noremap = true, desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { noremap = true, desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { noremap = true, desc = "Find references" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, desc = "Rename symbol" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "LSP code action" })
