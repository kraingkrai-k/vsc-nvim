# 🚀 Ultra Simple Neovim Configuration

> การกำหนดค่า Neovim แบบ minimal ที่เน้น VS Code เป็นหลัก เพื่อประสิทธิภาพและความเสถียร

A minimal, performance-focused Neovim configuration designed primarily for **VS Code** integration with essential plugins for enhanced productivity.

## ✨ Features

- 🎯 **VS Code First**: Optimized primarily for VS Code Neovim extension
- ⚡ **Ultra Fast**: Single file configuration with minimal plugins
- 🔧 **Essential Tools**: Only 5 carefully selected plugins for maximum productivity
- 🚀 **Instant Startup**: No delays or lag
- 📱 **Standalone Ready**: Basic fallback for standalone Neovim

## 🚀 Quick Start

### Prerequisites

```bash
# Install Neovim (0.8+ required)
brew install neovim  # macOS
# or
sudo apt install neovim  # Ubuntu/Debian
# or
winget install Neovim.Neovim  # Windows

# Install a Nerd Font (recommended)
brew install font-jetbrains-mono-nerd-font  # macOS
```

### Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/kraingkrai-k/vsc-nvim.git ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### VS Code Setup (Primary Use Case)

1. Install the [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

### Standalone Neovim

Works out of the box with basic configuration. More features can be added as needed.

## 📋 Cheat Sheet & Plugin Guide

### 🎯 Leader Key

- `<Space>` - Leader key สำหรับ commands หลัก

### 📁 File Operations

| Key         | Action     | Description           |
| ----------- | ---------- | --------------------- |
| `<leader>w` | Save file  | บันทึกไฟล์            |
| `<leader>q` | Close/Quit | ปิดไฟล์หรือออกจาก vim |

### 🚀 Flash.nvim - Super Fast Navigation

> เปลี่ยนวิธีการ navigate ใหม่หมด! ไม่ต้องนับบรรทัดหรือกด j/k หลายครั้ง

| Key | Action     | Description                                      |
| --- | ---------- | ------------------------------------------------ |
| `s` | Flash Jump | กระโดดไปที่ข้อความใดก็ได้บนหน้าจอด้วย 2 ตัวอักษร |

**วิธีใช้ Flash:**

1. กด `s`
2. พิมพ์ 2 ตัวอักษรแรกของคำที่ต้องการไป
3. กระโดดไปทันที!

**ตัวอย่าง:**

```javascript
const fetchUserData = () => {
  // s + "fe" → ไปที่ fetch
  if (userProfile) {
    // s + "if" → ไปที่ if
    return userData; // s + "re" → ไปที่ return
  }
};
```

### 🕷️ Spider.nvim - Smart Word Movement

> การเคลื่อนย้ายคำแบบ smart สำหรับ camelCase และ snake_case

| Key | Action        | Description                            |
| --- | ------------- | -------------------------------------- |
| `w` | Next word     | ไปคำถัดไปแบบ smart (หยุดที่ camelCase) |
| `e` | End of word   | ไปจบคำแบบ smart                        |
| `b` | Previous word | ไปคำก่อนหน้าแบบ smart                  |

**ตัวอย่างการใช้งาน:**

```javascript
// ปกติ: w จะข้ามไปจบคำเลย
// Spider: w จะหยุดที่แต่ละส่วนของ camelCase
const getUserProfileData = () => {};
//    ↑    ↑       ↑    ↑      cursor stops ที่แต่ละตำแหน่ง

// ใช้กับ commands อื่น:
dw; // Delete word (smart)
cw; // Change word (smart)
vw; // Visual select word (smart)
```

### 🔄 Comment.nvim - Comment Toggle

| Key   | Mode   | Action               | Description                      |
| ----- | ------ | -------------------- | -------------------------------- |
| `gcc` | Normal | Toggle line comment  | Comment/uncomment บรรทัดปัจจุบัน |
| `gc`  | Visual | Toggle block comment | Comment/uncomment หลายบรรทัด     |

**ตัวอย่าง:**

```javascript
console.log("Hello"); // กด gcc
// console.log("Hello");  // กลายเป็น comment

// เลือกหลายบรรทัดด้วย Visual mode แล้วกด gc
```

### 🎯 vim-surround - Text Object Manipulation

> จัดการ quotes, brackets, tags ได้อย่างรวดเร็ว

| Command            | Action          | Description             |
| ------------------ | --------------- | ----------------------- |
| `ys{motion}{char}` | Add surround    | ครอบข้อความด้วยตัวอักษร |
| `cs{old}{new}`     | Change surround | เปลี่ยนตัวครอบ          |
| `ds{char}`         | Delete surround | ลบตัวครอบออก            |

**ตัวอย่างการใช้งาน:**

```javascript
// Add surround
hello world          // cursor บน hello
ysw"                 // "hello" world (surround word with ")
yss)                 // (hello world) (surround line with ())

// Change surround
"hello world"        // cursor ที่ไหนก็ได้ในบรรทัด
cs"'                 // 'hello world' (เปลี่ยนจาก " เป็น ')
cs'<em>              // <em>hello world</em> (เปลี่ยนเป็น tag)

// Delete surround
'hello world'        // cursor ที่ไหนก็ได้ในบรรทัด
ds'                  // hello world (ลบ ' ออก)
```

### 🔗 nvim-autopairs - Auto Complete Pairs

> เติม brackets, quotes อัตโนมัติ

| Input | Result | Description                 |
| ----- | ------ | --------------------------- |
| `(`   | `()`   | เติม closing bracket        |
| `[`   | `[]`   | เติม closing square bracket |
| `{`   | `{}`   | เติม closing curly bracket  |
| `"`   | `""`   | เติม closing quote          |
| `'`   | `''`   | เติม closing single quote   |

### 🔧 Enhanced Editing (Built-in Improvements)

| Key         | Action                  | Description                     |
| ----------- | ----------------------- | ------------------------------- |
| `gm`        | Go to matching bracket  | ไปที่ bracket คู่               |
| `Y`         | Yank to end of line     | copy จาก cursor ถึงจบบรรทัด     |
| `<leader>p` | Paste (no overwrite)    | paste โดยไม่เขียนทับ register   |
| `<leader>s` | Substitute character    | แทนที่ตัวอักษร (ทดแทน `s` เดิม) |
| `<` / `>`   | Indent (stays selected) | เยื้องและคงการเลือกไว้          |

### 💻 VS Code Integration

| Key         | Action                | Description       |
| ----------- | --------------------- | ----------------- |
| `<leader>v` | Split editor vertical | แบ่งหน้าจอแนวตั้ง |
| `<leader>h` | Focus left editor     | โฟกัสไปหน้าจอซ้าย |
| `<leader>l` | Focus right editor    | โฟกัสไปหน้าจอขวา  |

### 🗂️ Git Operations

| Key         | Action             | Description                |
| ----------- | ------------------ | -------------------------- |
| `<leader>g` | Show Git panel     | เปิด Git panel (Source Control) |
| `<leader>gd`| Show file diff     | ดู changes ของไฟล์ปัจจุบัน |
| `<leader>gb`| Toggle Git blame   | เปิด/ปิด Git blame (GitLens) |
| `<leader>gs`| Stage current file | Stage ไฟล์ปัจจุบัน        |

### 🧘 Zen Mode

| Key         | Action           | Description     |
| ----------- | ---------------- | --------------- |
| `<leader>z` | Toggle Zen Mode  | เปิด/ปิด Zen Mode |

### 🖥️ Standalone Neovim (Window Management)

| Key           | Action           | Description              |
| ------------- | ---------------- | ------------------------ |
| `<C-h/j/k/l>` | Navigate windows | เปลี่ยนไปมาระหว่าง split |

### ⌨️ Built-in Vim (ยังใช้ได้ปกติ)

| Key       | Action                  | Description                |
| --------- | ----------------------- | -------------------------- |
| `f{char}` | Find character forward  | หาตัวอักษรไปข้างหน้า       |
| `F{char}` | Find character backward | หาตัวอักษรไปข้างหลัง       |
| `*` / `#` | Search word             | ค้นหาคำใต้ cursor          |
| `n` / `N` | Next/prev search        | ค้นหาต่อ/กลับ              |
| `gd`      | Go to definition        | ไปที่ definition (VS Code) |
| `gr`      | Go to references        | ไปที่ references (VS Code) |
| `K`       | Show hover              | แสดงข้อมูล hover (VS Code) |

## 🔧 Configuration Details

### 🎯 Plugins Overview (VS Code Environment)

**Only 5 Essential Plugins:**

1. **Flash.nvim** - Super fast navigation with 2-character jump
2. **Spider.nvim** - Smart word movement for camelCase
3. **Comment.nvim** - Toggle comments with gcc/gc
4. **vim-surround** - Manipulate quotes, brackets, tags
5. **nvim-autopairs** - Auto-complete brackets and quotes

### 🚀 Performance Features

- **Single File Configuration** - Everything in `init.lua`
- **Environment Detection** - Automatically loads VS Code vs Standalone configs
- **Lazy Loading** - Plugins load only when needed
- **Instant Startup** - No delays or lag

### 🔍 Environment Detection

```lua
if vim.g.vscode then
  -- VS Code specific plugins and keymaps
else
  -- Standalone Neovim (basic setup)
end
```

## 🎨 Customization

### Adding Custom Keybindings

Add to `init.lua` in the appropriate environment section:

```lua
-- For VS Code
if vim.g.vscode then
  vim.keymap.set("n", "<leader>custom", function()
    -- Your custom function
  end, { desc = "Custom action" })
end
```

### Adding Plugins

Add to the `require("lazy").setup({})` table:

```lua
{
  "author/plugin-name",
  event = "VeryLazy",  -- or specific trigger
  config = function()
    require("plugin-name").setup()
  end,
}
```

## 🛠️ Troubleshooting

### Clear Plugin Cache

```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
```

### VS Code Integration Issues

1. Install [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
2. Check Neovim path in VS Code settings
3. Set `"keyboard.dispatch": "keyCode"` in settings.json

### Plugin Issues

Check plugin status and health:

```vim
:Lazy        " Plugin manager
:checkhealth " Health diagnostics
```

## 📚 Quick Reference

### Useful Commands

```vim
:Lazy        " Plugin manager
:Lazy sync   " Update all plugins
:help <key>  " Get help for any key
```

### Links

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [VS Code Neovim Extension](https://github.com/vscode-neovim/vscode-neovim)
