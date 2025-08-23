-- VS Code specific keymaps and configurations

if not vim.g.vscode then
  return {}
end

-- VS Code specific keymaps
-- File explorer
vim.keymap.set("n", "<leader>e", "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<cr>", { desc = "Toggle Explorer" })

-- Find files  
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('vscode').action('workbench.action.showAllEditors')<cr>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fr", "<cmd>lua require('vscode').action('workbench.action.openRecent')<cr>", { desc = "Recent Files" })

-- Git operations
vim.keymap.set("n", "<leader>gg", "<cmd>lua require('vscode').action('workbench.view.scm')<cr>", { desc = "LazyGit (SCM)" })
vim.keymap.set("n", "<leader>gd", "<cmd>lua require('vscode').action('git.openChange')<cr>", { desc = "Git Diff" })
vim.keymap.set("n", "<leader>gb", "<cmd>lua require('vscode').action('gitlens.toggleFileBlame')<cr>", { desc = "Git Blame" })

-- Git Hunk operations (match GitSigns)
vim.keymap.set("n", "]c", "<cmd>lua require('vscode').action('workbench.action.editor.nextChange')<cr>", { desc = "Next Hunk" })
vim.keymap.set("n", "[c", "<cmd>lua require('vscode').action('workbench.action.editor.previousChange')<cr>", { desc = "Prev Hunk" })
vim.keymap.set("n", "<leader>hs", "<cmd>lua require('vscode').action('git.stageSelectedRanges')<cr>", { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>hr", "<cmd>lua require('vscode').action('git.revertSelectedRanges')<cr>", { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>hp", "<cmd>lua require('vscode').action('editor.action.dirtydiff.previous')<cr>", { desc = "Preview Hunk" })

-- Window management (VS Code actions)
vim.keymap.set("n", "<leader>wv", "<cmd>lua require('vscode').action('workbench.action.splitEditorRight')<cr>", { desc = "Split editor vertically" })
vim.keymap.set("n", "<leader>ws", "<cmd>lua require('vscode').action('workbench.action.splitEditorDown')<cr>", { desc = "Split editor horizontally" })
vim.keymap.set("n", "<leader>wd", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<cr>", { desc = "Close editor" })
vim.keymap.set("n", "<leader>wo", "<cmd>lua require('vscode').action('workbench.action.closeOtherEditors')<cr>", { desc = "Close other editors" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<cr>", { desc = "Focus Left Window" })
vim.keymap.set("n", "<C-l>", "<cmd>lua require('vscode').action('workbench.action.focusRightGroup')<cr>", { desc = "Focus Right Window" })
vim.keymap.set("n", "<C-j>", "<cmd>lua require('vscode').action('workbench.action.focusBelowGroup')<cr>", { desc = "Focus Below Window" })
vim.keymap.set("n", "<C-k>", "<cmd>lua require('vscode').action('workbench.action.focusAboveGroup')<cr>", { desc = "Focus Above Window" })

-- Zen Mode & Additional Features
vim.keymap.set("n", "<leader>z", "<cmd>lua require('vscode').action('workbench.action.toggleZenMode')<cr>", { desc = "Toggle Zen Mode" })

-- Quick Save (additional to <leader>w)
vim.keymap.set("n", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<cmd>lua require('vscode').action('workbench.action.files.save')<cr>", { desc = "Save file" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Return empty table since VS Code doesn't need plugin specs
return {}