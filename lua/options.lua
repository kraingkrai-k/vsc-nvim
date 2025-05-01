-- options.lua
-- การตั้งค่าทั่วไปสำหรับ Neovim

-- การตั้งค่าพื้นฐาน
vim.opt.number = true           -- แสดงเลขบรรทัด
vim.opt.relativenumber = true   -- แสดงเลขบรรทัดแบบสัมพัทธ์
vim.opt.ignorecase = true       -- ค้นหาไม่สนใจตัวพิมพ์ใหญ่/เล็ก
vim.opt.smartcase = true        -- ยกเว้นเมื่อมีตัวพิมพ์ใหญ่ในคำค้นหา
vim.opt.hlsearch = true         -- ไฮไลท์ผลการค้นหา
vim.opt.incsearch = true        -- แสดงผลการค้นหาทันทีขณะพิมพ์
vim.opt.scrolloff = 8           -- เก็บบรรทัด 8 บรรทัดไว้เสมอเมื่อเลื่อน
vim.opt.sidescrolloff = 8       -- เก็บคอลัมน์ 8 คอลัมน์ไว้เสมอเมื่อเลื่อนแนวนอน
vim.opt.clipboard = "unnamedplus" -- เชื่อมต่อกับคลิปบอร์ดของระบบ
vim.opt.wrap = false            -- ไม่ต้องม้วนข้อความยาว
vim.opt.cursorline = true       -- ไฮไลท์บรรทัดที่เคอร์เซอร์อยู่


-- font
vim.g.have_nerd_font = true     -- ใช้ Nerd Font


-- การตั้งค่า indentation
vim.opt.tabstop = 4             -- จำนวน space ที่ tab แสดง
vim.opt.softtabstop = 4         -- จำนวน space ที่ถูกแทรกเมื่อกด tab
vim.opt.shiftwidth = 4          -- จำนวน space สำหรับ indentation
vim.opt.expandtab = true        -- แปลง tab เป็น spaces
vim.opt.smartindent = true      -- ทำ indentation อัตโนมัติ

-- ถ้าใช้ใน VS Code ให้ปรับแต่งการตั้งค่าบางอย่าง
if vim.g.vscode then
    -- ปิดการตั้งค่าที่อาจขัดแย้งกับ VS Code
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.cursorline = false
end