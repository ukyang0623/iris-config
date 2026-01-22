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
