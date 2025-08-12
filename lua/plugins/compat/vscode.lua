-- VS Code compatibility layer
-- Enhanced VS Code integration with fallback mechanisms and optimized plugin loading

-- Early return if not in VS Code environment
if not _G.nvim_config.env.is_vscode then
  return {}
end

-- VS Code compatibility utilities
local M = {}

-- VS Code command wrapper with error handling
M.vscode_call = function(command, args)
  local ok, result = pcall(vim.fn.VSCodeNotify, command, args)
  if not ok then
    vim.notify(
      string.format("VS Code command failed: %s", command),
      vim.log.levels.WARN,
      { title = "VS Code Integration" }
    )
    return false
  end
  return true
end

-- Check if VS Code extension is available
M.has_vscode_extension = function(extension_id)
  -- This is a placeholder - VS Code doesn't expose extension info to Neovim
  -- In practice, we'll rely on command availability
  return true
end

-- Fallback mechanism for missing VS Code features
M.fallback_notify = function(feature, fallback_action)
  vim.notify(
    string.format("VS Code feature '%s' not available, using fallback", feature),
    vim.log.levels.INFO
  )
  if fallback_action then
    fallback_action()
  end
end

-- Enhanced keybinding migration system
M.migrate_keybindings = function()
  local keymap = vim.keymap.set
  
  -- File operations with fallbacks
  keymap("n", "<leader>w", function()
    if not M.vscode_call('workbench.action.files.save') then
      vim.cmd('write')
    end
  end, { desc = "Save file" })
  
  keymap("n", "<leader>q", function()
    if not M.vscode_call('workbench.action.closeActiveEditor') then
      vim.cmd('quit')
    end
  end, { desc = "Close editor" })
  
  -- Enhanced navigation with VS Code integration
  keymap("n", "gd", function()
    if not M.vscode_call('editor.action.revealDefinition') then
      M.fallback_notify("Go to definition", function()
        vim.lsp.buf.definition()
      end)
    end
  end, { desc = "Go to definition" })
  
  keymap("n", "gr", function()
    if not M.vscode_call('editor.action.goToReferences') then
      M.fallback_notify("Go to references", function()
        vim.lsp.buf.references()
      end)
    end
  end, { desc = "Go to references" })
  
  -- Code actions with fallback
  keymap("n", "<leader>ca", function()
    if not M.vscode_call('editor.action.quickFix') then
      M.fallback_notify("Code actions", function()
        vim.lsp.buf.code_action()
      end)
    end
  end, { desc = "Code actions" })
  
  -- Enhanced search integration
  keymap("n", "<leader>ff", function()
    if not M.vscode_call('workbench.action.quickOpen') then
      M.fallback_notify("Quick open", function()
        if pcall(require, 'telescope') then
          require('telescope.builtin').find_files()
        end
      end)
    end
  end, { desc = "Find files" })
  
  keymap("n", "<leader>fg", function()
    if not M.vscode_call('workbench.action.findInFiles') then
      M.fallback_notify("Find in files", function()
        if pcall(require, 'telescope') then
          require('telescope.builtin').live_grep()
        end
      end)
    end
  end, { desc = "Find in files" })
end

-- Store utilities globally for access from other modules
_G.vscode_compat = M

