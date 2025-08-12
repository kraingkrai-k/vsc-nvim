-- Modern keymaps configuration with enhanced utilities
local keymap_utils = require("utils.keymaps")
local utils = require("utils.init")

-- Use the enhanced keymap utility
local keymap = keymap_utils.set

-- Set up basic navigation and editing keymaps
keymap_utils.setup_navigation_keymaps()
keymap_utils.setup_editing_keymaps()

-- Clear search highlighting
keymap("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Better movement
keymap("n", "H", "0", { desc = "Go to beginning of line" })
keymap("n", "L", "$", { desc = "Go to end of line" })
keymap("n", "gm", "%", { desc = "Go to matching bracket" })
keymap("v", "gm", "%", { desc = "Go to matching bracket" })

-- Better line joining
keymap("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
keymap("n", "K", "kJ", { desc = "Join with line above" })

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

-- ReplaceWithRegister plugin mappings (will be loaded conditionally)
keymap("n", "<leader>rr", "<Plug>ReplaceWithRegisterLine", { desc = "Replace line with register" })
keymap("n", "<leader>r", "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register operator" })
keymap("v", "<leader>r", "<Plug>ReplaceWithRegisterVisual", { desc = "Replace selection with register" })

-- Environment-specific keymaps
if _G.nvim_config.env.is_vscode then
  -- VS Code specific keymaps
  
  -- Disable default behavior of 's' in VS Code
  keymap("n", "s", "<Nop>", { desc = "Disabled in VS Code" })

  -- File operations
  keymap("n", "<leader>w", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>", { desc = "Save file" })
  keymap("n", "<leader>q", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", { desc = "Close editor" })
  keymap("n", "<leader>n", "<Cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>", { desc = "New file" })
  
  -- Explorer
  keymap("n", "<leader>es", "<Cmd>call VSCodeNotify('explorer.openToSide')<CR>", { desc = "Open file to side" })
  keymap("n", "<leader>ef", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR><Cmd>call VSCodeNotify('list.find')<CR>", { desc = "Explorer filter" })
  
  -- Commenting
  keymap("n", "<leader>/", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>", { desc = "Toggle comment" })
  keymap("v", "<leader>/", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>", { desc = "Toggle comment" })

  -- Multi-cursor
  keymap("n", "<leader>d", "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>", { desc = "Add selection to next match" })
  keymap("v", "<leader>d", "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>", { desc = "Add selection to next match" })
  keymap("v", "<leader>a", "<Cmd>call VSCodeNotify('editor.action.selectHighlights')<CR>", { desc = "Select all matches" })
  
  -- Window management
  keymap("n", "<leader>wv", "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>", { desc = "Split right" })
  keymap("n", "<leader>wh", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>", { desc = "Split down" })
  keymap("n", "<leader>wn", "<Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>", { desc = "Focus next group" })
  keymap("n", "<leader>wo", "<Cmd>call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')<CR>", { desc = "Close other groups" })
  keymap("n", "<leader>wc", "<Cmd>call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>", { desc = "Close group" })
  keymap("n", "<leader>wm", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToNextGroup')<CR>", { desc = "Move to next group" })
  keymap("n", "<leader>wp", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToPreviousGroup')<CR>", { desc = "Move to previous group" })

  -- LSP & Code Navigation
  keymap("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { desc = "Go to definition" })
  keymap("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", { desc = "Go to references" })
  keymap("n", "K", "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>", { desc = "Show hover" })
  keymap("n", "<leader>rn", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>", { desc = "Rename symbol" })
  keymap("n", "<leader>ca", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>", { desc = "Code actions" })
  
  -- Git Integration
  keymap("n", "<leader>gd", "<Cmd>call VSCodeNotify('git.openChange')<CR>", { desc = "Git diff" })
  keymap("n", "<leader>gb", "<Cmd>call VSCodeNotify('gitlens.toggleFileBlame')<CR>", { desc = "Git blame" })
  keymap("n", "<leader>gs", "<Cmd>call VSCodeNotify('workbench.view.scm')<CR>", { desc = "Git status" })
  
  -- Buffer Management
  keymap("n", "<leader>bd", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", { desc = "Close buffer" })
  keymap("n", "<leader>ba", "<Cmd>call VSCodeNotify('workbench.action.closeAllEditors')<CR>", { desc = "Close all buffers" })
  
  -- Search & Replace
  keymap("n", "<leader>ss", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", { desc = "Search in files" })
  keymap("n", "<leader>sr", "<Cmd>call VSCodeNotify('workbench.action.replaceInFiles')<CR>", { desc = "Replace in files" })
  
  -- Diagnostics
  keymap("n", "<leader>xx", "<Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>", { desc = "Show problems" })

  -- Focus modes
  keymap("n", "<leader>z", "<Cmd>call VSCodeNotify('workbench.action.toggleZenMode')<CR>", { desc = "Toggle Zen mode" })
  keymap("n", "<leader>cl", "<Cmd>call VSCodeNotify('workbench.action.toggleCenteredLayout')<CR>", { desc = "Toggle centered layout" })

  -- Project Manager
  keymap("n", "<leader>pp", "<Cmd>call VSCodeNotify('projectManager.listProjects')<CR>", { desc = "List projects" })
  keymap("n", "<leader>ps", "<Cmd>call VSCodeNotify('projectManager.saveProject')<CR>", { desc = "Save project" })
  keymap("n", "<leader>pn", "<Cmd>call VSCodeNotify('projectManager.listProjectsNewWindow')<CR>", { desc = "Open project in new window" })
  keymap("n", "<leader>pv", "<Cmd>call VSCodeNotify('workbench.view.extension.project-manager')<CR>", { desc = "Project manager view" })

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