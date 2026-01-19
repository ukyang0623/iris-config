local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  -- SSH 域配置（远程服务器）
  config.ssh_domains = {
    {
      name = 'my-server',
      remote_address = 'your-server.com',
      username = 'user',
      -- identity_file = '~/.ssh/id_rsa',
    }
  }
  
  -- Unix 域配置（本地多路复用）
  config.unix_domains = {
    {
      name = 'local',
      -- 默认路径，通常不需要修改
    }
  }
  
  -- 工作区配置
  config.workspaces = {
    {
      name = 'dev',
      domains = { 'local' }
    },
    {
      name = 'remote', 
      domains = { 'my-server' }
    }
  }
  
  -- 域管理快捷键
  table.insert(config.keys, 
    { key = 'd', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|DOMAINS|WORKSPACES' } }
  )
end

return M