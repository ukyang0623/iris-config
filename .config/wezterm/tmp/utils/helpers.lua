local wezterm = require 'wezterm'

local M = {}

-- 预定义布局
M.layouts = {
  coding = function(pane)
    -- 代码开发布局：左侧编辑器，右侧终端
    pane:split_horizontal { size = 0.7 }
    local right_pane = pane:get_neighbor 'Right'
    if right_pane then
      right_pane:split_vertical { size = 0.5 }
    end
  end,
  
  monitoring = function(pane)
    -- 系统监控布局：四个等分窗格
    pane:split_horizontal { size = 0.5 }
    local right_pane = pane:get_neighbor 'Right'
    pane:split_vertical { size = 0.5 }
    if right_pane then
      right_pane:split_vertical { size = 0.5 }
    end
  end
}

-- 检测是否在远程会话中
function M.is_remote_session()
  return wezterm.remote_pty and wezterm.remote_pty.client or false
end

-- 根据网络质量调整配置
function M.adaptive_config(config)
  if M.is_remote_session() then
    -- 远程会话优化
    config.local_echo_threshold_ms = 50
    config.enable_scroll_bar = false
  else
    -- 本地会话全功能
    config.local_echo_threshold_ms = 10
    config.enable_scroll_bar = true
  end
end

return M