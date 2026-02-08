-- Keymaps with environment-specific implementations (LazyVim standard)

if vim.g.vscode then
  -- ===== VS CODE =====
  local vscode = require("vscode")

  -- File operations
  vim.keymap.set("n", "<leader>w", function() vscode.action("workbench.action.files.save") end, { desc = "Save" })
  vim.keymap.set("n", "<leader>q", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close" })
  vim.keymap.set({ "n", "i", "v" }, "<C-s>", function() vscode.action("workbench.action.files.save") end, { desc = "Save" })

  -- Buffer management
  vim.keymap.set("n", "<leader>bd", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Delete buffer" })
  vim.keymap.set("n", "[b", function() vscode.action("workbench.action.previousEditor") end, { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", function() vscode.action("workbench.action.nextEditor") end, { desc = "Next buffer" })

  -- Diagnostics
  vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.next") end, { desc = "Next diagnostic" })
  vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.prev") end, { desc = "Prev diagnostic" })

else
  -- ===== STANDALONE =====

  -- File operations
  vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
  vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
  vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

  -- Buffer management
  vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
  vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>|'\"", { desc = "Delete other buffers" })

  -- Window management (LazyVim standard)
  vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split vertical" })
  vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })
  vim.keymap.set("n", "<leader>wd", "<C-w>q", { desc = "Delete window" })

  -- Window navigation
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })

  -- Better up/down (LazyVim standard)
  vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

  -- Move lines (LazyVim standard)
  vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
  vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
  vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

  -- Diagnostics
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

  -- Quit all & Lazy (LazyVim standard)
  vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
  vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

  -- Clear search highlighting
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear hlsearch" })
end

-- ===== Common keymaps (both environments) =====
vim.keymap.set("n", "gm", "%", { desc = "Go to matching bracket" })
vim.keymap.set("v", "gm", "%", { desc = "Go to matching bracket" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
