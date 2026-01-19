local M = {}

function M.apply_to_config(config)
  -- GPU 加速配置
  config.front_end = 'WebGpu'  -- 或者 'OpenGL'
  config.max_fps = 60
  config.animation_fps = 60
  
  -- 内存优化
  config.scrollback_lines = 10000
  config.audible_bell = 'Disabled'
  
  -- 启动优化
  config.check_for_updates = false
  config.debug_key_events = false
  -- config.log_level = 'WARN'
end

return M