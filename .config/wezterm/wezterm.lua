-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux


local default_width = 160
local default_height = 50
-- local position = '950,450'
local resolution = '2560x1440'

-- 常见分辨率及其居中位置
local resolutions = {
    ['1920x1080'] = '460,240',  -- (1920-1000)/2, (1080-600)/2
    ['2560x1440'] = '780,420',  -- (2560-1000)/2, (1440-600)/2
    ['3840x2160'] = '1420,780', -- (3840-1000)/2, (2160-600)/2
    ['1366x768']  = '183,84',   -- (1366-1000)/2, (768-600)/2
    ['1600x900']  = '300,150',  -- (1600-1000)/2, (900-600)/2
    ['1280x720']  = '140,60',
    ['2560x1600'] = '780,500',
    ['3440x1440'] = '1220,420',
}

local position = '0,0'

--==Workspaces==

wezterm.on('mux-startup', function(cmd)
    -- allow `wezterm start -- something` to affect what we spawn
    -- in our initial window
    --local args = {}
    --if cmd then
    --    args = cmd.args
    --end
    --
    -- A workspace for interacting with a local machine that
    -- runs some docker containers for home automation
    local tab, pane, window = mux.spawn_window {
        --workspace = 'main',
        width = default_width,
        height = default_height,
        position = {
            x = 100,
            y = 0,
            origin = "MainScreen",
        }
    }

    --you can also set the positions after spawn.
    --https://github.com/wezterm/wezterm/issues/3299
    --window:gui_window():set_position(10, 0)
    --window:gui_window():set_inner_size(default_width, default_height)

    -- We want to startup in the coding workspace
    --mux.set_active_workspace 'coding'

    return {
        unix_domains = {
            { name = 'unix' },
        },
    }
end)

-- 自动居中
wezterm.on('gui-startup', function(cmd)
    local screen = wezterm.gui.screens().main
    local w, h = 1000, 600
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():set_position(screen.width / 2 - w / 2, screen.height / 2 - h / 2)
    window:gui_window():set_inner_size(w, h)
end)

--wezterm.on('gui-attached', function(domain)
--    -- maximize all displayed windows on startup
--    local workspace = mux.get_active_workspace()
--    for _, window in ipairs(mux.all_windows()) do
--        if window:get_workspace() == workspace then
--            --window:gui_window():maximize()
--        end
--    end
--end)

-- === config == --
local config = {
    -- default_gui_startup_args = { 'connect', 'unix', '--position', position },
    -- default_gui_startup_args = { 'wsl.exe', '-d', 'test', '-u', 'root' },
    -- window_background_image = 'C:\\Users\\ukyan\\.config\\wezterm\\wallpaper\\15694012.jpg',
    window_background_image_hsb = nil,
    window_frame = {
        active_titlebar_bg = "#1a1b26",
        inactive_titlebar_bg = "#1a1b26",
    },

    status_update_interval = 1000,
    -- front_end = "OpenGL",
    max_fps = 120,
    webgpu_power_preference = "HighPerformance",
    -- cursor_style
    default_cursor_style = 'SteadyBlock',
    -- === 字体设置 ===
    -- 推荐使用 Nerd Font 字体以支持图标
    font = wezterm.font_with_fallback {
        { family = 'Lilex Nerd Font Propo', weight = 'Regular' },
        { family = 'Hack Nerd Font',        weight = 'Bold' },
        { family = 'LXGW WenKai',           stretch = 'Expanded', weight = 'Regular', italic = false, },
    },
    font_size = 15.0,
    foreground_text_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.2,
    },
    -- === 颜色主题 ===
    -- 可以从 wezterm.colors 模块导入主题，或手动定义
    -- 参考：https://wezterm.org/docs/colors.html
    -- color_scheme = 'Dracula (Official)', -- 内置主题
    --color_scheme = 'Catppuccin Mocha', -- 内置主题
    --color_scheme = 'tokyonight', -- 内置主题
    color_scheme = 'carbonfox', -- 内置主题
    -- === tab 设置 ===
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    tab_bar_at_bottom = true,
    tab_max_width = 50,
    --tab_bar_style = {
    --    window_maximize = wezterm.format {
    --        { Foreground = { Color = '#7dbefe' } },
    --        { Text = 'sdfsdf' } },
    --window_close = wezterm.format { { Text = '󰖯 ' } },
    --},
    -- === 窗口设置 ===
    window_background_opacity = 1.0,   -- 背景透明度
    -- win32_system_backdrop = 'Acrylic',
    macos_window_background_blur = 25, -- 玻璃模糊效果
    text_background_opacity = 1.0,     -- 文本背景不透明
    initial_cols = default_width,
    initial_rows = default_height,
    native_macos_fullscreen_mode = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    adjust_window_size_when_changing_font_size = false,
    window_close_confirmation = 'NeverPrompt',
    -- TODO：待确认
    -- window_content_alignment = {
    --     horizontal = 'Left',
    --     vertical = 'Bottom',
    --},
    --window_decorations = 'TITLE | RESIZE | MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR', -- 'NONE', 'RESIZE', 'INTEGRATED_BUTTONS', 'TITLE'
    window_decorations = 'INTEGRATED_BUTTONS|RESIZE', -- 'NONE', 'RESIZE', 'INTEGRATED_BUTTONS', 'TITLE'
    -- === 键盘快捷键 ===
    quick_select_patterns = {
        -- match things that look like sha1 hashes
        -- (this is actually one of the default patterns)
        --'[0-9a-f]{7,40}',
        --'^[\\w \\/\\_\\-\\.\\[\\]\\{\\}\\p{Han}]*+$',
        --'(?<=:\\d\\d\\s).*$',
        --'[\'\"].*[\'\"]',
        --'(?<=\\s).*?(?=\\s)',
    },
    -- debug_key_events = true,
    -- enable_kitty_keyboard = true,
    -- enable_csi_u_key_encoding = true,
    -- allow_win32_input_mode = true
}

