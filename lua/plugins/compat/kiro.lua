-- Kiro compatibility layer
-- Enhanced Kiro integration with AI-powered development workflow support

-- Early return if not in Kiro environment
if not _G.nvim_config.env.is_kiro then
  return {}
end

-- Kiro compatibility utilities
local M = {}

-- Kiro feature detection and integration
M.kiro_features = {
  ai_completion = true,
  spec_system = true,
  agent_hooks = true,
  mcp_support = true,
  steering_files = true,
}

-- Check if specific Kiro feature is available
M.has_kiro_feature = function(feature)
  return M.kiro_features[feature] or false
end

-- Kiro-specific command wrapper
M.kiro_call = function(command, args)
  -- Kiro doesn't expose direct command API like VS Code
  -- Instead, we integrate with Kiro's workflow through enhanced keybindings
  local ok, result = pcall(vim.cmd, command)
  if not ok then
    vim.notify(
      string.format("Kiro command failed: %s", command),
      vim.log.levels.WARN,
      { title = "Kiro Integration" }
    )
    return false
  end
  return true
end

-- Enhanced workflow integration for Kiro
M.setup_kiro_workflow = function()
  local keymap = vim.keymap.set
  
  -- AI-powered development keybindings
  keymap("n", "<leader>ai", function()
    vim.notify("Kiro AI features available through chat interface", vim.log.levels.INFO)
  end, { desc = "Kiro AI assistance" })
  
  -- Spec system integration
  keymap("n", "<leader>sp", function()
    vim.cmd("edit .kiro/specs/")
  end, { desc = "Open specs directory" })
  
  keymap("n", "<leader>st", function()
    vim.cmd("edit .kiro/steering/")
  end, { desc = "Open steering directory" })
  
  -- Enhanced file operations for Kiro workflow
  keymap("n", "<leader>ff", function()
    if pcall(require, 'telescope') then
      require('telescope.builtin').find_files({
        find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
        prompt_title = "Find Files (Kiro Enhanced)"
      })
    else
      vim.cmd("edit .")
    end
  end, { desc = "Find files (Kiro enhanced)" })
  
  -- Context-aware search for Kiro projects
  keymap("n", "<leader>fg", function()
    if pcall(require, 'telescope') then
      require('telescope.builtin').live_grep({
        additional_args = function()
          return { "--hidden", "--glob", "!.git/*" }
        end,
        prompt_title = "Live Grep (Kiro Enhanced)"
      })
    end
  end, { desc = "Live grep (Kiro enhanced)" })
  
  -- Kiro-specific project navigation
  keymap("n", "<leader>pk", function()
    vim.cmd("edit .kiro/")
  end, { desc = "Open Kiro config directory" })
  
  keymap("n", "<leader>pm", function()
    vim.cmd("edit .kiro/settings/mcp.json")
  end, { desc = "Edit MCP configuration" })
  
  -- Enhanced Git integration for Kiro workflow
  keymap("n", "<leader>gc", function()
    vim.cmd("Git commit")
  end, { desc = "Git commit" })
  
  keymap("n", "<leader>gp", function()
    vim.cmd("Git push")
  end, { desc = "Git push" })
  
  -- Documentation and help for Kiro features
  keymap("n", "<leader>hk", function()
    vim.notify("Kiro Help: Use chat interface for AI assistance, #File/#Folder for context", vim.log.levels.INFO)
  end, { desc = "Kiro help" })
end

-- Kiro-specific autocommands for enhanced workflow
M.setup_kiro_autocommands = function()
  local augroup = vim.api.nvim_create_augroup("KiroWorkflow", { clear = true })
  
  -- Auto-save for better Kiro integration
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    pattern = "*",
    callback = function()
      if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
        vim.defer_fn(function()
          if vim.bo.modified then
            vim.cmd("silent! write")
          end
        end, 1000) -- Auto-save after 1 second of inactivity
      end
    end,
  })
  
  -- Enhanced file type detection for Kiro projects
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { "*.kiro", ".kiro/*" },
    callback = function()
      vim.bo.filetype = "yaml" -- Assume YAML for Kiro config files
    end,
  })
  
  -- Spec file enhancements
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { ".kiro/specs/*/requirements.md", ".kiro/specs/*/design.md", ".kiro/specs/*/tasks.md" },
    callback = function()
      vim.bo.filetype = "markdown"
      vim.opt_local.conceallevel = 2
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
    end,
  })
end

-- Store utilities globally for access from other modules
_G.kiro_compat = M

