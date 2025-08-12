-- Event-driven configuration with autocommands
local utils = require("utils.init")

-- Create augroup for organization
local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_config_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Highlight yanked text",
})

-- Auto-resize splits when Vim is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Resize splits when Vim is resized",
})

-- Close certain filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with <q>",
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create directories when saving files",
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("remove_trailing_whitespace"),
  pattern = "*",
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Check if file changed outside of Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check if file changed outside of Neovim",
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("auto_cursorline"),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Show cursor line in active window",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("auto_cursorline"),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
  desc = "Hide cursor line in inactive window",
})

-- Auto-save when focus is lost (only for named buffers)
vim.api.nvim_create_autocmd("FocusLost", {
  group = augroup("auto_save"),
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
        if vim.bo[buf].modified and vim.bo[buf].buftype == "" then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! write")
          end)
        end
      end
    end
  end,
  desc = "Auto-save when focus is lost",
})

-- Set up filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
  desc = "Lua filetype settings",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "javascript", "typescript", "json", "html", "css", "yaml" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
  desc = "Web development filetype settings",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "python" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  end,
  desc = "Python filetype settings",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "go" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false -- Go uses tabs
  end,
  desc = "Go filetype settings",
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_settings"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-- Performance optimization: disable certain features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file_settings"),
  callback = function(event)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(event.buf))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.b[event.buf].large_file = true
      vim.opt_local.syntax = ""
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      utils.notify("Large file detected, some features disabled for performance", vim.log.levels.WARN)
    end
  end,
  desc = "Optimize settings for large files",
})

-- LSP-related autocommands
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_attach"),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end
    
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    
    -- Buffer local mappings for LSP
    local keymap_utils = require("utils.keymaps")
    
    keymap_utils.set_buffer_local(event.buf, "n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    keymap_utils.set_buffer_local(event.buf, "n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
    keymap_utils.set_buffer_local(event.buf, "n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    keymap_utils.set_buffer_local(event.buf, "n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
    keymap_utils.set_buffer_local(event.buf, "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    keymap_utils.set_buffer_local(event.buf, "n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
    keymap_utils.set_buffer_local(event.buf, "n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
    keymap_utils.set_buffer_local(event.buf, "n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    keymap_utils.set_buffer_local(event.buf, { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    keymap_utils.set_buffer_local(event.buf, "n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format buffer" })
    
    -- Highlight references under cursor
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
  desc = "LSP keymaps and settings",
})

-- Git-related autocommands
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("git_settings"),
  pattern = { "gitcommit", "gitrebase" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "72"
  end,
  desc = "Git commit settings",
})

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_settings"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
  desc = "Markdown settings",
})

-- Help settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("help_settings"),
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L") -- Open help in vertical split
  end,
  desc = "Help settings",
})

-- Environment-specific autocommands
if not utils.is_vscode() and not utils.is_kiro() then
  -- Standalone Neovim specific autocommands
  
  -- Auto-reload configuration files
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup("config_reload"),
    pattern = vim.fn.stdpath("config") .. "/**/*.lua",
    callback = function()
      utils.notify("Configuration updated, restart Neovim to apply changes", vim.log.levels.INFO)
    end,
    desc = "Notify when config files are updated",
  })
  
  -- Remember folds
  vim.api.nvim_create_autocmd("BufWinLeave", {
    group = augroup("remember_folds"),
    pattern = "*.*",
    callback = function()
      vim.cmd("mkview")
    end,
    desc = "Save folds when leaving buffer",
  })
  
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("remember_folds"),
    pattern = "*.*",
    callback = function()
      vim.cmd("silent! loadview")
    end,
    desc = "Load folds when entering buffer",
  })
end

-- Performance monitoring
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("performance_monitoring"),
  callback = function()
    local startup_time = _G.nvim_config.performance.startup_time
    if startup_time and startup_time > 100 then
      utils.notify(
        string.format("Slow startup detected: %.2fms", startup_time),
        vim.log.levels.WARN,
        { title = "Performance Warning" }
      )
    end
  end,
  desc = "Monitor startup performance",
})

-- Memory usage monitoring (check every 5 minutes)
if not utils.is_vscode() and not utils.is_kiro() then
  local memory_timer = vim.loop.new_timer()
  memory_timer:start(300000, 300000, vim.schedule_wrap(function() -- 5 minutes
    local memory_kb = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid()):gsub("%s+", "")
    local memory_mb = tonumber(memory_kb) / 1024
    
    _G.nvim_config.performance.memory_usage = memory_mb
    
    if memory_mb > 500 then -- Warn if using more than 500MB
      utils.notify(
        string.format("High memory usage detected: %.1fMB", memory_mb),
        vim.log.levels.WARN,
        { title = "Performance Warning" }
      )
    end
  end))
end