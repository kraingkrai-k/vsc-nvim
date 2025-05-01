
-- โหลดการตั้งค่าจากโมดูลต่างๆ
require('options')  -- การตั้งค่าทั่วไป
require('keymaps')  -- key mappings

-- ไฟล์หลักสำหรับการตั้งค่า Neovim
vim.cmd [[
  call plug#begin('~/.local/share/nvim/plugged')
  
  Plug 'tpope/vim-surround'               " จัดการกับวงเล็บและเครื่องหมายรอบข้อความ
  Plug 'tpope/vim-repeat'                 " ทำให้ . สามารถทำซ้ำคำสั่งจาก plugin ได้
  Plug 'vim-scripts/ReplaceWithRegister'  " แทนที่ด้วย register (gr)
  Plug 'phaazon/hop.nvim'                 " การเคลื่อนที่แบบ easymotion
  

  call plug#end()
]]

if pcall(require, 'hop') then
    -- ตั้งค่า hop.nvim ให้ทำงานเร็วขึ้น
    -- require('hop').setup({
    --     multi_windows = false,
    -- })
    require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran', -- ตัวอักษรที่พบบ่อยและกดง่ายขึ้นก่อน
        jump_on_sole_occurrence = true,    -- กระโดดทันทีถ้ามีผลลัพธ์เดียว
        case_insensitive = true,           -- ไม่สนใจตัวพิมพ์ใหญ่/เล็ก
        multi_windows = false,             -- จำกัดขอบเขตเฉพาะหน้าต่างปัจจุบัน
        current_line_only = false,         -- ค้นหาทั่วทั้งหน้าจอ (ตั้งเป็น true เพื่อความเร็วเพิ่มเติม)
        uppercase_labels = true,           -- ใช้ตัวพิมพ์ใหญ่สำหรับฉลาก (มองเห็นง่ายขึ้น)
        teasing = false,                   -- ลดเอฟเฟกต์ต่างๆ เพื่อความเร็ว
    })
    
    vim.cmd([[
        " สีที่เข้ากับ One Dark Pro (Dark Theme)
        highlight HopNextKey guifg=#c678dd gui=bold ctermfg=198 cterm=bold
        highlight HopNextKey1 guifg=#56b6c2 gui=bold ctermfg=45 cterm=bold
        highlight HopNextKey2 guifg=#61afef ctermfg=33
        highlight HopUnmatched guifg=#5c6370 ctermfg=242
    ]])
    
    vim.api.nvim_set_keymap('n', '<space><space>w', "<cmd>HopWord<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space><space>l', "<cmd>HopLine<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space><space>c', "<cmd>HopChar1<CR>", { noremap = true, silent = true })
    
     -- เพิ่ม key mappings ที่มีประโยชน์
    vim.api.nvim_set_keymap('n', '<space><space>/', "<cmd>HopPattern<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space><space>j', "<cmd>HopLineAC<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space><space>k', "<cmd>HopLineBC<CR>", { noremap = true, silent = true })

     -- คำสั่งสำหรับการค้นหาเฉพาะบรรทัดปัจจุบัน (เร็วกว่า)
    vim.api.nvim_set_keymap('n', '<space><space>f', "<cmd>lua require('hop').hint_char1({ current_line_only = true })<CR>", { noremap = true, silent = true })

    -- คำสั่งสำหรับการค้นหาในช่วงที่มองเห็นเท่านั้น (เร็วกว่า)
    vim.api.nvim_set_keymap('n', '<space><space>v', "<cmd>lua require('hop').hint_words({ current_line_only = false, hint_position = require('hop.hint').HintPosition.END })<CR>", { noremap = true, silent = true })

    vim.notify("hop.nvim loaded successfully!")
else
    vim.notify("Failed to load hop.nvim")
end

-- ถ้าอยู่ใน VS Code ให้โหลดการตั้งค่าเฉพาะสำหรับ VS Code
if vim.g.vscode then
    
    -- การตั้งค่าเฉพาะสำหรับเมื่อใช้ใน VS Code
    vim.notify("Neovim running inside VS Code")
    print("HI KK :)")
end