return {
  -- Essential Vim plugins optimized for Kiro workflow
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    config = function()
      vim.notify("vim-surround loaded for Kiro", vim.log.levels.DEBUG)
    end,
  },
  
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
    config = function()
      vim.notify("vim-repeat loaded for Kiro", vim.log.levels.DEBUG)
    end,
  },
  
  {
    "vim-scripts/ReplaceWithRegister",
    event = "VeryLazy",
    config = function()
      vim.notify("ReplaceWithRegister loaded for Kiro", vim.log.levels.DEBUG)
    end,
  },
  
  -- Flash.nvim optimized for Kiro AI-powered development
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Kiro-optimized configuration with AI workflow support
      labels = "etovxqpdygfblzhckisuran",
      search = {
        multi_window = true, -- Enable multi-window for Kiro's split views
        forward = true,
        wrap = true, -- Enable wrap for better navigation in large files
        mode = "exact",
        incremental = true, -- Enable incremental search for better UX
      },
      jump = {
        jumplist = true,
        pos = "start",
        history = true, -- Enable history for Kiro workflow
        register = true,
        nohlsearch = true,
        autojump = false, -- Disable autojump for more control
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
        backdrop = true, -- Enable backdrop for better focus
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
          highlight = { backdrop = true },
          jump = { history = true, register = true, nohlsearch = true },
          search = { multi_window = true, wrap = true },
        },
        char = {
          enabled = true,
          autohide = false,
          jump_labels = true, -- Enable jump labels for better navigation
          multi_line = true,
          label = { exclude = "hjkliardc" },
          keys = { "f", "F", "t", "T", ";", "," },
          char_actions = function(motion)
            return {
              [";"] = "next",
              [","] = "prev",
            }
          end,
        },
        treesitter = {
          labels = "etovxqpdygfblzhckisuran",
          jump = { pos = "range" },
          search = { incremental = true },
          label = { before = true, after = true, style = "inline" },
          highlight = {
            backdrop = true,
            matches = true,
          }
        },
      },
      prompt = {
        enabled = true, -- Enable prompt for Kiro's enhanced workflow
        prefix = { { "🎯 ", "FlashPromptIcon" } },
        win_config = {
          relative = "editor",
          width = 0.8,
          height = 1,
          row = -3,
          col = 0,
          zindex = 1000,
          border = "rounded",
          title = " Kiro Flash ",
          title_pos = "center",
        },
      },
      remote_op = {
        restore = true, -- Enable restore for better Kiro integration
        motion = true,
      },
    },
    keys = {
      -- Enhanced navigation keybindings for Kiro
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
        "<leader>j",
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
        "<leader>J",
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
      -- Kiro-specific flash keybindings
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle flash search",
      },
      -- AI-context aware navigation
      {
        "<leader>af",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            pattern = "function\\|class\\|def\\|const\\|let\\|var",
            label = { after = { 0, 0 } },
          })
        end,
        desc = "Flash jump to functions/classes",
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      
      -- Kiro-themed highlights
      local colors = {
        match = "#ff6b6b",     -- Kiro red for matches
        current = "#4ecdc4",   -- Kiro teal for current
        label = "#45b7d1",     -- Kiro blue for labels
        backdrop = "#2d3748"   -- Dark backdrop
      }
      
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = colors.match, bold = true })
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = colors.current, bold = true, bg = "#1a202c" })
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = colors.label, bold = true, bg = "#2d3748" })
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = colors.backdrop })
      vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = colors.current, bold = true })
      
      vim.notify("Flash.nvim optimized for Kiro", vim.log.levels.DEBUG)
    end,
  },

  -- Which-key for discoverable keybindings in Kiro
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
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded", -- Rounded borders for Kiro aesthetic
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 10, -- Slight transparency
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
      
      -- Register Kiro-specific key groups using new API
      wk.add({
        { "<leader>a", group = "AI/Kiro" },
        { "<leader>s", group = "Specs/Steering" },
        { "<leader>p", group = "Project/Kiro" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>b", group = "Buffer" },
        { "<leader>h", group = "Help" },
        { "<leader>j", group = "Jump" },
        { "<leader>r", group = "Replace" },
        { "<leader>w", group = "Save" },
        { "<leader>q", group = "Quit" },
        { "<leader>t", group = "Terminal" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>n", group = "Notes" },
        { "<leader>u", group = "UI" },
        { "<leader>v", group = "Visual" },
        { "<leader>z", group = "Fold" },
      })
      
      vim.notify("Which-key configured for Kiro", vim.log.levels.DEBUG)
    end,
  },

  -- Enhanced Git integration for Kiro workflow
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      -- Kiro-specific Git workflow keybindings
      local keymap = vim.keymap.set
      
      keymap("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
      keymap("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
      keymap("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
      keymap("n", "<leader>gl", "<cmd>Git log --oneline<cr>", { desc = "Git log" })
      keymap("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" })
      keymap("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
      
      vim.notify("Fugitive configured for Kiro workflow", vim.log.levels.DEBUG)
    end,
  },

  -- Telescope for enhanced file navigation in Kiro
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          prompt_title = "🔍 Find Files (Kiro Enhanced)",
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*" }
          end,
          prompt_title = "🔍 Live Grep (Kiro Enhanced)",
        },
        buffers = {
          prompt_title = "🔍 Buffers",
          mappings = {
            i = {
              ["<c-d>"] = "delete_buffer",
            }
          }
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      
      -- Setup Kiro workflow integration
      M.setup_kiro_workflow()
      M.setup_kiro_autocommands()
      
      vim.notify("Telescope configured for Kiro workflow", vim.log.levels.DEBUG)
    end,
  },

  -- Enhanced markdown support for Kiro specs and documentation
  {
    "plasticboy/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    config = function()
      -- Kiro-specific markdown settings
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_edit_url_in = 'tab'
      vim.g.vim_markdown_follow_anchor = 1
      
      vim.notify("Enhanced markdown support for Kiro specs", vim.log.levels.DEBUG)
    end,
  },

  -- YAML support for Kiro configuration files
  {
    "stephpy/vim-yaml",
    ft = "yaml",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "yaml",
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.expandtab = true
        end,
      })
      
      vim.notify("YAML support configured for Kiro", vim.log.levels.DEBUG)
    end,
  },
}