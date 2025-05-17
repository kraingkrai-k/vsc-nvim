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

-- vim.keymap.set('n', '\'', ';')


if vim.g.vscode then
    -- Disable default behavior of 's' in VS Code
    vim.keymap.set('n', 's', '<Nop>')

    -- Navigation shortcuts
    map('n', '<leader>f', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
    map('n', '<leader>g', "<Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>")
    map('n', '<leader>e', "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
    -- Toggle side bar
    map('n', '<leader>b', "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>")
    -- เปิด/ปิด Outline
    map('n', '<leader>o', "<Cmd>call VSCodeNotify('outline.focus')<CR>")
    -- Quick Open (เปิด Go to File dialog)
    map('n', '<leader>p', "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
    -- Open Explorer and Focus file currently open:
    map('n', '<leader>er', "<Cmd>call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>")
    -- การแสดง Explorer และเริ่มการค้นหาทันที (ช่วยในการกรองไฟล์เร็วๆ):
    map('n', '<leader>ef', "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR><Cmd>call VSCodeNotify('filesExplorer.findInFolder')<CR>")
    -- การเปิดไฟล์ที่เลือกในหน้าต่างแยก:
    map('n', '<leader>es', "<Cmd>call VSCodeNotify('explorer.openToSide')<CR>")
    -- Editor management
    map('n', '<leader>w', "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
    map('n', '<leader>q', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
    map('n', '<leader>n', "<Cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>")
    
    -- Code actions
    map('n', '<leader>ca', "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
    map('n', '<leader>cr', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")
    map('n', '<leader>cf', "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")
    map('n', '<leader>cd', "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
    map('n', '<leader>ci', "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")
    map('n', '<leader>cu', "<Cmd>call VSCodeNotify('editor.action.findReferences')<CR>")

    -- Terminal
    -- use cmd + j for toggle terminal instead
    map('n', '<leader>t', "<Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>")
    -- ซ่อน terminal panel และกลับไปยังตำแหน่งเดิมในโค้ด (เหมือน Cmd+J)
 
    -- Commenting
    map('n', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")
    map('v', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")

    -- เลือกทุกที่ที่เหมือนกับคำที่เลือก (⌘+D ใน macOS)
    map('n', '<leader>d', "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>")
    map('v', '<leader>d', "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>")

    -- เลือกทุกที่ที่เหมือนกัน (⇧+⌘+L ใน macOS, หรือ ⌘+F2)
    map('n', '<leader>a', "<Cmd>call VSCodeNotify('editor.action.selectHighlights')<CR>")
    map('v', '<leader>a', "<Cmd>call VSCodeNotify('editor.action.selectHighlights')<CR>")

    map('n', '<leader>[', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
    map('n', '<leader>]', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
    
    -- window command
    -- สร้าง editor group ใหม่ทางขวา
    map('n', '<leader>wv', "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>")
    -- สร้าง editor group ใหม่ทางล่าง
    map('n', '<leader>wh', "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
    -- สลับไปยัง editor group ถัดไป
    map('n', '<leader>wn', "<Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>")
    -- ปิด editor group อื่นๆ (เหลือแค่ปัจจุบัน)
    map('n', '<leader>wo', "<Cmd>call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')<CR>")
    -- ปิด editor group ปัจจุบัน
    map('n', '<leader>wc', "<Cmd>call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>")
    -- ย้ายไฟล์ไปยัง editor group ถัดไป
    map('n', '<leader>wm', "<Cmd>call VSCodeNotify('workbench.action.moveEditorToNextGroup')<CR>")
    -- สลับไปยัง editor group ก่อนหน้า
    map('n', '<leader>wp', "<Cmd>call VSCodeNotify('workbench.action.moveEditorToPreviousGroup')<CR>")

    -- Breadcrumbs
    -- เปิด/เลือก Breadcrumbs
    -- map('n', '<leader>bb', "<Cmd>call VSCodeNotify('breadcrumbs.focusAndSelect')<CR>")
    -- -- นำทางไปยัง parent symbol
    -- map('n', '<leader>bp', "<Cmd>call VSCodeNotify('breadcrumbs.focusPrevious')<CR>")
    -- -- นำทางไปยัง child symbol
    -- map('n', '<leader>bn', "<Cmd>call VSCodeNotify('breadcrumbs.focusNext')<CR>")
    -- -- แสดง siblings ของ symbol ปัจจุบัน
    -- map('n', '<leader>bs', "<Cmd>call VSCodeNotify('breadcrumbs.revealFocused')<CR>")

    -- Zen Mode & Focus Mode
    -- เปิด/ปิด Zen Mode (เต็มหน้าจอ, ไม่มี UI elements)
    map('n', '<leader>z', "<Cmd>call VSCodeNotify('workbench.action.toggleZenMode')<CR>")
    -- เปิด/ปิด Centered Layout
    map('n', '<leader>cl', "<Cmd>call VSCodeNotify('workbench.action.toggleCenteredLayout')<CR>")
    -- ซ่อน/แสดง Activity Bar
    map('n', '<leader>ha', "<Cmd>call VSCodeNotify('workbench.action.toggleActivityBarVisibility')<CR>")

    -- extension project manager
    -- เปิดรายการโปรเจค
    map('n', '<leader>pp', "<Cmd>call VSCodeNotify('projectManager.listProjects')<CR>")
    -- บันทึกโปรเจคปัจจุบัน
    map('n', '<leader>ps', "<Cmd>call VSCodeNotify('projectManager.saveProject')<CR>")
    -- เปิดโปรเจคในหน้าต่างใหม่
    map('n', '<leader>pn', "<Cmd>call VSCodeNotify('projectManager.listProjectsNewWindow')<CR>")
    -- ดูโปรเจคทั้งหมดใน sidebar
    map('n', '<leader>pv', "<Cmd>call VSCodeNotify('workbench.view.extension.project-manager')<CR>")
end

map('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine')
map('n', '<leader>r', '<Plug>ReplaceWithRegisterOperator')
map('v', '<leader>r', '<Plug>ReplaceWithRegisterVisual')

-- Common keymaps (ใช้ได้ทั้งใน VS Code และ Neovim ปกติ)

-- พื้นฐาน
-- map('n', '<leader><leader>', ':nohlsearch<CR>')  -- ยกเลิกการไฮไลท์ผลการค้นหา
-- map('n', '<ESC>', ':nohlsearch<CR>')            -- กด ESC เพื่อยกเลิกการไฮไลท์
-- map('n', '<ESC><ESC>', ':nohlsearch<CR>')            -- กด ESC เพื่อยกเลิกการไฮไลท์
map('n', '<ESC><ESC>', ':nohl<CR>')            -- กด ESC เพื่อยกเลิกการไฮไลท์

-- Clear search highlight
-- vim.keymap.set('n', '<Esc><Esc>', ':nohl<CR>')


-- การเลื่อน
map('n', '<C-d>', '<C-d>zz')                    -- เลื่อนลงครึ่งหน้าจอและให้เคอร์เซอร์อยู่ตรงกลาง
map('n', '<C-u>', '<C-u>zz')                    -- เลื่อนขึ้นครึ่งหน้าจอและให้เคอร์เซอร์อยู่ตรงกลาง
map('n', 'n', 'nzzzv')                          -- การค้นหาถัดไปและให้ผลอยู่ตรงกลาง
map('n', 'N', 'Nzzzv')                          -- การค้นหาก่อนหน้าและให้ผลอยู่ตรงกลาง
map('n', 'H', '0')
map('n', 'L', '$')

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
-- map('n', '<leader>d', '"_d')
-- map('v', '<leader>d', '"_d')