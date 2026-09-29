-- Keymaps with environment-specific implementations (LazyVim standard)

if vim.g.vscode then
  -- ===== VS CODE =====
  local vscode = require("vscode")

  -- File operations
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
  vim.keymap.set({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

  -- Buffer management
  -- Snacks.bufdelete: ลบ buffer โดยไม่ปิด window/ไม่ทำ layout เพี้ยน, ถามก่อนถ้ายังไม่ save (LazyVim standard)
  vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
  -- [b / ]b เป็น default ของ Neovim แล้ว
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })

  -- Window management (LazyVim standard)
  vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split vertical" })
  vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })
  vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "Delete window" }) -- c: ไม่ปิด nvim ถ้าเป็น window สุดท้าย

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
  vim.keymap.set("x", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  vim.keymap.set("x", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

  -- Diagnostics: ]d / [d เป็น default ของ Neovim 0.11 แล้ว

  -- Quit all & Lazy (LazyVim standard)
  vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
  vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

  -- n/N: ไปข้างหน้า/ถอยหลังเสมอ ไม่ว่าจะค้นด้วย / หรือ ? (LazyVim standard)
  vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
  vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })

  -- Clear search highlighting
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear hlsearch" })
end

-- ===== Common keymaps (both environments) =====

-- Exit insert mode without reaching for Esc (home row friendly)
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- "x" ไม่ใช่ "v": "v" รวม select mode ด้วย → พิมพ์ < > ใน snippet placeholder แล้วกลายเป็น indent
vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })
