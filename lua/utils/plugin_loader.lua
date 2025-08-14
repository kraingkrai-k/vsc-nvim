-- Environment-aware plugin loading utilities
-- Provides conditional plugin loading based on environment detection and graceful fallbacks

local M = {}

-- Environment detection utilities
M.env = {
  is_vscode = vim.g.vscode ~= nil,
  is_kiro = vim.g.kiro ~= nil,
  is_standalone = vim.g.vscode == nil and vim.g.kiro == nil,
  has_gui = vim.fn.has("gui_running") == 1,
  is_headless = #vim.api.nvim_list_uis() == 0,
  platform = vim.loop.os_uname().sysname:lower(),
}

-- Plugin compatibility matrix
M.compatibility = {
  -- Plugins that work in all environments
  universal = {
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "vim-scripts/ReplaceWithRegister",
    "folke/flash.nvim",
    "folke/which-key.nvim",
    "numToStr/Comment.nvim",
  },
  
  -- Plugins that only work in standalone Neovim
  standalone_only = {
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-tree.lua",
    "akinsho/bufferline.nvim",
    "nvim-lualine/lualine.nvim",
    "lewis6991/gitsigns.nvim",
    "akinsho/toggleterm.nvim",
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "hrsh7th/nvim-cmp",
  },
  
  -- Plugins that work in VS Code but with limited functionality
  vscode_compatible = {
    "tpope/vim-fugitive",
    "plasticboy/vim-markdown",
    "lukas-reineke/indent-blankline.nvim",
  },
  
  -- Plugins that work well with Kiro
  kiro_enhanced = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "plasticboy/vim-markdown",
    "stephpy/vim-yaml",
    "folke/trouble.nvim",
  },
  
  -- Plugins that should be disabled in headless mode
  gui_required = {
    "nvim-tree/nvim-tree.lua",
    "akinsho/bufferline.nvim",
    "nvim-lualine/lualine.nvim",
    "folke/noice.nvim",
    "rcarriga/nvim-notify",
  },
}

-- Feature detection
M.features = {
  -- Check if LSP is available and functional
  lsp_available = function()
    return vim.fn.has("nvim-0.8") == 1 and M.env.is_standalone
  end,
  
  -- Check if Treesitter is available
  treesitter_available = function()
    return vim.fn.has("nvim-0.8") == 1 and not M.env.is_headless
  end,
  
  -- Check if terminal features are available
  terminal_available = function()
    return M.env.is_standalone and not M.env.is_headless
  end,
  
  -- Check if Git is available
  git_available = function()
    return vim.fn.executable("git") == 1
  end,
  
  -- Check if specific command is available
  command_available = function(cmd)
    if type(cmd) ~= "string" then
      return false
    end
    return vim.fn.executable(cmd) == 1
  end,
}

-- Plugin condition builders
M.conditions = {
  -- Only load in standalone Neovim
  standalone = function()
    return M.env.is_standalone
  end,
  
  -- Only load in VS Code
  vscode = function()
    return M.env.is_vscode
  end,
  
  -- Only load in Kiro
  kiro = function()
    return M.env.is_kiro
  end,
  
  -- Load in VS Code or Kiro (extension environments)
  extension = function()
    return M.env.is_vscode or M.env.is_kiro
  end,
  
  -- Only load if GUI is available
  gui = function()
    return M.env.has_gui or (M.env.is_standalone and not M.env.is_headless)
  end,
  
  -- Only load if LSP features are available
  lsp = function()
    return M.features.lsp_available()
  end,
  
  -- Only load if Treesitter is available
  treesitter = function()
    return M.features.treesitter_available()
  end,
  
  -- Only load if terminal features are available
  terminal = function()
    return M.features.terminal_available()
  end,
  
  -- Only load if Git is available
  git = function()
    return M.features.git_available()
  end,
  
  -- Custom condition builder
  custom = function(condition_func)
    return condition_func
  end,
}

-- Fallback mechanisms
M.fallbacks = {
  -- Fallback for missing LSP functionality
  lsp_fallback = function()
    vim.notify(
      "LSP functionality not available in this environment",
      vim.log.levels.INFO,
      { title = "Plugin Loader" }
    )
  end,
  
  -- Fallback for missing file explorer
  explorer_fallback = function()
    vim.cmd("edit .")
  end,
  
  -- Fallback for missing fuzzy finder
  finder_fallback = function()
    vim.cmd("edit .")
  end,
  
  -- Fallback for missing Git integration
  git_fallback = function()
    vim.notify(
      "Git integration not available",
      vim.log.levels.WARN,
      { title = "Plugin Loader" }
    )
  end,
}

