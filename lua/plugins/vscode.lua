-- VS Code specific keymaps (LazyVim standard keys)

if not vim.g.vscode then
  return {}
end

local vscode = require("vscode")

-- File explorer
vim.keymap.set("n", "<leader>e", function() vscode.action("workbench.view.explorer") end, { desc = "Explorer" })

-- Find (LazyVim standard)
vim.keymap.set("n", "<leader>ff", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() vscode.action("workbench.action.findInFiles") end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function() vscode.action("workbench.action.showAllEditors") end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", function() vscode.action("workbench.action.openRecent") end, { desc = "Recent files" })

-- Git
vim.keymap.set("n", "<leader>gg", function() vscode.action("workbench.view.scm") end, { desc = "Git (SCM)" })
vim.keymap.set("n", "<leader>gd", function() vscode.action("git.openChange") end, { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", function() vscode.action("gitlens.toggleFileBlame") end, { desc = "Git blame" })

-- Git hunks
vim.keymap.set("n", "]c", function() vscode.action("workbench.action.editor.nextChange") end, { desc = "Next hunk" })
vim.keymap.set("n", "[c", function() vscode.action("workbench.action.editor.previousChange") end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hs", function() vscode.action("git.stageSelectedRanges") end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function() vscode.action("git.revertSelectedRanges") end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", function() vscode.action("editor.action.dirtydiff.previous") end, { desc = "Preview hunk" })

-- Window management (LazyVim standard)
vim.keymap.set("n", "<leader>|", function() vscode.action("workbench.action.splitEditorRight") end, { desc = "Split vertical" })
vim.keymap.set("n", "<leader>-", function() vscode.action("workbench.action.splitEditorDown") end, { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wd", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close window" })

-- Window navigation
vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.focusLeftGroup") end, { desc = "Focus left" })
vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.focusRightGroup") end, { desc = "Focus right" })
vim.keymap.set("n", "<C-j>", function() vscode.action("workbench.action.focusBelowGroup") end, { desc = "Focus below" })
vim.keymap.set("n", "<C-k>", function() vscode.action("workbench.action.focusAboveGroup") end, { desc = "Focus above" })

-- LSP actions (LazyVim standard)
vim.keymap.set("n", "<leader>cr", function() vscode.action("editor.action.rename") end, { desc = "Rename" })
vim.keymap.set("n", "<leader>ca", function() vscode.action("editor.action.quickFix") end, { desc = "Code action" })
vim.keymap.set("n", "<leader>cf", function() vscode.action("editor.action.formatDocument") end, { desc = "Format" })
vim.keymap.set("n", "<leader>cd", function() vscode.action("editor.action.marker.next") end, { desc = "Line diagnostics" })

-- VS Code unique features
vim.keymap.set("n", "<leader>fp", function() vscode.action("projectManager.listProjects") end, { desc = "Projects" })
vim.keymap.set("n", "<leader>z", function() vscode.action("workbench.action.toggleZenMode") end, { desc = "Zen mode" })
vim.keymap.set("n", "gp", function() vscode.action("editor.action.peekDefinition") end, { desc = "Peek definition" })
vim.keymap.set("n", "<leader><leader>", function() vscode.action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup") end, { desc = "Toggle recent file" })
vim.keymap.set("n", "<leader>o", function() vscode.action("workbench.action.gotoSymbol") end, { desc = "Go to symbol" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear hlsearch" })

return {}