if wezterm.target_triple:find("windows") then
    -- Windows 配置
    config.default_prog = { "wsl.exe", "-u", "root", "--cd", "/mnt/c/Users/ukyan/.config/wezterm/" } -- 默认使用 wsl
    config.launch_menu = {
        {
            label = "Ubuntu-24.04-dev",
            args = { "wsl.exe", "-d", "test", "-u", "root", "--cd", "/mnt/c/Users/ukyan/.config/wezterm/" }
        },
        { label = "Powershell", args = { "powershell.exe" } },
    }
    -- 彩色提示符
    config.set_environment_variables = {
        PROMPT = '$E[1;32m$P$E[0m$E[1;30m$_$E[1;33m→ $E[0m',
    }
elseif wezterm.target_triple:find("apple") then
    -- macOS 配置
    config.launch_menu = {
        { label = "Bash", args = { "/bin/bash", "-l" } },
        { label = "Zsh",  args = { "/bin/zsh", "-l" } },
    }
    config.macos_window_background_blur = 20 -- macOS 窗口毛玻璃效果
else
    -- Linux 配置
    config.enable_wayland = true
end

-- === 键盘快捷键 ===
-- SUPER, CMD, WIN - these are all equivalent: on macOS the Command key, on Windows the Windows key, on Linux this can also be the Super or Hyper key. Left and right are equivalent.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 10000 }

config.keys = {
    -- Prompt for a name to use for a new workspace and switch to it.
    {
        key = 'W',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },
    {
        key = ' ',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'move_pane',
            timeout_milliseconds = 600,
            one_shot = false,
        }
    },
    -- {
    --  key = 'r',
    -- mods = 'LEADER',
    --action = act.ActivateKeyTable {
    --   name = 'resize_pane',
    --  timeout_milliseconds = 1000,
    -- one_shot = false,
    --}
    --},
    {
        key = 'r',
        mods = 'LEADER',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = 'f',
        mods = 'SHIFT|SUPER',
        action = act.Search {
            Regex = '\\w*@\\w+:|❯',
        },
    },
    { key = 'd',          mods = 'SUPER',      action = act.ScrollByPage(0.5) },
    { key = 'u',          mods = 'SUPER',      action = act.ScrollByPage(-0.5) },

    -- { key = 'c', mods = 'LEADER',     action = act.ActivateCopyMode },
    -- { key = 'e', mods = 'CTRL|SHIFT', action = act.QuickSelect },
    { key = 'n',          mods = "LEADER",     action = "ShowLauncher" },
    { key = 'p',          mods = "LEADER",     action = "ShowTabNavigator" },

    -- Create a new workspace with a random name and switch to it
    { key = 'h',          mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
    -- { key = '-',          mods = 'LEADER',      action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES', }, },
    --{ key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
    --{ key = 'y', mods = 'ALT', action = wezterm.action.ShowTabNavigator },

    { key = '-',          mods = 'CTRL',       action = act.DisableDefaultAssignment },
    { key = '=',          mods = 'CTRL',       action = act.DisableDefaultAssignment },
    -- 标签页移动
    { key = 'h',          mods = 'ALT|CTRL',   action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l',          mods = 'ALT|CTRL',   action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k',          mods = 'ALT|CTRL',   action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j',          mods = 'ALT|CTRL',   action = wezterm.action.ActivatePaneDirection 'Down' },

    -- 复制和粘贴
    -- { key = 'c',          mods = 'CTRL|SHIFT',  action = wezterm.action.CopyTo 'Clipboard' },
    -- { key = 'v',          mods = 'CTRL|SHIFT',  action = wezterm.action.PasteFrom 'Clipboard' },
    -- 标签页管理
    -- { key = 'n',          mods = 'CTRL|SHIFT',  action = wezterm.action.SpawnTab 'CurrentPaneDomain' },                     -- 新建标签页
    --{ key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } }, -- 关闭标签页
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },                          -- 上一个标签页
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1) },                           -- 下一个标签页
    -- 分屏管理 (panes)
    { key = 's',          mods = 'LEADER',     action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },   -- 垂直分屏
    { key = 'v',          mods = 'LEADER',     action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- 水平分屏
    { key = 'c',          mods = 'LEADER',     action = act.CloseCurrentPane { confirm = false } },                        -- 关闭 pane
    -- { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'z',          mods = 'LEADER',     action = wezterm.action.TogglePaneZoomState },                              -- 放大/缩小当前分屏
    --{ key = 'f', mods = 'LEADER', action = wezterm.action.ToggleFullScreen }, -- 放大/缩小当前分屏
    -- 内置 SSH 客户端示例
    -- { key = 'S', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab { args = { 'wezterm', 'ssh', 'user@host' } } },
    -- === Shell 设置（可选）===
    -- default_prog = { '/bin/bash' },
    -- default_prog = { '/usr/bin/zsh' },

    -- === 事件处理 (Lua 脚本的强大之处) ===
    -- wezterm.on('user-var-changed', function(window, pane, var_name, var_value)
    --   -- 示例：当用户变量改变时执行一些操作
    --   if var_name == 'MY_CUSTOM_VAR' then
    --     wezterm.log.info('MY_CUSTOM_VAR changed to:', var_value)
    --   end
    -- end),
}

