local c = vim.keymap.set

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

