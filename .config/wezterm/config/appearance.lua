local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)
	-- 字体
	config.font = wezterm.font_with_fallback({
		"JetBrainsMonoNL Nerd Font",
		"Microsoft YaHei"	-- windows下中文字体兜底
	})
	config.font_size = 14.0
	config.line_height = 1.0

  	-- 主题（Catppuccin Mocha/Dracula/Gruvbox Dark/Tokyo Night/Solarized）
  	config.color_scheme = M.get_time_based_scheme()

	-- 窗口
	config.window_background_opacity = 0.8		-- 窗口透明度
  	-- config.text_background_opacity = 0.1
	-- config.win32_system_backdrop = 'Acrylic'		-- windows 亚克力效果
	config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
	config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
	-- 初始窗口大小
	config.initial_cols = 120
	config.initial_rows = 35

  	-- 标签栏样式
	config.enable_tab_bar = true		-- 是否启用标签栏
	config.use_fancy_tab_bar = true	-- 是否使用新式标签栏样式
	config.hide_tab_bar_if_only_one_tab = true		-- 仅有1个标签时深仇自动隐藏标签栏
	config.tab_bar_at_bottom = false  	-- 是否将标签栏放在底部
  	config.show_tab_index_in_tab_bar = true

	-- 标题栏颜色
	config.window_frame = {
    		border_left_width    	= 0,
    		border_right_width   	= 0,
    		border_bottom_height 	= 0,
    		border_top_height    	= 0,
    		active_titlebar_bg  		= '#282828',   	-- ← 不透明深色
    		button_fg            		= '#fabd2f',   	-- 图标颜色
   	 	button_bg            		= '#282828',   	-- 图标背景（同样不透明）
	}
  
  	-- 自定义状态栏
  	wezterm.on('update-status', function(window, pane)
    		local battery = require('wezterm.battery')
    		local date = wezterm.strftime('%Y-%m-%d %H:%M:%S')
    
    		window:set_right_status(wezterm.format({
      			{ Attribute = { Intensity = 'Bold' } },
      			{ Foreground = { Color = '#a6adc8' } },
      			{ Text = '🔋 ' .. (battery.info() and math.floor(battery.info().state_of_charge * 100) .. '%' or 'N/A') },
      			{ Text = ' | ' },
      			{ Text = date },
    		}))
  	end)

	-- 自动居中
	wezterm.on('gui-startup', function(cmd)
    		local screen = wezterm.gui.screens().main
    		local w, h = 1000, 600
    		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    		window:gui_window():set_position(screen.width / 2 - w / 2, screen.height / 2 - h / 2)
    		window:gui_window():set_inner_size(w, h)
	end)
end

-- 根据时间自动切换主题
function M.get_time_based_scheme()
  local hour = tonumber(wezterm.strftime('%H'))
  if hour >= 18 or hour < 6 then
    -- return 'Catppuccin Mocha'  	-- 夜间深色主题
	return 'Solarized Dark'
  else
    -- return 'Catppuccin Latte'  	-- 日间浅色主题
	return 'Solarized Light'
  end
end

return M