return {
  -- Essential Vim plugins that enhance VS Code experience
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    config = function()
      vim.notify("vim-surround loaded for VS Code", vim.log.levels.DEBUG)
    end,
  },
  
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
    config = function()
      vim.notify("vim-repeat loaded for VS Code", vim.log.levels.DEBUG)
    end,
  },
  
  {
    "vim-scripts/ReplaceWithRegister",
    event = "VeryLazy",
    config = function()
      vim.notify("ReplaceWithRegister loaded for VS Code", vim.log.levels.DEBUG)
    end,
  },
  
  -- Flash.nvim optimized for VS Code with enhanced navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- VS Code optimized configuration
      labels = "etovxqpdygfblzhckisuran",
      search = {
        multi_window = false, -- VS Code handles multi-window differently
        forward = true,
        wrap = false,
        mode = "exact",
        incremental = false, -- Disable for VS Code compatibility
      },
      jump = {
        jumplist = true,
        pos = "start",
        history = false, -- Let VS Code handle history
        register = false,
        nohlsearch = true, -- Clear highlights after jump
        autojump = true,
      },
      label = {
        uppercase = true,
        exclude = "",
        current = true,
        after = true,
        before = false,
        style = "overlay",
        reuse = "lowercase",
        distance = true,
        min_pattern_length = 1,
      },
      highlight = {
        backdrop = false, -- Don't dim background in VS Code
        matches = true,
        priority = 5000,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel"
        }
      },
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = false, register = false, nohlsearch = true },
          search = { multi_window = false },
        },
        char = {
          enabled = true,
          autohide = true, -- Auto-hide in VS Code for cleaner experience
          jump_labels = false,
          multi_line = true,
          label = { exclude = "hjkliardc" },
          keys = { "f", "F", "t", "T", ";", "," },
          char_actions = function(motion)
            return {
              [";"] = "next", -- find next
              [","] = "prev", -- find previous
            }
          end,
        },
        treesitter = {
          labels = "etovxqpdygfblzhckisuran",
          jump = { pos = "range" },
          search = { incremental = false },
          label = { before = true, after = true, style = "inline" },
          highlight = {
            backdrop = false,
            matches = false,
          }
        },
      },
      prompt = {
        enabled = false, -- Disable prompt in VS Code to avoid conflicts
        prefix = { { "⚡", "FlashPromptIcon" } },
      },
      remote_op = {
        restore = false, -- Don't restore in VS Code
        motion = false,
      },
    },
    keys = {
      -- Enhanced navigation keybindings for VS Code
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^"
          })
        end,
        desc = "Flash jump to line",
      },
      {
        "<leader>S",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search" },
            label = { after = { 0, 0 } },
          })
        end,
        desc = "Flash search",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash treesitter search",
      },
      -- VS Code specific flash keybindings
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle flash search",
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      
      -- VS Code compatible highlights
      local colors = {
        match = "#e06c75",     -- Red for matches
        current = "#61afef",   -- Blue for current
        label = "#98c379",     -- Green for labels
        backdrop = "#5c6370"   -- Gray for backdrop
      }
      
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = colors.match, bold = true })
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = colors.current, bold = true, bg = "#3e4451" })
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = colors.label, bold = true, bg = "#2c323c" })
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = colors.backdrop })
      
      -- Migrate existing keybindings
      M.migrate_keybindings()
      
      vim.notify("Flash.nvim optimized for VS Code", vim.log.levels.DEBUG)
    end,
  },

  -- Which-key for discoverable keybindings in VS Code
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      { "echasnovski/mini.icons", optional = true },
      { "nvim-tree/nvim-web-devicons", optional = true },
    },
    opts = {
      preset = "modern",
      delay = 200,
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,
      triggers = {
        { "<auto>", mode = "nxsot" },
      },
      plugins = {
        marks = false, -- VS Code handles marks differently
        registers = true,
        spelling = {
          enabled = false, -- VS Code has its own spell check
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = false, -- VS Code handles windows
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "none", -- Clean look for VS Code
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        mappings = vim.g.have_nerd_font ~= false,
      },
      show_help = true,
      show_keys = true,
      disable = {
        buftypes = {},
        filetypes = {},
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Register VS Code specific key groups using new API
      wk.add({
        { "<leader>w", group = "Save" },
        { "<leader>q", group = "Quit" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>b", group = "Buffer" },
        { "<leader>p", group = "Project" },
        { "<leader>s", group = "Search" },
        { "<leader>r", group = "Rename/Replace" },
        { "<leader>d", group = "Multi-cursor" },
        { "<leader>a", group = "Select All" },
        { "<leader>z", group = "Focus" },
        { "<leader>e", group = "Explorer" },
        { "<leader>/", group = "Comment" },
      })
      
      vim.notify("Which-key configured for VS Code", vim.log.levels.DEBUG)
    end,
  },

  -- Comment.nvim for enhanced commenting (complements VS Code)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    },
    config = function(_, opts)
      require("Comment").setup(opts)
      vim.notify("Comment.nvim loaded for VS Code", vim.log.levels.DEBUG)
    end,
  },

  -- Indent-blankline for visual indentation (VS Code compatible)
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = { "IblIndent" },
        smart_indent_cap = true,
      },
      whitespace = {
        highlight = { "IblWhitespace" },
        remove_blankline_trail = true,
      },
      scope = {
        enabled = true,
        char = "│",
        highlight = { "IblScope" },
        priority = 1024,
        include = {
          node_type = {
            ["*"] = { "*" },
          },
        },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        buftypes = { "terminal", "nofile" },
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      
      -- VS Code compatible colors
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3e4451", nocombine = true })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#61afef", nocombine = true })
      vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#3e4451", nocombine = true })
      
      vim.notify("Indent-blankline configured for VS Code", vim.log.levels.DEBUG)
    end,
  },
}