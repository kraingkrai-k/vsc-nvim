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

    -- การเปิดไฟล์ที่เลือกในหน้าต่างแยก:
    map('n', '<leader>es', "<Cmd>call VSCodeNotify('explorer.openToSide')<CR>")
    -- Editor management
    map('n', '<leader>w', "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
    map('n', '<leader>q', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
    map('n', '<leader>n', "<Cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>")
    
 
    -- Commenting
    map('n', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")
    map('v', '<leader>/', "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")

    -- เลือกทุกที่ที่เหมือนกับคำที่เลือก (⌘+D ใน macOS)
    map('n', '<leader>d', "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>")
    map('v', '<leader>d', "<Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>")

    -- เลือกทุกที่ที่เหมือนกัน (⇧+⌘+L ใน macOS, หรือ ⌘+F2)
    map('n', '<leader>a', "<Cmd>call VSCodeNotify('editor.action.selectHighlights')<CR>")
    map('v', '<leader>a', "<Cmd>call VSCodeNotify('editor.action.selectHighlights')<CR>")
    
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

    -- LSP & Code Navigation
    map('n', 'gd', "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
    map('n', 'gr', "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")
    map('n', 'K', "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>")
    map('n', '<leader>rn', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")
    map('n', '<leader>ca', "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
    
    -- Git Integration
    map('n', '<leader>gd', "<Cmd>call VSCodeNotify('git.openChange')<CR>")
    map('n', '<leader>gb', "<Cmd>call VSCodeNotify('gitlens.toggleFileBlame')<CR>")
    map('n', '<leader>gs', "<Cmd>call VSCodeNotify('workbench.view.scm')<CR>")
    
    -- Buffer Management
    map('n', '<leader>bd', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
    map('n', '<leader>ba', "<Cmd>call VSCodeNotify('workbench.action.closeAllEditors')<CR>")
    
    -- Search & Replace
    map('n', '<leader>ss', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
    map('n', '<leader>sr', "<Cmd>call VSCodeNotify('workbench.action.replaceInFiles')<CR>")
    
    -- Fast Navigation & Symbol Search
    -- ค้นหา symbol ในไฟล์ปัจจุบัน (@ symbol)
    map('n', '<leader>@', "<Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>")
    -- ค้นหา symbol ในทั้งโปรเจค (# symbol)
    map('n', '<leader>#', "<Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>")
    -- เปิด outline/symbol view
    map('n', '<leader>o', "<Cmd>call VSCodeNotify('outline.focus')<CR>")
    
    -- Fast Scrolling
    -- เลื่อนหน้าจอเร็ว (5 บรรทัด)
    map('n', '<C-j>', '5j')
    map('n', '<C-k>', '5k')
    -- เลื่อนหน้าจอไปหน้า/หลัง
    map('n', '<C-f>', '<C-f>zz')
    map('n', '<C-b>', '<C-b>zz')
    -- เลื่อนไปต้นและท้ายไฟล์
    map('n', 'gg', 'ggzz')
    map('n', 'G', 'Gzz')
    
    -- Diagnostic Navigation
    map('n', '<leader>xx', "<Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>")

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
    
    -- Explorer Filter
    -- เปิด explorer และ filter ไฟล์ทันที
    map('n', '<leader>ef', "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR><Cmd>call VSCodeNotify('list.find')<CR>")
    -- เปิด explorer และเปิด filter ไฟล์
    -- filter ไฟล์ใน explorer (เมื่ออยู่ใน explorer อยู่แล้ว)
    map('n', '<leader>ff', "<Cmd>call VSCodeNotify('list.find')<CR>")
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
map('n', 'H', '0')                              -- H ไปต้นบรรทัด
map('n', 'L', '$')                              -- L ไปท้ายบรรทัด
map('n', 'gm', '%')                             -- gm ไปยัง matching bracket
map('v', 'gm', '%')                             -- gm ไปยัง matching bracket ใน visual mode

-- Quick Movement เพิ่มเติม
map('n', '<C-o>', '<C-o>')                      -- กลับไปตำแหน่งก่อนหน้า
map('n', '<C-i>', '<C-i>')                      -- ไปตำแหน่งถัดไป
map('n', "''", "''")                            -- กลับตำแหน่งเดิม

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
