-- Ultra Simple Neovim Config - VS Code Focused
-- Only essential features for productivity

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", 
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- VS Code specific config
if vim.g.vscode then
  -- Only essential plugins for VS Code
  require("lazy").setup({
    -- Surround text objects
    { 
      "tpope/vim-surround",
      event = "VeryLazy",
    },
    
    -- Comment toggling
    {
      "numToStr/Comment.nvim",
      keys = {
        { "gcc", mode = "n", desc = "Comment toggle current line" },
        { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
        { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      },
      config = function()
        require("Comment").setup()
      end,
    },
    
    -- Auto pairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()
      end,
    },
    
    -- Repeat for surround
    { "tpope/vim-repeat", event = "VeryLazy" },
  })
  
  -- VS Code keymaps - minimal
  vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
  vim.keymap.set("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
  vim.keymap.set("n", "gm", "%", { desc = "Go to matching bracket" })
  vim.keymap.set("v", "gm", "%", { desc = "Go to matching bracket" })
  vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
  vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
  vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
  vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
  
  -- Disable conflicting keys
  vim.keymap.set("n", "s", "<nop>", { desc = "Disabled for surround" })
  vim.keymap.set("v", "s", "<nop>", { desc = "Disabled for surround" })
  vim.keymap.set("n", "c", "<nop>", { desc = "Disabled for surround - use cl or cc" })
  
  -- Alternative change commands
  vim.keymap.set("n", "<leader>c", "c", { desc = "Change (alternative)" })
  
else
  -- Full config for standalone Neovim (placeholder)
  require("lazy").setup({
    -- Placeholder for future standalone features
  })
  
  -- Standalone keymaps
  vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
  vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
end