-- copy 模式下的快捷键设置
local function set_copy_mode(mode, key_maps)
    for _, value in pairs(key_maps) do
        table.insert(
            mode,
            value
        )
    end
end

local copy_mode = nil
if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    set_copy_mode(copy_mode,
        {
            -- copy 模式下的快捷键设置
            {
                key = "/",
                mods = "NONE",
                action = act.Multiple({
                    act.CopyMode("ClearPattern"),
                    act.Search({ CaseInSensitiveString = "" }),
                })
            },
            { key = "L", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "H", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
        }
    )
end


-- search 模式下的快捷键设置
local search_mode = nil

if wezterm.gui then
    search_mode = wezterm.gui.default_key_tables().search_mode
    set_copy_mode(
        search_mode,
        {
            -- search 模式下的快捷键设置
            {
                key = "Escape",
                mods = "NONE",
                action = act.Multiple {
                    act.CopyMode("ClearPattern"),
                    act.CopyMode("Close"),
                }
            },
        }
    )
end

config.key_tables = {
    copy_mode = copy_mode,
    search_mode = search_mode,

    resize_pane = {
        { key = 'h',      action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'l',      action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'k',      action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'j',      action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'Escape', action = 'PopKeyTable' },
        -- Cancel the mode by pressing escape
        { key = ';',      action = 'PopKeyTable' },
    },
    move_pane = {
        { key = 'h',      action = wezterm.action.ActivatePaneDirection 'Left' },
        { key = 'l',      action = wezterm.action.ActivatePaneDirection 'Right' },
        { key = 'k',      action = wezterm.action.ActivatePaneDirection 'Up' },
        { key = 'j',      action = wezterm.action.ActivatePaneDirection 'Down' },
        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
        -- Cancel the mode by pressing escape
        { key = ';',      action = 'PopKeyTable' },
    }
}




--==plugin==--

--local modal = wezterm.plugin.require('https://github.com/MLFlexer/modal.wezterm')
--modal.enable_defaults("https://github.com/MLFlexer/modal.wezterm")
--modal.apply_to_config(config)
--modal.set_default_keys(config)
--local copy_key_table = require("ui_mode").key_table

--==Workspaces==

local function tab_title(tab_info, max_width)
    -- local title = tab_info.active_pane.title
    local title = tab_info.tab_title
    local title_num_text = tab_info.tab_index + 1 .. ': '
    local zoomed_flag = '[z]'
    title = wezterm.truncate_left(title, max_width - 5)
    if tab_info.active_pane.is_zoomed then
        title = title_num_text .. zoomed_flag .. title
    else
        title = title_num_text .. title
    end

    -- Otherwise, use the title from the active pane
    -- in that tab
    return title
end

local function tab_decorations(tab, title)
    local element = {}
    table.insert(element, 'ResetAttributes')
    table.insert(element, { Background = { Color = '#24252f' } })
    table.insert(element, { Foreground = { Color = '#A66EFF' } })

    if tab.tab_index == 0 then -- first tab
        table.insert(element, { Text = ' ' })
    else
        table.insert(element, { Text = '' })
    end
    table.insert(element, 'ResetAttributes')
    table.insert(element, { Foreground = { Color = 'Black' } })
    table.insert(element, { Background = { Color = '#B280FF' } })
    table.insert(element, { Text = title })
    table.insert(element, 'ResetAttributes')
    table.insert(element, { Background = { Color = '#1A1B23' } })
    table.insert(element, { Foreground = { Color = '#A66EFF' } })
    table.insert(element, { Text = '' })
    return element
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, conf, hover, max_width)
        local title = tab_title(tab, conf.tab_max_width)
        if tab.is_active then
            title = tab_decorations(tab, title)
        else
            title = ' ' .. title .. ' '
        end
        return title
    end
)

