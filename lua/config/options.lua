-- Modern Neovim options configuration
local opt = vim.opt
local g = vim.g

-- Leader key (set early)
g.mapleader = " "
g.maplocalleader = " "

-- Performance settings
opt.updatetime = 250 -- Faster completion (default 4000ms)
opt.timeout = true
opt.timeoutlen = _G.nvim_config.preferences.timeout_len

-- UI settings
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.colorcolumn = "80" -- Show column at 80 characters
opt.wrap = false -- Don't wrap lines
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.pumheight = 10 -- Maximum items in popup menu
opt.cmdheight = 1 -- Command line height
opt.showmode = false -- Don't show mode (status line will show it)
opt.conceallevel = 0 -- Don't hide characters
opt.fileencoding = "utf-8" -- File encoding

-- Font and icons
g.have_nerd_font = true -- Enable Nerd Font support

-- Search settings
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search results as you type
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search contains uppercase

-- Indentation settings
opt.tabstop = 4 -- Number of spaces for tab
opt.softtabstop = 4 -- Number of spaces for tab in insert mode
opt.shiftwidth = 4 -- Number of spaces for indentation
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true -- Smart indentation
opt.autoindent = true -- Auto indentation
opt.breakindent = true -- Maintain indent when wrapping

-- Clipboard integration
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Backup and undo settings
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before overwriting
opt.swapfile = false -- Don't create swap files
opt.undofile = true -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Undo directory

-- Split settings
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right

-- Completion settings
opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
opt.shortmess:append("c") -- Don't show completion messages

-- Mouse and selection
opt.mouse = "a" -- Enable mouse support
opt.selection = "exclusive" -- Selection behavior

-- Folding (disabled by default, can be enabled per filetype)
opt.foldenable = false
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Terminal colors
opt.termguicolors = true -- Enable 24-bit RGB colors

-- Wildmenu settings
opt.wildmode = "longest:full,full" -- Command completion mode
opt.wildignore:append({ "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe" })
opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/target/*" })
opt.wildignore:append({ "*.jpg", "*.png", "*.jpeg", "*.gif", "*.pdf" })

-- List characters (for showing whitespace)
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
}

-- Session settings
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Environment-specific settings
if _G.nvim_config.env.is_vscode then
  -- VS Code specific settings - PERFORMANCE OPTIMIZED
  opt.number = false
  opt.relativenumber = false
  opt.cursorline = false
  opt.signcolumn = "no"
  opt.colorcolumn = ""
  opt.list = false -- Disable list chars in VS Code
  opt.showmode = false -- VS Code shows mode
  opt.ruler = false -- VS Code shows position
  opt.showcmd = false -- VS Code shows commands
  opt.laststatus = 0 -- Hide status line in VS Code
  opt.cmdheight = 1 -- Minimal command height
  opt.updatetime = 100 -- Faster updates for VS Code
  opt.timeoutlen = 300 -- Faster key timeout
  opt.ttimeoutlen = 10 -- Faster escape timeout
  opt.redrawtime = 1500 -- Faster redraw timeout
  opt.synmaxcol = 200 -- Limit syntax highlighting for long lines
  opt.scrolljump = 5 -- Scroll 5 lines at a time
  opt.sidescroll = 1 -- Smooth horizontal scrolling
  opt.ttyfast = true -- Fast terminal connection
  opt.lazyredraw = true -- Don't redraw during macros
elseif _G.nvim_config.env.is_kiro then
  -- Kiro specific settings
  opt.signcolumn = "yes:1" -- Limit sign column width
end

-- Platform-specific settings
if _G.nvim_config.env.platform == "darwin" then
  -- macOS specific settings
  opt.clipboard:append("unnamed") -- Use macOS clipboard
elseif _G.nvim_config.env.platform:match("windows") then
  -- Windows specific settings
  opt.shell = "powershell"
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellquote = ""
  opt.shellxquote = ""
end