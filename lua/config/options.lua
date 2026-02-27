-- Common vim options for both VS Code and Standalone

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window title configuration
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')} - nvim"

-- Basic options - optimized for VS Code + plugins
vim.opt.number = true
vim.opt.relativenumber = true   -- จำเป็นสำหรับ count motions (5j, 8k, d3j)
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true       -- highlight บรรทัดปัจจุบัน (ใช้คู่กับ relativenumber)
vim.opt.scrolloff = 8           -- เห็นบริบทรอบ ๆ cursor

-- Additional options for standalone Neovim
if not vim.g.vscode then
  vim.opt.termguicolors = true
  vim.opt.signcolumn = "yes"
  vim.opt.updatetime = 200
  vim.opt.timeoutlen = 300
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.wrap = false
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  vim.opt.undofile = true
  vim.opt.undolevels = 10000
  vim.opt.smoothscroll = true
end