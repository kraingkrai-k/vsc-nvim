-- Standalone Neovim UI and feature plugins

if vim.g.vscode then
  return {}
end

return {
  -- Colorscheme (Tokyo Night like LazyVim default)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  
  -- UI Enhancements
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end,
  },
  
  -- Better buffer/tab line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          separator_style = "thin",
          always_show_bufferline = true,
        }
      })
    end,
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,  -- Show dotfiles including .gitignore
          git_ignored = false,  -- Show git ignored files
        },
        git = {
          enable = true,
          ignore = false,  -- Show files ignored by git
        },
      })
    end,
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = {
            "node_modules/.*",
            "%.git/.*",
            "dist/.*",
            "build/.*",
            "%.next/.*",
            "coverage/.*",
            "%.nyc_output/.*"
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,  -- Show hidden files but respect ignore patterns
          },
        },
      })
    end,
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Next Hunk" })
          
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = "Prev Hunk" })
          
          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
          map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage Buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset Buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Hunk" })
          map('n', '<leader>hb', function() gs.blame_line{ full=true } end, { desc = "Blame Line" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Diff This" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff This ~" })
          
          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "GitSigns Select Hunk" })
        end
      })
    end,
  },
  
  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
  
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Configure LazyGit to use Escape key to close
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_corner_chars = {'╭', '╮', '╰', '╯'} -- customize lazygit popup window corner characters
      vim.g.lazygit_use_neovim_remote = 1 -- for neovim-remote support
      
      -- Add keymap to close LazyGit with Escape in the LazyGit buffer
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*lazygit*",
        callback = function()
          vim.keymap.set("t", "<Esc>", "<cmd>close<cr>", { buffer = true, silent = true })
        end,
      })
    end,
  },

  -- LSP Configuration (using new vim.lsp.config API for Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          -- Go to definition (same as VS Code)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

          -- Show hover (same as VS Code)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover" }))

          -- Find references using Telescope (better than VS Code!)
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "Find references" }))

          -- Additional useful LSP keymaps
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Type definition" }))
        end,
      })

      -- Check if vim.lsp.config is available (Neovim 0.11+)
      if vim.lsp.config then
        -- Use new vim.lsp.config API (Neovim 0.11+)

        -- TypeScript/JavaScript
        vim.lsp.config.ts_ls = {
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
        }

        -- Go
        vim.lsp.config.gopls = {
          cmd = { 'gopls' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          root_markers = { 'go.work', 'go.mod', '.git' },
        }

        -- Lua
        vim.lsp.config.lua_ls = {
          cmd = { 'lua-language-server' },
          filetypes = { 'lua' },
          root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        }

        -- Enable servers (new API auto-starts on filetype match)
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('gopls')
        vim.lsp.enable('lua_ls')

      else
        -- Fallback to old lspconfig API for Neovim < 0.11
        local lspconfig = require("lspconfig")

        local servers = {
          ts_ls = {},    -- TypeScript/JavaScript
          gopls = {},    -- Go
          lua_ls = {     -- Lua
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          },
        }

        for server, config in pairs(servers) do
          lspconfig[server].setup(config)
        end
      end
    end,
  },

  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP config integration
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "gopls", "lua_ls" },
        automatic_installation = true,
      })
    end,
  },

  -- Multi-cursor for standalone Neovim (vim-visual-multi)
  {
    "mg979/vim-visual-multi",
    keys = {
      { "gn", desc = "Multi-cursor select next" },
      { "gN", desc = "Multi-cursor select previous" },
      { "gb", desc = "Multi-cursor add cursor" },
      { "<leader>ma", desc = "Multi-cursor select all" },
    },
    config = function()
      -- Configure vim-visual-multi to match VS Code and common vim patterns
      vim.g.VM_default_mappings = 0  -- Disable default mappings
      vim.g.VM_mouse_mappings = 1    -- Enable mouse support
      
      -- Custom mappings to avoid conflicts with vim defaults
      vim.g.VM_maps = {
        ['Find Under']                  = 'gn',           -- gn (vim-friendly)
        ['Find Subword Under']          = 'gn',
        ['Add Cursor At Pos']           = 'gb',           -- gb (vim-visual-multi style)  
        ['Select All']                  = '<leader>ma',   -- Select all matches
        ['Start Regex Search']          = '<leader>/',    -- Regex search mode
        ['Add Cursor Up']               = '<C-Up>',       -- Add cursor up
        ['Add Cursor Down']             = '<C-Down>',     -- Add cursor down
        ['Select Cursor Up']            = '<M-C-Up>',     -- Select cursor up
        ['Select Cursor Down']          = '<M-C-Down>',   -- Select cursor down
        ['Skip Region']                 = '<C-x>',        -- Skip current match
        ['Remove Region']               = 'q',            -- Remove current cursor/region
        ['Increase']                    = '+',            -- Increase selection
        ['Decrease']                    = '_',            -- Decrease selection
        ['Toggle Mappings']             = '<leader>mt',   -- Toggle VM mappings
      }
      
      -- VM settings for better UX
      vim.g.VM_set_statusline = 2           -- Set statusline
      vim.g.VM_silent_exit = 1              -- Don't show exit message
      vim.g.VM_show_warnings = 1            -- Show warnings
      vim.g.VM_highlight_matches = 'underline'  -- Highlight style
    end,
  },
}