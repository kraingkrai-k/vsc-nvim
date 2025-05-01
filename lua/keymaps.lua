-- การตั้งค่า key mappings สำหรับ Neovim

-- กำหนด leader key เป็น space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ฟังก์ชันสำหรับการกำหนด keymaps แบบง่าย
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end


-- Paste without overwriting
vim.keymap.set('v', 'p', 'P')

-- Redo
vim.keymap.set('n', 'U', '<C-r>')

-- Clear search highlight
vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')


if vim.g.vscode then
    -- Disable default behavior of 's' in VS Code
    vim.keymap.set('n', 's', '<Nop>')

    -- new 
    -- Navigation shortcuts
    map('n', '<leader>e', "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
    map('n', '<leader>f', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
    map('n', '<leader>g', "<Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>")
    map('n', '<leader>p', "<Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>")

    -- Editor management
    map('n', '<leader>w', "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
    map('n', '<leader>q', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
    map('n', '<leader>n', "<Cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>")
    
    -- Split management
    map('n', '<leader>vs', "<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>")
    map('n', '<leader>vh', "<Cmd>call VSCodeNotify('workbench.action.splitEditorOrthogonal')<CR>")
    map('n', '<leader>h', "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
    map('n', '<leader>l', "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
    map('n', '<leader>k', "<Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>")
    map('n', '<leader>j', "<Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>")

    -- Code actions
    map('n', '<leader>ca', "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
    map('n', '<leader>cr', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")
    map('n', '<leader>cf', "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")
    map('n', '<leader>cd', "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
    map('n', '<leader>ci', "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")
    map('n', '<leader>cu', "<Cmd>call VSCodeNotify('editor.action.findReferences')<CR>")

    -- Terminal
    map('n', '<leader>t', "<Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>")
    
    -- Commenting
    map('n', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")
    map('v', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")

end


-- Common keymaps (ใช้ได้ทั้งใน VS Code และ Neovim ปกติ)

-- พื้นฐาน
map('n', '<leader><leader>', ':nohlsearch<CR>')  -- ยกเลิกการไฮไลท์ผลการค้นหา
map('n', '<ESC>', ':nohlsearch<CR>')            -- กด ESC เพื่อยกเลิกการไฮไลท์

-- การเลื่อน
map('n', '<C-d>', '<C-d>zz')                    -- เลื่อนลงครึ่งหน้าจอและให้เคอร์เซอร์อยู่ตรงกลาง
map('n', '<C-u>', '<C-u>zz')                    -- เลื่อนขึ้นครึ่งหน้าจอและให้เคอร์เซอร์อยู่ตรงกลาง
map('n', 'n', 'nzzzv')                          -- การค้นหาถัดไปและให้ผลอยู่ตรงกลาง
map('n', 'N', 'Nzzzv')                          -- การค้นหาก่อนหน้าและให้ผลอยู่ตรงกลาง

-- การเลือกและคัดลอก
map('v', 'J', ":m '>+1<CR>gv=gv")               -- ย้ายบล็อกที่เลือกลง
map('v', 'K', ":m '<-2<CR>gv=gv")               -- ย้ายบล็อกที่เลือกขึ้น
map('n', 'Y', 'y$')                             -- Y คัดลอกถึงท้ายบรรทัด (เหมือน D และ C)
map('v', '<', '<gv')                            -- เยื้องซ้ายและยังคงเลือก
map('v', '>', '>gv')                            -- เยื้องขวาและยังคงเลือก

-- การแก้ไข
map('n', 'J', 'mzJ`z')                          -- J รวมบรรทัดแต่คงตำแหน่งเคอร์เซอร์
map('i', ',', ',<C-g>u')                        -- ทำให้ , เป็นจุด undo break
map('i', '.', '.<C-g>u')                        -- ทำให้ . เป็นจุด undo break
map('i', '!', '!<C-g>u')                        -- ทำให้ ! เป็นจุด undo break
map('i', '?', '?<C-g>u')                        -- ทำให้ ? เป็นจุด undo break

-- แทนที่คำที่เลือกไว้ด้วยบัฟเฟอร์
map('x', '<leader>p', '"_dP')                    -- แทนที่โดยไม่ copy ทับ register

-- ลบไปยัง black hole register (ไม่กระทบ clipboard)
map('n', '<leader>d', '"_d')
map('v', '<leader>d', '"_d')