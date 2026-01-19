-- 引入wezterm API，这是所有配置的基础
local wezterm = require 'wezterm'
-- 创建配置构建器
local config = wezterm.config_builder()
local act = wezterm.action

-- 启用配置自动重载
config.automatically_reload_config = true

local modules = {
  	'config.appearance',
  	'config.keys', 
  	-- 'config.domains',
  	'config.performance'
}

for _, module in ipairs(modules) do
  	local ok, mod = pcall(require, module)
  	if ok then
    		if type(mod) == 'function' then
      			mod(config)
    		elseif mod.apply_to_config then
      			mod.apply_to_config(config)
    		end
  	else
    		wezterm.log_error('Failed to load module: ' .. module .. ' - ' .. mod)
  	end
end

-- 启动菜单与跨平台适配
-- 根据操作系统进行特定配置
if wezterm.target_triple:find("windows") then
  -- Windows 配置
  config.default_prog = { "powershell.exe" }  -- 默认使用 PowerShell
  config.launch_menu = {
    { label = "PowerShell", args = { "powershell.exe" } },
    { label = "Command Prompt", args = { "cmd.exe" } },
    { label = "WSL Ubuntu", args = { "wsl.exe", "-d", "Ubuntu" } },
  }
  -- 彩色提示符
  config.set_environment_variables = {
    PROMPT = '$E[1;32m$P$E[0m$E[1;30m$_$E[1;33m→ $E[0m',
  }
elseif wezterm.target_triple:find("apple") then
  -- macOS 配置
  config.launch_menu = {
    { label = "Bash", args = { "/bin/bash", "-l" } },
    { label = "Zsh", args = { "/bin/zsh", "-l" } },
  }
  config.macos_window_background_blur = 20	-- macOS 窗口毛玻璃效果
else
  -- Linux 配置
  config.enable_wayland = true
end


-- local config = {
-- 	show_new_tab_button_in_tab_bar = false,	
-- 	adjust_window_size_when_changing_font_size = false,
-- }

return config