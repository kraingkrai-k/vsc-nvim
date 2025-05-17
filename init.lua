
require('options')
require('keymaps')

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
    
    vim.api.nvim_set_keymap('n', '<space>hw', "<cmd>HopWord<CR>", { noremap = true, silent = true })
    -- จำกัดขอบเขตของการค้นหาให้เล็กลง
    -- vim.api.nvim_set_keymap('n', '<space><space>w', "<cmd>lua require('hop').hint_words({ upper_case = true, hint_offset = 0, max_lines = 25 })<CR>", { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '<space>hl', "<cmd>HopLine<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space>hc', "<cmd>HopChar1<CR>", { noremap = true, silent = true })
    
     -- เพิ่ม key mappings ที่มีประโยชน์
    vim.api.nvim_set_keymap('n', '<space>h/', "<cmd>HopPattern<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space>hj', "<cmd>HopLineAC<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<space>hk', "<cmd>HopLineBC<CR>", { noremap = true, silent = true })

     -- คำสั่งสำหรับการค้นหาเฉพาะบรรทัดปัจจุบัน (เร็วกว่า)
    vim.api.nvim_set_keymap('n', '<space>hf', "<cmd>lua require('hop').hint_char1({ current_line_only = true })<CR>", { noremap = true, silent = true })

    -- คำสั่งสำหรับการค้นหาในช่วงที่มองเห็นเท่านั้น (เร็วกว่า)
    vim.api.nvim_set_keymap('n', '<space>hv', "<cmd>lua require('hop').hint_words({ current_line_only = false, hint_position = require('hop.hint').HintPosition.END })<CR>", { noremap = true, silent = true })

    vim.notify("hop.nvim loaded successfully!")
else
    vim.notify("Failed to load hop.nvim")
end

if vim.g.vscode then
    vim.notify("HI KK, Enjoy Coding :)")
end
