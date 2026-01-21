local keymap = vim.keymap.set

keymap("i", "jk", "<Esc>", { noremap = true, desc = "back to normal mode" })

-- 格式化
keymap("n", "<leader>lf", function()
  vim.lsp.buf.format()
end, { desc = "format" })

-- 系统剪贴板
keymap({ "n", "v" }, "<leader>c", '"+y', { noremap = true, desc = "copy to system clipboard" })
keymap({ "n", "v" }, "<leader>x", '"+d', { noremap = true, desc = "cut to system clipboard" })
keymap({ "n", "v" }, "<leader>p", '"+p', { noremap = true, desc = "paste to system clipboard" })
-- 撤销
keymap({ "n", "v", "i" }, "<C-z>", "<ESC>u<CR>", { noremap = true, desc = "undo" })
-- 窗口切换
keymap("n", "<leader>ww", "<C-w>w", { noremap = true, desc = "focus windows" })
-- 行移动
keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move selection up" })
-- 调整窗口大小
keymap("n", "<C-Up>", ":resize +2<CR>", { noremap = true, desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { noremap = true, desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Increase window width" })
-- 文件/插件快捷键
keymap({ "n", "i", "v" }, "<C-s>", "<ESC>:write<CR>", { noremap = true, desc = "save file" })
keymap("n", "<leader>e", ":lua MiniFiles.open()<CR>", { noremap = true, desc = "open file explorer" })
keymap("n", "<leader>f", ":Pick files<CR>", { noremap = true, desc = "open file picker" })
keymap("n", "<leader>h", ":Pick help<CR>", { noremap = true, desc = "open help picker" })
keymap("n", "<leader>b", ":Pick buffers<CR>", { noremap = true, desc = "open buffer picker" })
keymap("n", "<leader>dd", vim.diagnostic.open_float, { noremap = true, desc = "diagnostic messages" })
-- LSP 快捷键
keymap("n", "gd", vim.lsp.buf.definition, { noremap = true, desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { noremap = true, desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { noremap = true, desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { noremap = true, desc = "Find references" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, desc = "Rename symbol" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "LSP code action" })
-- 快速跳转诊断
keymap("n", "[d", function()
  vim.diagnostic.jump({ wrap = true, count = -1 })
end, { noremap = true, desc = "prev diagnostic" })
keymap("n", "]d", function()
  vim.diagnostic.jump({ wrap = true, count = 1 })
end, { noremap = true, desc = "next diagnostic" })
