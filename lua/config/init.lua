-- Main configuration entry point with comprehensive state management
local M = {}

-- Performance monitoring: Track startup time
local startup_start = vim.loop.hrtime()

-- Initialize platform utilities
local platform = require("utils.platform")
local utils = require("utils.init")

-- Global configuration state model
_G.nvim_config = {
  -- Environment detection with enhanced platform info
  env = {
    is_vscode = vim.g.vscode ~= nil,
    is_kiro = vim.g.kiro ~= nil,
    is_standalone = vim.g.vscode == nil and vim.g.kiro == nil,
    platform = platform.detect_os(),
    is_wsl = platform.is_wsl(),
    platform_info = platform.get_env_info()
  },
  
  -- Performance metrics with detailed tracking
  performance = {
    startup_time = 0,
    plugin_load_times = {},
    memory_usage = 0,
    startup_phases = {
      init = 0,
      options = 0,
      keymaps = 0,
      autocommands = 0,
      plugins = 0
    },
    benchmarks = {}
  },
  
  -- User preferences with validation
  preferences = {
    theme = "catppuccin",
    leader_key = " ",
    local_leader_key = "\\",
    timeout_len = 300,
    custom_keymaps = {},
    ui = {
      transparency = false,
      animations = true,
      icons = true,
      statusline_style = "default"
    },
    editor = {
      auto_save = false,
      format_on_save = true,
      show_diagnostics = true,
      completion_style = "detailed"
    },
    performance = {
      lazy_loading = true,
      startup_time_warning = 100, -- ms
      memory_warning = 500 -- MB
    }
  },
  
  -- Plugin states with detailed tracking
  plugins = {
    loaded = {},
    lazy_loaded = {},
    failed = {},
    disabled = {},
    load_order = {},
    dependencies = {}
  },
  
  -- Configuration state
  state = {
    initialized = false,
    config_path = vim.fn.stdpath("config"),
    data_path = vim.fn.stdpath("data"),
    cache_path = vim.fn.stdpath("cache"),
    version = vim.version(),
    features = {
      lsp_available = false,
      treesitter_available = false,
      telescope_available = false
    }
  },
  
  -- User customization hooks
  hooks = {
    before_init = {},
    after_init = {},
    before_plugin_load = {},
    after_plugin_load = {}
  }
}

-- Configuration state management functions
M.config = _G.nvim_config

-- Get configuration value with path notation (e.g., "preferences.theme")
function M.get(path, default)
  local keys = vim.split(path, ".", { plain = true })
  local value = M.config
  
  for _, key in ipairs(keys) do
    if type(value) == "table" and value[key] ~= nil then
      value = value[key]
    else
      return default
    end
  end
  
  return value
end

