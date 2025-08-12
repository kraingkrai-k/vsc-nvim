
-- Modern Neovim configuration entry point
-- Bootstrap the new configuration system

-- Performance optimization: Start timing
local start_time = vim.loop.hrtime()

-- Load the main configuration
require("config")

-- Performance monitoring
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.loop.hrtime()
    local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
    
    -- Welcome message based on environment
    if _G.nvim_config.env.is_vscode then
      vim.notify("Modern Neovim config loaded for VS Code! 🚀", vim.log.levels.INFO)
    elseif _G.nvim_config.env.is_kiro then
      vim.notify("Modern Neovim config loaded for Kiro! ⚡", vim.log.levels.INFO)
    else
      vim.notify(
        string.format("Modern Neovim config loaded in %.2fms! 🎯", startup_time),
        vim.log.levels.INFO
      )
    end
  end,
})
