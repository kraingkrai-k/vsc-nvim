
-- Modern Neovim configuration entry point
-- Bootstrap the new configuration system

-- CRITICAL: Early VS Code detection and minimal loading
if vim.g.vscode then
  -- ULTRA MINIMAL VS Code configuration to prevent hanging
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  
  -- CRITICAL: Disable all providers immediately
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_clipboard_provider = 0
  
  -- CRITICAL: Minimal settings only
  vim.opt.timeoutlen = 1000
  vim.opt.ttimeoutlen = 50
  vim.opt.updatetime = 300
  vim.opt.lazyredraw = true
  
  -- CRITICAL: Initialize minimal global config for VS Code
  _G.nvim_config = {
    env = {
      is_vscode = true,
      is_kiro = false,
      is_standalone = false,
    }
  }
  
  -- CRITICAL: Only essential keymaps
  vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save" })
  vim.keymap.set("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
  
  -- Skip all other configuration for VS Code
  return
end

-- Performance optimization: Start timing for non-VS Code
local start_time = vim.loop.hrtime()

-- Load the main configuration (only for standalone/Kiro)
require("config")

-- Performance monitoring
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.loop.hrtime()
    local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
    
    -- Welcome message based on environment
    if _G.nvim_config.env.is_kiro then
      vim.notify("Modern Neovim config loaded for Kiro! ⚡", vim.log.levels.INFO)
    else
      vim.notify(
        string.format("Modern Neovim config loaded in %.2fms! 🎯", startup_time),
        vim.log.levels.INFO
      )
    end
  end,
})
