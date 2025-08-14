-- Modern keymaps configuration with enhanced utilities
local keymap_utils = require("utils.keymaps")
local utils = require("utils.init")

-- Use the enhanced keymap utility
local keymap = keymap_utils.set

-- Set up basic navigation and editing keymaps (only in standalone/Kiro)
if not _G.nvim_config.env.is_vscode then
  keymap_utils.setup_navigation_keymaps()
  keymap_utils.setup_editing_keymaps()
end

-- Clear search highlighting
keymap("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Better movement
keymap("n", "H", "0", { desc = "Go to beginning of line" })
keymap("n", "L", "$", { desc = "Go to end of line" })
keymap("n", "gm", "%", { desc = "Go to matching bracket" })
keymap("v", "gm", "%", { desc = "Go to matching bracket" })

-- Better line joining
keymap("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
-- DISABLED: K keymap to prevent VS Code conflicts - let VS Code handle hover natively
if not _G.nvim_config.env.is_vscode then
  keymap("n", "K", "kJ", { desc = "Join with line above" })
end

-- Better yanking
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- Better indenting in visual mode
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Undo break points in insert mode
keymap("i", ",", ",<C-g>u", { desc = "Add undo break point" })
keymap("i", ".", ".<C-g>u", { desc = "Add undo break point" })
keymap("i", "!", "!<C-g>u", { desc = "Add undo break point" })
keymap("i", "?", "?<C-g>u", { desc = "Add undo break point" })

-- Better paste in visual mode (don't overwrite register)
keymap("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

-- Paste without overwriting in visual mode
keymap("v", "p", "P", { desc = "Paste without overwriting" })

-- Redo
keymap("n", "U", "<C-r>", { desc = "Redo" })

-- Fast scrolling
keymap("n", "<C-j>", "5j", { desc = "Fast scroll down" })
keymap("n", "<C-k>", "5k", { desc = "Fast scroll up" })

-- Quick movement
keymap("n", "<C-o>", "<C-o>", { desc = "Go to previous location" })
keymap("n", "<C-i>", "<C-i>", { desc = "Go to next location" })
keymap("n", "''", "''", { desc = "Go to previous position" })

-- ReplaceWithRegister plugin mappings (only in standalone/Kiro)
if not _G.nvim_config.env.is_vscode then
  keymap("n", "<leader>rr", "<Plug>ReplaceWithRegisterLine", { desc = "Replace line with register" })
  keymap("n", "<leader>r", "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register operator" })
  keymap("v", "<leader>r", "<Plug>ReplaceWithRegisterVisual", { desc = "Replace selection with register" })
end

-- Environment-specific keymaps
if _G.nvim_config.env.is_vscode then
  -- VS Code specific keymaps - ULTRA MINIMAL to prevent hanging
  
  -- CRITICAL: Disable problematic keys that cause mode switching issues
  keymap("n", "s", "<Nop>", { desc = "Disabled in VS Code" })
  keymap("n", "<C-j>", "<Nop>", { desc = "Disabled in VS Code" })
  keymap("n", "<C-k>", "<Nop>", { desc = "Disabled in VS Code" })
  
  -- ONLY essential file operations - no complex VSCodeNotify calls
  keymap("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
  keymap("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
  
  -- Essential navigation handled by vscode.lua plugin config
  
  -- DISABLE all other complex keymaps that might cause conflicts
  -- Let VS Code handle everything else natively

elseif _G.nvim_config.env.is_standalone then
  -- Standalone Neovim specific keymaps
  
  -- Window navigation
  keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
  keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

  -- Window resizing
  keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
  keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
  keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
  keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

  -- Buffer navigation
  keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
  keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
  keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

  -- Buffer management
  keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
  keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })

  -- Tab management
  keymap("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
  keymap("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
  keymap("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
  keymap("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
  keymap("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })

  -- File operations
  keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
  keymap("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
  keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
  keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

  -- Quick fix list
  keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
  keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
  keymap("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
  keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

  -- Diagnostic navigation (will be enhanced by LSP plugins)
  keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
  keymap("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Diagnostic location list" })
end

-- Terminal keymaps (for standalone Neovim)
if _G.nvim_config.env.is_standalone then
  keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
  keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
  keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
  keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
end