-- Set configuration value with path notation
function M.set(path, value)
  local keys = vim.split(path, ".", { plain = true })
  local current = M.config
  
  for i = 1, #keys - 1 do
    local key = keys[i]
    if type(current[key]) ~= "table" then
      current[key] = {}
    end
    current = current[key]
  end
  
  current[keys[#keys]] = value
end

-- Merge user preferences with defaults
function M.merge_preferences(user_prefs)
  if type(user_prefs) == "table" then
    M.config.preferences = vim.tbl_deep_extend("force", M.config.preferences, user_prefs)
  end
end

-- Performance monitoring functions
function M.benchmark_phase(phase_name, func)
  local start_time = vim.loop.hrtime()
  local result = func()
  local end_time = vim.loop.hrtime()
  local duration = (end_time - start_time) / 1e6 -- Convert to milliseconds
  
  M.config.performance.startup_phases[phase_name] = duration
  
  return result
end

function M.track_plugin_load(plugin_name, load_time)
  M.config.performance.plugin_load_times[plugin_name] = load_time
  table.insert(M.config.plugins.load_order, {
    name = plugin_name,
    time = load_time,
    timestamp = os.time()
  })
end

function M.mark_plugin_loaded(plugin_name, status)
  if status == "loaded" then
    table.insert(M.config.plugins.loaded, plugin_name)
  elseif status == "lazy_loaded" then
    table.insert(M.config.plugins.lazy_loaded, plugin_name)
  elseif status == "failed" then
    table.insert(M.config.plugins.failed, plugin_name)
  end
end

-- User preference management
function M.load_user_preferences()
  local user_config_path = M.config.state.config_path .. "/user_preferences.lua"
  
  if utils.file_exists(user_config_path) then
    local ok, user_prefs = pcall(dofile, user_config_path)
    if ok and type(user_prefs) == "table" then
      M.merge_preferences(user_prefs)
      utils.notify("User preferences loaded", vim.log.levels.INFO)
    else
      utils.notify("Failed to load user preferences: " .. tostring(user_prefs), vim.log.levels.WARN)
    end
  end
end

-- Save current preferences to user file
function M.save_user_preferences()
  local user_config_path = M.config.state.config_path .. "/user_preferences.lua"
  local content = string.format("return %s", vim.inspect(M.config.preferences))
  
  local file = io.open(user_config_path, "w")
  if file then
    file:write(content)
    file:close()
    utils.notify("User preferences saved", vim.log.levels.INFO)
  else
    utils.notify("Failed to save user preferences", vim.log.levels.ERROR)
  end
end

-- Hook system for user customization
function M.add_hook(hook_type, callback)
  if M.config.hooks[hook_type] then
    table.insert(M.config.hooks[hook_type], callback)
  end
end

function M.run_hooks(hook_type, ...)
  if M.config.hooks[hook_type] then
    for _, callback in ipairs(M.config.hooks[hook_type]) do
      local ok, err = pcall(callback, ...)
      if not ok then
        utils.notify(string.format("Hook error (%s): %s", hook_type, err), vim.log.levels.ERROR)
      end
    end
  end
end

-- Feature detection
function M.detect_features()
  M.config.state.features.lsp_available = vim.fn.has("nvim-0.8") == 1
  M.config.state.features.treesitter_available = pcall(require, "nvim-treesitter")
  M.config.state.features.telescope_available = pcall(require, "telescope")
end

-- Configuration validation
function M.validate_config()
  local issues = {}
  
  -- Validate leader keys
  if type(M.config.preferences.leader_key) ~= "string" or M.config.preferences.leader_key == "" then
    table.insert(issues, "Invalid leader key")
  end
  
  -- Validate timeout
  if type(M.config.preferences.timeout_len) ~= "number" or M.config.preferences.timeout_len < 0 then
    table.insert(issues, "Invalid timeout length")
  end
  
  -- Validate theme
  if type(M.config.preferences.theme) ~= "string" then
    table.insert(issues, "Invalid theme name")
  end
  
  if #issues > 0 then
    utils.notify("Configuration validation issues: " .. table.concat(issues, ", "), vim.log.levels.WARN)
  end
  
  return #issues == 0
end

-- Performance reporting
function M.get_performance_report()
  local total_startup = M.config.performance.startup_time
  local phases = M.config.performance.startup_phases
  local plugin_times = M.config.performance.plugin_load_times
  
  local report = {
    "=== Neovim Performance Report ===",
    string.format("Total startup time: %.2fms", total_startup),
    "",
    "Startup phases:",
  }
  
  for phase, time in pairs(phases) do
    table.insert(report, string.format("  %s: %.2fms", phase, time))
  end
  
  table.insert(report, "")
  table.insert(report, "Plugin load times:")
  
  local sorted_plugins = {}
  for name, time in pairs(plugin_times) do
    table.insert(sorted_plugins, { name = name, time = time })
  end
  
  table.sort(sorted_plugins, function(a, b) return a.time > b.time end)
  
  for i = 1, math.min(10, #sorted_plugins) do
    local plugin = sorted_plugins[i]
    table.insert(report, string.format("  %s: %.2fms", plugin.name, plugin.time))
  end
  
  return table.concat(report, "\n")
end

-- Memory usage monitoring
function M.update_memory_usage()
  local handle = io.popen("ps -o rss= -p " .. vim.fn.getpid())
  if handle then
    local memory_kb = handle:read("*a"):gsub("%s+", "")
    handle:close()
    M.config.performance.memory_usage = tonumber(memory_kb) / 1024 -- Convert to MB
  end
end

-- Configuration initialization
function M.init()
  -- Run before_init hooks
  M.run_hooks("before_init")
  
  -- Load user preferences first
  M.load_user_preferences()
  
  -- Validate configuration
  M.validate_config()
  
  -- Detect available features
  M.detect_features()
  
  -- Load core configuration modules with performance tracking
  M.benchmark_phase("options", function()
    require("config.options")
  end)
  
  M.benchmark_phase("keymaps", function()
    require("config.keymaps")
  end)
  
  M.benchmark_phase("autocommands", function()
    require("config.autocommands")
  end)
  
  M.benchmark_phase("plugins", function()
    require("config.lazy")
  end)
  
  -- Calculate total startup time
  local startup_end = vim.loop.hrtime()
  M.config.performance.startup_time = (startup_end - startup_start) / 1e6
  
  -- Update memory usage
  M.update_memory_usage()
  
  -- Mark as initialized
  M.config.state.initialized = true
  
  -- Run after_init hooks
  M.run_hooks("after_init")
  
  -- Performance warning
  if M.config.performance.startup_time > M.config.preferences.performance.startup_time_warning then
    utils.notify(
      string.format("Slow startup detected: %.2fms", M.config.performance.startup_time),
      vim.log.levels.WARN,
      { title = "Performance Warning" }
    )
  end
end

-- Expose configuration management functions globally
_G.nvim_config_manager = M

-- Initialize configuration
M.init()

return M