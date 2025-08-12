-- Keymap utilities for enhanced keymap management
local M = {}

-- Default keymap options
local default_opts = {
  noremap = true,
  silent = true
}

-- Set a single keymap with enhanced options
function M.set(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Set multiple keymaps at once
function M.set_multiple(keymaps)
  for _, keymap in ipairs(keymaps) do
    local mode = keymap.mode or keymap[1]
    local lhs = keymap.lhs or keymap[2]
    local rhs = keymap.rhs or keymap[3]
    local opts = keymap.opts or keymap[4] or {}
    
    M.set(mode, lhs, rhs, opts)
  end
end

-- Create a keymap group with common prefix
function M.create_group(prefix, keymaps, common_opts)
  common_opts = common_opts or {}
  
  for key, config in pairs(keymaps) do
    local full_key = prefix .. key
    local mode = config.mode or "n"
    local rhs = config.rhs or config[1]
    local opts = vim.tbl_extend("force", common_opts, config.opts or config[2] or {})
    
    M.set(mode, full_key, rhs, opts)
  end
end

-- Create buffer-local keymaps
function M.set_buffer_local(buffer, mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  opts.buffer = buffer
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Create filetype-specific keymaps
function M.set_filetype(filetype, keymaps)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function(event)
      for _, keymap in ipairs(keymaps) do
        local mode = keymap.mode or keymap[1]
        local lhs = keymap.lhs or keymap[2]
        local rhs = keymap.rhs or keymap[3]
        local opts = keymap.opts or keymap[4] or {}
        
        M.set_buffer_local(event.buf, mode, lhs, rhs, opts)
      end
    end
  })
end

-- Delete a keymap
function M.del(mode, lhs, opts)
  opts = opts or {}
  vim.keymap.del(mode, lhs, opts)
end

-- Check if a keymap exists
function M.exists(mode, lhs, opts)
  opts = opts or {}
  local maps = vim.api.nvim_get_keymap(mode)
  
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      if opts.buffer then
        return map.buffer == opts.buffer
      else
        return map.buffer == 0 -- Global keymap
      end
    end
  end
  
  return false
end

-- Get keymap information
function M.get_info(mode, lhs, opts)
  opts = opts or {}
  local maps
  
  if opts.buffer then
    maps = vim.api.nvim_buf_get_keymap(opts.buffer, mode)
  else
    maps = vim.api.nvim_get_keymap(mode)
  end
  
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return map
    end
  end
  
  return nil
end

-- Create which-key compatible keymap specifications
function M.which_key_spec(prefix, keymaps, group_name)
  local spec = {
    [prefix] = {
      name = group_name or "Group"
    }
  }
  
  for key, config in pairs(keymaps) do
    local full_key = prefix .. key
    spec[full_key] = {
      config.rhs or config[1],
      config.desc or config[2] or "No description"
    }
  end
  
  return spec
end

-- Platform-specific keymap creation
function M.set_platform_specific(platform_keymaps)
  local platform = require("utils.platform").detect_os()
  
  if platform_keymaps[platform] then
    for _, keymap in ipairs(platform_keymaps[platform]) do
      local mode = keymap.mode or keymap[1]
      local lhs = keymap.lhs or keymap[2]
      local rhs = keymap.rhs or keymap[3]
      local opts = keymap.opts or keymap[4] or {}
      
      M.set(mode, lhs, rhs, opts)
    end
  end
  
  -- Apply common keymaps if they exist
  if platform_keymaps.common then
    for _, keymap in ipairs(platform_keymaps.common) do
      local mode = keymap.mode or keymap[1]
      local lhs = keymap.lhs or keymap[2]
      local rhs = keymap.rhs or keymap[3]
      local opts = keymap.opts or keymap[4] or {}
      
      M.set(mode, lhs, rhs, opts)
    end
  end
end

-- Environment-aware keymap creation (VS Code, Kiro, standalone)
function M.set_environment_aware(env_keymaps)
  local utils = require("utils.init")
  
  if utils.is_vscode() and env_keymaps.vscode then
    M.set_multiple(env_keymaps.vscode)
  elseif utils.is_kiro() and env_keymaps.kiro then
    M.set_multiple(env_keymaps.kiro)
  elseif utils.is_standalone() and env_keymaps.standalone then
    M.set_multiple(env_keymaps.standalone)
  end
  
  -- Apply common keymaps if they exist
  if env_keymaps.common then
    M.set_multiple(env_keymaps.common)
  end
end

-- Create leader key shortcuts
function M.leader(key, rhs, opts, mode)
  mode = mode or "n"
  local leader = vim.g.mapleader or " "
  M.set(mode, leader .. key, rhs, opts)
end

-- Create local leader key shortcuts
function M.local_leader(key, rhs, opts, mode)
  mode = mode or "n"
  local local_leader = vim.g.maplocalleader or "\\"
  M.set(mode, local_leader .. key, rhs, opts)
end

-- Utility function to create common navigation keymaps
function M.setup_navigation_keymaps()
  -- Window navigation
  M.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
  M.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
  M.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
  M.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
  
  -- Window resizing
  M.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
  M.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
  M.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
  M.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
  
  -- Buffer navigation
  M.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
  M.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
  
  -- Tab navigation
  M.set("n", "<A-h>", ":tabprevious<CR>", { desc = "Previous tab" })
  M.set("n", "<A-l>", ":tabnext<CR>", { desc = "Next tab" })
end

-- Utility function to create common editing keymaps
function M.setup_editing_keymaps()
  -- Better indenting
  M.set("v", "<", "<gv", { desc = "Indent left and reselect" })
  M.set("v", ">", ">gv", { desc = "Indent right and reselect" })
  
  -- Move lines up/down
  M.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
  M.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
  M.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  M.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
  
  -- Better paste
  M.set("v", "p", '"_dP', { desc = "Paste without yanking" })
  
  -- Clear search highlighting
  M.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting" })
  
  -- Save file
  M.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
  M.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })
end

-- Create a keymap with automatic description generation
function M.auto_desc(mode, lhs, rhs, opts)
  opts = opts or {}
  
  if not opts.desc and type(rhs) == "string" then
    -- Try to generate description from command
    if rhs:match("^:") then
      opts.desc = rhs:gsub("^:", ""):gsub("<CR>$", "")
    elseif rhs:match("^<cmd>") then
      opts.desc = rhs:gsub("^<cmd>", ""):gsub("<cr>$", "")
    end
  end
  
  M.set(mode, lhs, rhs, opts)
end

-- Batch create keymaps with automatic descriptions
function M.auto_desc_multiple(keymaps)
  for _, keymap in ipairs(keymaps) do
    local mode = keymap.mode or keymap[1]
    local lhs = keymap.lhs or keymap[2]
    local rhs = keymap.rhs or keymap[3]
    local opts = keymap.opts or keymap[4] or {}
    
    M.auto_desc(mode, lhs, rhs, opts)
  end
end

-- Create conditional keymaps based on plugin availability
function M.set_if_plugin(plugin_name, keymaps)
  local utils = require("utils.init")
  
  if utils.has_plugin(plugin_name) then
    M.set_multiple(keymaps)
  end
end

-- Create keymaps that are only active in certain modes
function M.set_mode_specific(mode_keymaps)
  for mode, keymaps in pairs(mode_keymaps) do
    for _, keymap in ipairs(keymaps) do
      local lhs = keymap.lhs or keymap[1]
      local rhs = keymap.rhs or keymap[2]
      local opts = keymap.opts or keymap[3] or {}
      
      M.set(mode, lhs, rhs, opts)
    end
  end
end

return M