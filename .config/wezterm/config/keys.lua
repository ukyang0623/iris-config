local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  -- 设置 Leader 键
  config.leader = { key = 'a', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }
  
  -- 快捷键配置
  config.keys = {
    -- 窗格管理
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
    
    -- 标签页管理
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'q', mods = 'LEADER', action = act.CloseCurrentTab { confirm = true } },
    
    -- 字体大小调整
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    
    -- 配置重载
    { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
    
    -- 全屏切换
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
  }
  
  -- 鼠标绑定
  config.mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom 'Clipboard',
    },
  }
end

return M