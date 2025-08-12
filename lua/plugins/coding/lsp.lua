-- LSP configuration - minimal setup for compatibility
-- Full LSP features are skipped as VS Code/Kiro provide superior integration

-- Only load LSP in standalone Neovim environment
if not _G.nvim_config or not _G.nvim_config.env.is_standalone then
  return {}
end

return {
  -- Placeholder for future LSP configuration
  -- Currently disabled to avoid conflicts with VS Code/Kiro
}