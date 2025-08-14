-- VS Code compatibility layer - ULTRA MINIMAL FOR STABILITY
-- Absolute minimal configuration to prevent hanging and mode switching issues

-- Early return if not in VS Code environment
if not _G.nvim_config.env.is_vscode then
  return {}
end

-- Providers already disabled in init.lua, no need to duplicate

-- CRITICAL: Ultra minimal VS Code settings to prevent hanging
-- These settings are already set in init.lua, keep them minimal here

-- REMOVED: VS Code keymaps to prevent conflicts with native shortcuts
-- Let VS Code handle gd, gr, K natively for better stability

-- Disable potentially conflicting features
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Return EMPTY table - no plugins to prevent any conflicts
return {}