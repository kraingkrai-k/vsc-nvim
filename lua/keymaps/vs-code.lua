local vscode = require('vscode')

local c = vim.keymap.set

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
  