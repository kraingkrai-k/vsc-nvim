-- Common keymaps with environment-specific implementations

if vim.g.vscode then
  -- ===== VS CODE KEYMAPS =====
  
  -- Basic file operations
  vim.keymap.set("n", "<leader>w", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
  vim.keymap.set("n", "<leader>q", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<cr>", { desc = "Quit" })
  
  -- Buffer management
  vim.keymap.set("n", "<leader>bd", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<cr>", { desc = "Delete buffer" })
  vim.keymap.set("n", "[b", "<cmd>lua require('vscode').action('workbench.action.previousEditor')<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>lua require('vscode').action('workbench.action.nextEditor')<cr>", { desc = "Next buffer" })
  
  -- Quick Save
  vim.keymap.set("n", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
  vim.keymap.set("i", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
  vim.keymap.set("v", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
  
else
  -- ===== STANDALONE NEOVIM KEYMAPS =====
  
  -- Basic file operations
  vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
  vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
  
  -- Buffer management
  vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
  vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  
  -- Quick Save and Quit
  vim.keymap.set("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
  vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
  vim.keymap.set("v", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
  
  -- Window management
  vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
  vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
  vim.keymap.set("n", "<leader>wd", "<C-w>q", { desc = "Delete window" })
  vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
  
  -- Standalone specific keymaps
  vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })
  
  -- Window navigation
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
  
  -- Buffer navigation (LazyVim style - additional to [b/]b)
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer (LazyVim)" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer (LazyVim)" })
  vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>|'\"", { desc = "Delete other buffers" })
  
  -- Better up/down
  vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  
  -- Clear search highlighting
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
  
end

-- Common editing keymaps
vim.keymap.set("n", "gm", "%", { desc = "Go to matching bracket" })
vim.keymap.set("v", "gm", "%", { desc = "Go to matching bracket" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Alternative commands for what 's' used to do (replaced by flash)
vim.keymap.set("n", "<leader>s", "cl", { desc = "Substitute character (was 's')" })

-- Code formatting (current file)
vim.keymap.set("n", "<leader>cf", ":!npx prettier --write %<CR>", { desc = "Format current file with prettier" })
vim.keymap.set("n", "<leader>cl", ":!npx eslint --fix %<CR>", { desc = "Lint fix current file" })