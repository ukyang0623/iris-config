local keymap = vim.keymap.set
vim.g.mapleader = " " -- 设置 leader 键为空格
vim.g.maplocalleader = " "

-- 基本操作
keymap("i", "jk", "<Esc>", { noremap = true, desc = "back to normal mode" })
keymap({ "n", "v" }, "ds", "V", { noremap = true, desc = "change to visual mode with line" })
keymap({ "n", "v" }, "H", "^", { noremap = true, desc = "move to the home of the line" })
keymap({ "n", "v" }, "L", "$", { noremap = true, desc = "move to the end of the line" })
-- keymap({ "n", "v" }, "<C-a>", "ggVG", { noremap = true, desc = "select all region" })
keymap({ "n", "v", "i" }, "<C-z>", "<ESC>u", { noremap = true, desc = "undo" })
keymap("n", "<leader>nh", "<Cmd>nohlsearch<CR>", { noremap = true, desc = "clean search highlight" })
keymap("n", "<leader>rs", "<Cmd>restart<CR>", { noremap = true, desc = "restart nvim" })
keymap("n", "<A-Left>", "<C-o>", { noremap = true, desc = "back" })
keymap("n", "<A-Right>", "<C-i>", { noremap = true, desc = "forward" })
keymap("n", "q", "ddO", { noremap = true, desc = "reword form the home of the line" })
keymap("n", "<leader>q", vim.diagnostic.open_float, { noremap = true, desc = "Open diagnostic [Q]uickfix message" })
keymap("n", "<leader>ql", vim.diagnostic.setloclist, { noremap = true, desc = "Open diagnostic [Q]uickfix [L]ist" })
keymap("n", "<leader>pi", ":IrisvimPlugins<CR>", { noremap = true, desc = "Show [P]lugins [I]nfo" })
keymap("n", "<leader>da", ":Dashboard<CR>", { noremap = true, desc = "Show [Da]shboard" })
keymap("n", "s", "<Plug>(leap)", { noremap = true, desc = "jump to everywhere" })
keymap("n", "S", "<Plug>(leap-from-window)", { noremap = true, desc = "jump to every window" })
keymap({ "n", "i", "v" }, "<C-s>", "<ESC><Cmd>w<CR>", { noremap = true, desc = "save file" })
keymap("n", "<leader>ll", "30zl", { noremap = true, desc = "go right" })
keymap("n", "<leader>hh", "30zh", { noremap = true, desc = "go left" })
-- buffer操作
keymap("n", "bc", "<Cmd>bdelete %<CR>", { noremap = true, desc = "close this buffer" })
keymap("n", "bp", "<Cmd>BufferLinePickClose<CR>", { noremap = true, desc = "close pick buffer" })
keymap("n", "bo", "<Cmd>BufferLineCloseOthers<CR>",
    { noremap = true, desc = "close other buffers" })
-- window操作
keymap("n", "sv", "<Cmd>vs<CR><C-w>l", { noremap = true, desc = "vsplit" })
keymap("n", "sp", "<Cmd>sp<CR><C-w>j", { noremap = true, desc = "split" })
keymap({ "n", "i", "v" }, "<C-q>", "<Cmd>qa<CR>", { noremap = true, desc = "close neovim" })
keymap("n", "sc", "<C-w>c", { noremap = true, desc = "close window (not the last window)" })
keymap("n", "so", "<C-w>o", { noremap = true, desc = "close other windows" })
keymap({ "n", "v" }, "<A-h>", "<C-w>h", { noremap = true, desc = "Move focus to the left window" })
keymap({ "n", "v" }, "<A-j>", "<C-w>j", { noremap = true, desc = "Move focus to the lower window" })
keymap({ "n", "v" }, "<A-k>", "<C-w>k", { noremap = true, desc = "Move focus to the upper window" })
keymap({ "n", "v" }, "<A-l>", "<C-w>l", { noremap = true, desc = "Move focus to the right window" })
keymap("n", "<C-h>", "<C-w>H", { desc = "Move window to the left" })
keymap("n", "<C-l>", "<C-w>L", { desc = "Move window to the right" })
keymap("n", "<C-j>", "<C-w>J", { desc = "Move window to the lower" })
keymap("n", "<C-k>", "<C-w>K", { desc = "Move window to the upper" })
keymap("n", "<C-Up>", "<Cmd>resize +2<CR>", { noremap = true, desc = "Increase window height" })
keymap("n", "<C-Down>", "<Cmd>resize -2<CR>", { noremap = true, desc = "Decrease window height" })
keymap("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { noremap = true, desc = "Decrease window width" })
keymap("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { noremap = true, desc = "Increase window width" })
-- tab操作
keymap("n", "tn", "<Cmd>tabnew<CR>", { noremap = true, desc = "create new tab" })
keymap("n", "tc", "<Cmd>tabc<CR>", { noremap = true, desc = "close this tab" })
keymap("n", "to", "<Cmd>tabo<CR>", { noremap = true, desc = "close other tab" })
keymap("n", "tr", "<Cmd>RenameTabPage<CR>", { noremap = true, desc = "rename the tab" })
keymap("n", "tp", "<Cmd>Tabby pick_window<CR>", { noremap = true, desc = "pick tab" })
keymap("n", "tj", "<Cmd>Tabby jump_to_tab<CR>", { noremap = true, desc = "jump to tab" })
-- git操作
keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, desc = "open Lazy[G]it" })
-- session操作
keymap("n", "<leader>sw", "<cmd>AutoSession save<CR>", { noremap = true, desc = "save session" })
keymap("n", "<leader>ss", "<cmd>AutoSession search<CR>", { noremap = true, desc = "search session" })
keymap("n", "<leader>sd", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "delete session" })
keymap("n", "<leader>sr", "<cmd>AutoSession restore<CR>", { noremap = true, desc = "restore session" })
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
keymap("n", "<leader>e", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>",
    { noremap = true, desc = "open file explorer" })
keymap("n", "<leader>f", "<Cmd>Pick files<CR>", { noremap = true, desc = "open file picker" })
keymap("n", "<leader>h", "<Cmd>Pick help<CR>", { noremap = true, desc = "open help picker" })
keymap("n", "<leader>b", "<Cmd>Pick buffers<CR>", { noremap = true, desc = "open buffer picker" })
-- LSP 快捷键
keymap("n", "gd", vim.lsp.buf.definition, { noremap = true, desc = "[G]o to [d]efinition" })
keymap("n", "gD", vim.lsp.buf.declaration, { noremap = true, desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { noremap = true, desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { noremap = true, desc = "Find references" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, desc = "Rename symbol" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "LSP code action" })