-- Plugin specification enhancer
M.enhance_spec = function(spec, options)
  options = options or {}
  
  -- Add environment condition if specified
  if options.condition then
    spec.enabled = options.condition
  end
  
  -- Add fallback configuration
  if options.fallback then
    local original_config = spec.config
    spec.config = function(...)
      if spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()) then
        options.fallback()
        return
      end
      
      if original_config then
        return original_config(...)
      end
    end
  end
  
  -- Add error handling
  if options.error_handler then
    local original_config = spec.config
    spec.config = function(...)
      local ok, result = pcall(original_config or function() end, ...)
      if not ok then
        options.error_handler(result)
        return
      end
      return result
    end
  end
  
  -- Add performance tracking
  if options.track_performance then
    local original_config = spec.config
    spec.config = function(...)
      local start_time = vim.loop.hrtime()
      local result = original_config and original_config(...) or nil
      local end_time = vim.loop.hrtime()
      local load_time = (end_time - start_time) / 1e6
      
      if _G.nvim_config and _G.nvim_config.performance then
        _G.nvim_config.performance.plugin_load_times[spec[1] or spec.name or "unknown"] = load_time
      end
      
      return result
    end
  end
  
  return spec
end

-- Conditional plugin loader
M.load_if = function(condition, spec, fallback_spec)
  if type(condition) == "function" then
    if condition() then
      return spec
    elseif fallback_spec then
      return fallback_spec
    else
      return {}
    end
  elseif condition then
    return spec
  elseif fallback_spec then
    return fallback_spec
  else
    return {}
  end
end

-- Environment-specific plugin groups
M.get_plugins_for_env = function()
  local plugins = {}
  
  if M.env.is_standalone then
    -- Full plugin suite for standalone Neovim
    vim.list_extend(plugins, {
      { import = "plugins.ui" },
      { import = "plugins.editor" },
      { import = "plugins.coding" },
      { import = "plugins.tools" },
    })
  elseif M.env.is_vscode then
    -- VS Code compatible plugins only
    vim.list_extend(plugins, {
      { import = "plugins.compat.vscode" },
    })
  elseif M.env.is_kiro then
    -- Kiro enhanced plugins
    vim.list_extend(plugins, {
      { import = "plugins.compat.kiro" },
    })
  end
  
  return plugins
end

-- Plugin health check
M.health_check = function()
  local health = {
    environment = M.env,
    features = {},
    missing_dependencies = {},
    recommendations = {},
  }
  
  -- Check feature availability
  for feature, check_func in pairs(M.features) do
    health.features[feature] = check_func()
  end
  
  -- Check for missing dependencies
  local deps = { "git", "rg", "fd", "node", "python3" }
  for _, dep in ipairs(deps) do
    if type(dep) == "string" and not M.features.command_available(dep) then
      table.insert(health.missing_dependencies, dep)
    end
  end
  
  -- Generate recommendations
  if M.env.is_standalone and #health.missing_dependencies > 0 then
    table.insert(health.recommendations, "Install missing dependencies for full functionality")
  end
  
  if not health.features.lsp_available then
    table.insert(health.recommendations, "LSP features disabled in this environment")
  end
  
  return health
end

-- Environment info display
M.show_env_info = function()
  local info = {
    "=== Neovim Environment Information ===",
    string.format("Environment: %s", 
      M.env.is_vscode and "VS Code" or 
      M.env.is_kiro and "Kiro" or 
      "Standalone"
    ),
    string.format("Platform: %s", M.env.platform),
    string.format("GUI: %s", M.env.has_gui and "Yes" or "No"),
    string.format("Headless: %s", M.env.is_headless and "Yes" or "No"),
    "",
    "Available Features:",
  }
  
  for feature, check_func in pairs(M.features) do
    local available = check_func()
    table.insert(info, string.format("  %s: %s", feature, available and "✓" or "✗"))
  end
  
  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Environment Info" })
end

-- Global access
_G.plugin_loader = M

return M