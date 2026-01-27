vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-dap",           name = "debug-nvim-dap" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text", name = "debug-nvim-dap-virtual-text" },
    -- { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/rcarriga/nvim-dap-ui",            name = "debug-nvim-dap-ui" },
    { src = "https://github.com/mfussenegger/nvim-dap-python",    name = "debug-nvim-dap-python" },
})

-- vim.api.nvim_create_autocmd("FileType", {
--  group = vim.api.nvim_create_augroup("SetupDebugging", { clear = true }),
--  pattern = { "python", "cpp", "cuda", "c", "go", "java" },
--  once = true,
--  callback = function()
--    require("config.debugging")
--  end,
--})
