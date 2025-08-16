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
    
    -- Flash - super fast navigation
    {
      "folke/flash.nvim",
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
        -- ปิด S ไว้ก่อน เพราะอาจงงกับการใช้งาน
        -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      },
      config = function()
        require("flash").setup({
          modes = {
            char = { enabled = false }, -- ปิด f/F/t/T enhancement เพื่อไม่ conflict
          },
        })
      end,
    },
    
    -- Spider - smart word movement
    {
      "chrisgrieser/nvim-spider",
      keys = {
        { "w", function() require('spider').motion('w') end, mode = { "n", "o", "x" }, desc = "Spider-w" },
        { "e", function() require('spider').motion('e') end, mode = { "n", "o", "x" }, desc = "Spider-e" },
        { "b", function() require('spider').motion('b') end, mode = { "n", "o", "x" }, desc = "Spider-b" },
      },
      config = function()
        require("spider").setup({
          skipInsignificantPunctuation = true
        })
      end,
    },
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
  
  -- Note: 's' key now used by flash.nvim for navigation
  
  -- Alternative commands for what 's' used to do
  vim.keymap.set("n", "<leader>s", "cl", { desc = "Substitute character (was 's')" })
  -- S key คืนให้ vim ใช้เป็น substitute line (เดิม)
  
  -- VS Code editor split and navigation
  vim.keymap.set("n", "<leader>v", "<cmd>lua require('vscode').action('workbench.action.splitEditor')<cr>", { desc = "Split editor vertically" })
  vim.keymap.set("n", "<leader>h", "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<cr>", { desc = "Focus left editor group" })
  vim.keymap.set("n", "<leader>l", "<cmd>lua require('vscode').action('workbench.action.focusRightGroup')<cr>", { desc = "Focus right editor group" })
  
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