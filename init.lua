print("HI KK :)")

-- -- Enable line numbers
-- vim.opt.number = true
-- vim.opt.relativenumber = true

-- -- Enable mouse support
-- vim.opt.mouse = 'a'

-- -- Enable auto-indentation and smart indent
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- -- Show matching parentheses
-- vim.opt.showmatch = true

-- -- Enable persistent undo
-- vim.opt.undofile = true

-- Set wildmenu for command-line completion
-- vim.opt.wildmenu = true

-- CMD key for system clipboard sync
vim.opt.clipboard = 'unnamedplus'

-- search ignore case
vim.opt.ignorecase = true
vim.opt.smartcase = true


local c = vim.keymap.set

vim.g.mapleader = ' '

-- Remap 's' for splitting windows
c('n', 's', '<Nop>') -- Disable the default behavior of 's'

-- Repeat
c('n', '\'', ';')

-- Paste without overwriting
c('v', 'p', 'P')

-- Redo
c('n', 'U', '<C-r>')

-- Clear search highlight
c('n', '<Esc>', ':nohlsearch<cr>')



local vscode = require('vscode')

-- Vertical split (similar to :vsplit in VS Code)
c('n', '<leader>sv', function() vscode.call('workbench.action.splitEditor') end)

-- Focus next editor group (move to the right split)
c('n', '<leader>l', function() vscode.call('workbench.action.focusNextGroup') end)

-- Focus previous editor group (move to the left split)
c('n', '<leader>h', function() vscode.call('workbench.action.focusPreviousGroup') end)


c("n", "<leader>p1", function()
    vim.fn.system("code /path/to/project1")  -- Open project 1 in a new VS Code window
  end)
  
c("n", "<leader>p2", function()
    vim.fn.system("code /path/to/project2")  -- Open project 2 in a new VS Code window
end)
  
c("n", "<leader>p3", function()
    vim.fn.system("code /path/to/project3")  -- Open project 3 in a new VS Code window
end)
  