local function get_cpu_usage()
    local pcall_ok, success, output, _ = pcall(wezterm.run_child_process, {
        'cmd.exe', '/c',
        wezterm.home_dir .. '\\.config\\wezterm\\bat\\cpu_usage.bat',
    })

    if not pcall_ok then
        return ''
    end

    if not success or not output or output == "" then
        return "N/A"
    end

    -- 2. 清理输出：移除首尾空白字符
    output = output:gsub("^%s+", ""):gsub("%s+$", "")

    -- 3. 【关键】安全过滤：移除或替换非 ASCII 字符及可能损坏的 UTF-8 序列
    -- 方法一：保守方案，只保留安全的 ASCII 字符
    local safe_output = output:gsub("[^\32-\126]", "?") -- 将非可打印 ASCII 字符替换为问号

    return safe_output
end

local function get_mem_usage()
    local pcall_ok, success, output, _ = pcall(wezterm.run_child_process, {
        'cmd.exe', '/c',
        -- wezterm.home_dir ..
        wezterm.home_dir .. '\\.config\\wezterm\\bat\\mem_usage.bat',
    })

    -- 1. 检查 pcall 和命令执行是否成功
    if not pcall_ok then
        wezterm.log_error("调用 run_child_process 失败: " .. tostring(success))
        return 'N/A'
    end
    if not success then
        wezterm.log_error("BAT 脚本执行失败。")
        return 'N/A'
    end
    if not output or output == "" then
        wezterm.log_info("BAT 脚本输出为空。")
        return 'N/A'
    end

    -- 2. 清理输出：移除首尾空白字符
    output = output:gsub("^%s+", ""):gsub("%s+$", "")

    -- 3. 【关键】安全过滤：移除或替换非 ASCII 字符及可能损坏的 UTF-8 序列
    -- 方法一：保守方案，只保留安全的 ASCII 字符
    local safe_output = output:gsub("[^\32-\126]", "?") -- 将非可打印 ASCII 字符替换为问号

    -- 方法二（可选）：尝试修复常见的 UTF-8 编码问题（例如来自 GBK 的中文）
    -- 这需要更复杂的逻辑，一个简单的尝试是：
    -- pcall(function() safe_output = wezterm.utf8_to_utf8(safe_output) end) -- 假设存在此函数，实际需查阅文档

    -- 4. 最终检查：如果清理后变为空字符串，则返回默认值
    if safe_output == "" then
        wezterm.log_warn("清理后输出为空，使用默认值。原始输出: " .. output)
        return 'N/A'
    end

    return safe_output
end

wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(wezterm.format {
        'ResetAttributes',
        { Foreground = { Color = '#FF7A87' } },
        { Text = '' },
        'ResetAttributes',
        { Foreground = { Color = 'Black' } },
        { Background = { Color = '#FF889B' } },
        { Text = ': ' .. get_mem_usage() },
        'ResetAttributes',
        --{ Foreground = { Color = '#7dbefe'} },
        { Foreground = { Color = '#FF7A87' } },
        { Text = ' ' },
        'ResetAttributes',
        { Foreground = { Color = '#FFD166' } },
        { Text = '' },
        'ResetAttributes',
        { Foreground = { Color = 'Black' } },
        { Background = { Color = '#FFE08A' } },
        { Text = ': ' .. get_cpu_usage() .. '%' },
        'ResetAttributes',
        --{ Foreground = { Color = '#7dbefe'} },
        { Foreground = { Color = '#FFD166' } },
        { Text = ' ' },
        'ResetAttributes',
        { Foreground = { Color = '#5BACFF' } },
        { Text = '' },
        'ResetAttributes',
        { Foreground = { Color = 'Black' } },
        { Background = { Color = '#70B8FF' } },
        { Text = ' ' .. window:active_workspace() },
        'ResetAttributes',
        --{ Foreground = { Color = '#7dbefe'} },
        { Foreground = { Color = '#5BACFF' } },
        { Text = ' ' },
    })
end)

return config
