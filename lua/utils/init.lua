-- Utility functions for Neovim configuration
local M = {}

-- Safe require function with error handling
function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(
      string.format("Failed to load module '%s': %s", module, result),
      vim.log.levels.ERROR,
      { title = "Configuration Error" }
    )
    return nil
  end
  return result
end

-- Plugin setup with error handling
function M.setup_plugin(plugin_name, config_func)
  local plugin = M.safe_require(plugin_name)
  if plugin and config_func then
    local ok, err = pcall(config_func, plugin)
    if not ok then
      vim.notify(
        string.format("Failed to configure %s: %s", plugin_name, err),
        vim.log.levels.WARN,
        { title = "Plugin Configuration Error" }
      )
    end
  end
end

-- Check if a plugin is available
function M.has_plugin(plugin_name)
  return pcall(require, plugin_name)
end

-- Get plugin configuration path
function M.get_plugin_config(plugin_name)
  return string.format("plugins.%s", plugin_name)
end

-- Merge tables recursively
function M.merge_tables(t1, t2)
  local result = vim.deepcopy(t1)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = M.merge_tables(result[k], v)
    else
      result[k] = v
    end
  end
  return result
end

-- Check if running in a specific environment
function M.is_vscode()
  return _G.nvim_config.env.is_vscode
end

function M.is_kiro()
  return _G.nvim_config.env.is_kiro
end

function M.is_standalone()
  return _G.nvim_config.env.is_standalone
end

-- Get current platform
function M.get_platform()
  return _G.nvim_config.env.platform
end

-- Performance monitoring
function M.benchmark(name, func)
  local start_time = vim.loop.hrtime()
  local result = func()
  local end_time = vim.loop.hrtime()
  local duration = (end_time - start_time) / 1e6 -- Convert to milliseconds
  
  _G.nvim_config.performance.plugin_load_times[name] = duration
  
  if duration > 50 then -- Warn if loading takes more than 50ms
    vim.notify(
      string.format("Slow plugin loading detected: %s took %.2fms", name, duration),
      vim.log.levels.WARN,
      { title = "Performance Warning" }
    )
  end
  
  return result
end

-- Create a simple cache for expensive operations
function M.create_cache()
  local cache = {}
  return {
    get = function(key)
      return cache[key]
    end,
    set = function(key, value)
      cache[key] = value
    end,
    clear = function()
      cache = {}
    end,
    has = function(key)
      return cache[key] ~= nil
    end
  }
end

-- Debounce function for expensive operations
function M.debounce(func, delay)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      func(unpack(args))
    end, delay)
  end
end

-- Throttle function for frequent operations
function M.throttle(func, delay)
  local last_call = 0
  return function(...)
    local now = vim.loop.now()
    if now - last_call >= delay then
      last_call = now
      return func(...)
    end
  end
end

-- File system utilities
function M.file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

function M.dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

function M.create_dir(path)
  if not M.dir_exists(path) then
    vim.fn.mkdir(path, "p")
  end
end

-- String utilities
function M.starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

function M.ends_with(str, suffix)
  return str:sub(-#suffix) == suffix
end

function M.split(str, delimiter)
  local result = {}
  local pattern = string.format("([^%s]+)", delimiter)
  for match in str:gmatch(pattern) do
    table.insert(result, match)
  end
  return result
end

-- Notification helper
function M.notify(message, level, opts)
  level = level or vim.log.levels.INFO
  opts = opts or {}
  vim.notify(message, level, opts)
end

-- Error handling wrapper
function M.try(func, error_handler)
  local ok, result = pcall(func)
  if not ok then
    if error_handler then
      error_handler(result)
    else
      M.notify(string.format("Error: %s", result), vim.log.levels.ERROR)
    end
    return nil
  end
  return result
end

return M