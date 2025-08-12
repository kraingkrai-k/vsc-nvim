-- Main plugin specifications with environment-aware loading
-- This file imports plugin configurations based on the current environment

local plugin_loader = require("utils.plugin_loader")

-- Base plugins that are always loaded
local base_plugins = {
  -- Core plugins that need to be loaded early
  {
    "folke/lazy.nvim",
    version = "*",
  },
}

-- Environment-specific plugin loading
local env_plugins = {}

if plugin_loader.env.is_standalone then
  -- Full plugin suite for standalone Neovim
  vim.list_extend(env_plugins, {
    -- UI plugins (only in standalone)
    plugin_loader.load_if(
      plugin_loader.conditions.gui(),
      { import = "plugins.ui" }
    ),
    
    -- Editor plugins (enhanced for standalone)
    { import = "plugins.editor" },
    
    -- Coding plugins (LSP, completion, etc.)
    plugin_loader.load_if(
      plugin_loader.conditions.lsp(),
      { import = "plugins.coding" }
    ),
    
    -- Development tools
    plugin_loader.load_if(
      plugin_loader.conditions.terminal(),
      { import = "plugins.tools" }
    ),
  })
  
elseif plugin_loader.env.is_vscode then
  -- VS Code compatible plugins only
  vim.list_extend(env_plugins, {
    { import = "plugins.compat.vscode" },
  })
  
elseif plugin_loader.env.is_kiro then
  -- Kiro enhanced plugins
  vim.list_extend(env_plugins, {
    { import = "plugins.compat.kiro" },
  })
end

-- Compatibility layer (always try to load, but plugins will self-filter)
table.insert(env_plugins, { import = "plugins.compat" })

-- Combine base and environment-specific plugins
local all_plugins = vim.list_extend(base_plugins, env_plugins)

-- Add environment info command
vim.api.nvim_create_user_command("PluginEnvInfo", function()
  plugin_loader.show_env_info()
end, { desc = "Show plugin environment information" })

-- Add health check command
vim.api.nvim_create_user_command("PluginHealthCheck", function()
  local health = plugin_loader.health_check()
  local info = vim.inspect(health)
  vim.notify(info, vim.log.levels.INFO, { title = "Plugin Health Check" })
end, { desc = "Run plugin health check" })

-- Performance tracking for plugin loading
if _G.nvim_config and _G.nvim_config.performance then
  local start_time = vim.loop.hrtime()
  
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
      local end_time = vim.loop.hrtime()
      local plugin_load_time = (end_time - start_time) / 1e6
      _G.nvim_config.performance.startup_phases.plugins = plugin_load_time
      
      -- Notify about environment and loaded plugins
      local env_name = plugin_loader.env.is_vscode and "VS Code" or 
                      plugin_loader.env.is_kiro and "Kiro" or 
                      "Standalone"
      
      vim.notify(
        string.format("Plugins loaded for %s environment (%.2fms)", env_name, plugin_load_time),
        vim.log.levels.DEBUG,
        { title = "Plugin Loader" }
      )
    end,
  })
end

return all_plugins