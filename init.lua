-- Ultra Simple Neovim Config - VS Code Focused
-- Clean modular structure with no duplication

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", 
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration
require("config.options")
require("config.keymaps")

-- Load plugins based on environment
local plugins = {}

-- Common plugins (both VS Code and Standalone)
vim.list_extend(plugins, require("plugins.common"))

-- Environment-specific plugins and keymaps
if vim.g.vscode then
  -- VS Code: Load specific keymaps and return empty plugins
  vim.list_extend(plugins, require("plugins.vscode"))
else
  -- Standalone: Load UI and feature plugins
  vim.list_extend(plugins, require("plugins.standalone"))
end

-- Initialize lazy.nvim with all plugins
require("lazy").setup(plugins)