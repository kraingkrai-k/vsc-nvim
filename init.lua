-- Neovim config (LazyVim-standard keymaps): standalone terminal + VS Code (vscode-neovim)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
require("lazy").setup(plugins, {
  rocks = { enabled = false }, -- ไม่มี plugin ไหนใช้ luarocks (กัน checkhealth error เรื่อง hererocks)
})
