-- Lazy.nvim plugin manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Performance optimization settings
vim.loader.enable() -- Enable Lua module cache (Neovim 0.9+)

-- Load environment-aware plugin loader
local plugin_loader = require("utils.plugin_loader")

-- Lazy.nvim configuration with environment awareness
require("lazy").setup({
  spec = {
    -- Import plugin specifications with environment awareness
    { import = "plugins" },
  },
  defaults = {
    lazy = true, -- Enable lazy loading by default
    version = false, -- Use latest git commit instead of version tags
    -- Add performance tracking to all plugins
    config = function(_, opts)
      -- This will be overridden by individual plugin configs
      -- but provides a base for performance tracking
    end,
  },
  install = {
    missing = true, -- Install missing plugins on startup
    colorscheme = { "catppuccin", "habamax" }, -- Fallback colorschemes during installation
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify about updates
    frequency = 3600, -- Check every hour
  },
  change_detection = {
    enabled = true, -- Enable change detection
    notify = false, -- Don't notify about config changes
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- Reset packpath to improve startup time
    rtp = {
      reset = true, -- Reset runtime path to improve startup time
      paths = {}, -- Add any extra paths here
      -- Environment-aware plugin disabling
      disabled_plugins = vim.list_extend({
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }, plugin_loader.env.is_vscode and {
        -- Disable additional plugins in VS Code
        "netrwPlugin", -- VS Code handles file exploration
        "spellfile_plugin", -- VS Code handles spell checking
      } or plugin_loader.env.is_kiro and {
        -- Disable plugins that conflict with Kiro
        "netrwPlugin", -- Kiro has its own file management
      } or {
        -- Standalone Neovim - only disable core plugins
        "netrwPlugin", -- We use nvim-tree or telescope
      }),
    },
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
})

-- Enhanced performance monitoring with environment awareness
local start_time = vim.loop.hrtime()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.loop.hrtime()
    local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
    
    if _G.nvim_config and _G.nvim_config.performance then
      _G.nvim_config.performance.startup_time = startup_time
    end
    
    -- Environment-specific performance thresholds
    local warning_threshold = plugin_loader.env.is_vscode and 200 or  -- VS Code is slower
                             plugin_loader.env.is_kiro and 150 or     -- Kiro has some overhead
                             100                                       -- Standalone should be fastest
    
    if startup_time > warning_threshold then
      vim.notify(
        string.format("Slow startup detected: %.2fms (threshold: %dms)", startup_time, warning_threshold),
        vim.log.levels.WARN,
        { title = "Performance Warning" }
      )
    end
    
    -- Environment info
    local env_name = plugin_loader.env.is_vscode and "VS Code" or 
                    plugin_loader.env.is_kiro and "Kiro" or 
                    "Standalone"
    
    vim.notify(
      string.format("Neovim ready in %s environment (%.2fms)", env_name, startup_time),
      vim.log.levels.DEBUG,
      { title = "Startup Complete" }
    )
  end,
})

-- Add lazy loading event tracking
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if _G.nvim_config and _G.nvim_config.performance then
      local plugin_name = event.data
      local load_time = vim.loop.hrtime()
      
      -- Track plugin load order and timing
      table.insert(_G.nvim_config.plugins.load_order, {
        name = plugin_name,
        timestamp = load_time,
        environment = plugin_loader.env.is_vscode and "vscode" or 
                     plugin_loader.env.is_kiro and "kiro" or 
                     "standalone"
      })
    end
  end,
})