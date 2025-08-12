-- Navigation plugins for enhanced movement and jumping
return {
  -- Telescope.nvim - Fuzzy finder for files, buffers, and more
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      
      telescope.setup({
        defaults = {
          -- Performance optimizations
          cache_picker = {
            num_pickers = 10,
            limit_entries = 1000,
          },
          
          -- UI configuration
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
          
          -- File ignore patterns
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.npm/",
            "__pycache__/",
            "%.pyc",
            "%.pyo",
            "%.pyd",
            "%.so",
            "%.dll",
            "%.class",
            "%.sln",
            "%.suo",
            "%.vcxproj",
            "%.vcxproj.user",
            "%.vcxproj.filters",
            "%.vcxproj.user",
            "%.tmp",
            "%.swp",
            "%.swo",
            "%.zip",
            "%.tar.gz",
            "%.tar.bz2",
            "%.rar",
            "%.tar.xz",
            "%.tar",
            "%.DS_Store",
            "%.min.js",
            "%.min.css",
          },
          
          -- Search configuration
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          
          -- Mappings
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        
        pickers = {
          -- File pickers
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = false,
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          
          -- Buffer picker
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          
          -- Live grep
          live_grep = {
            additional_args = function(opts)
              return {"--hidden"}
            end
          },
          
          -- Grep string
          grep_string = {
            additional_args = function(opts)
              return {"--hidden"}
            end
          },
          
          -- Git files
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          
          -- Help tags
          help_tags = {
            theme = "ivy",
          },
          
          -- Colorscheme
          colorscheme = {
            enable_preview = true,
          },
          
          -- LSP references
          lsp_references = {
            theme = "ivy",
            initial_mode = "normal",
          },
          
          -- LSP definitions
          lsp_definitions = {
            theme = "ivy",
            initial_mode = "normal",
          },
          
          -- LSP implementations
          lsp_implementations = {
            theme = "ivy",
            initial_mode = "normal",
          },
          
          -- Diagnostics
          diagnostics = {
            theme = "ivy",
            initial_mode = "normal",
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              previewer = false,
            }),
          },
          
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      })
      
      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      
      -- Custom functions for enhanced functionality
      local M = {}
      
      -- Find files in current directory
      M.find_files_cwd = function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.expand("%:p:h"),
        })
      end
      
      -- Live grep in current directory
      M.live_grep_cwd = function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.expand("%:p:h"),
        })
      end
      
      -- Find files in git root
      M.find_files_git_root = function()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.v.shell_error ~= 0 then
          vim.notify("Not in a git repository", vim.log.levels.WARN)
          return
        end
        require("telescope.builtin").find_files({
          cwd = git_root,
        })
      end
      
      -- Search for word under cursor
      M.grep_word_under_cursor = function()
        require("telescope.builtin").grep_string({
          search = vim.fn.expand("<cword>"),
        })
      end
      
      -- Search for visual selection
      M.grep_visual_selection = function()
        local text = vim.fn.getline("'<", "'>")
        text = table.concat(text, "\n")
        require("telescope.builtin").grep_string({
          search = text,
        })
      end
      
      -- Recent files
      M.recent_files = function()
        require("telescope.builtin").oldfiles({
          only_cwd = true,
        })
      end
      
      -- Make functions globally available
      _G.telescope_custom = M
      
      -- Notify successful loading
      if _G.nvim_config.env.is_standalone then
        vim.notify("Telescope.nvim loaded successfully! 🔭", vim.log.levels.INFO)
      end
    end,
    
    keys = {
      -- File finding (less than 3 keystrokes)
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Git Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fc", "<cmd>lua _G.telescope_custom.find_files_cwd()<cr>", desc = "Find Files (CWD)" },
      { "<leader>fG", "<cmd>lua _G.telescope_custom.find_files_git_root()<cr>", desc = "Find Files (Git Root)" },
      
      -- Search and grep (less than 3 keystrokes)
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sw", "<cmd>lua _G.telescope_custom.grep_word_under_cursor()<cr>", desc = "Search Word Under Cursor" },
      { "<leader>sv", "<cmd>lua _G.telescope_custom.grep_visual_selection()<cr>", desc = "Search Visual Selection", mode = "v" },
      { "<leader>sc", "<cmd>lua _G.telescope_custom.live_grep_cwd()<cr>", desc = "Live Grep (CWD)" },
      { "<leader>sa", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep with Args" },
      
      -- Buffer management (less than 3 keystrokes)
      { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
      { "<leader>bd", "<cmd>Telescope buffers<cr>", desc = "Delete Buffer" },
      
      -- Help and documentation
      { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      
      -- LSP integration
      { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
      { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
      { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>le", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      
      -- Git integration
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      
      -- Miscellaneous
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
      { "<leader>cs", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>tr", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
    },
  },

  -- Harpoon - Quick file switching and project navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")
      
      -- Setup harpoon with project-specific configuration
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            -- Use git root as project identifier, fallback to cwd
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if vim.v.shell_error == 0 then
              return git_root
            else
              return vim.loop.cwd()
            end
          end,
        },
        default = {
          get_root_dir = function()
            -- Use git root as project root, fallback to cwd
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if vim.v.shell_error == 0 then
              return git_root
            else
              return vim.loop.cwd()
            end
          end,
        },
      })
      
      -- Custom functions for enhanced workflow
      local M = {}
      
      -- Add current file to harpoon
      M.add_file = function()
        harpoon:list():add()
        local filename = vim.fn.expand("%:t")
        if filename ~= "" then
          vim.notify("Added " .. filename .. " to Harpoon", vim.log.levels.INFO)
        else
          vim.notify("Added current buffer to Harpoon", vim.log.levels.INFO)
        end
      end
      
      -- Remove current file from harpoon
      M.remove_file = function()
        local current_file = vim.api.nvim_buf_get_name(0)
        local list = harpoon:list()
        local items = list.items
        
        for i, item in ipairs(items) do
          if item.value == current_file then
            list:remove_at(i)
            local filename = vim.fn.expand("%:t")
            vim.notify("Removed " .. filename .. " from Harpoon", vim.log.levels.INFO)
            return
          end
        end
        
        vim.notify("File not found in Harpoon list", vim.log.levels.WARN)
      end
      
      -- Clear all harpoon marks
      M.clear_all = function()
        harpoon:list():clear()
        vim.notify("Cleared all Harpoon marks", vim.log.levels.INFO)
      end
      
      -- Navigate to specific harpoon mark
      M.nav_to = function(index)
        harpoon:list():select(index)
      end
      
      -- Navigate to next harpoon mark
      M.nav_next = function()
        harpoon:list():next()
      end
      
      -- Navigate to previous harpoon mark
      M.nav_prev = function()
        harpoon:list():prev()
      end
      
      -- Show harpoon quick menu
      M.toggle_quick_menu = function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end
      
      -- Telescope integration for harpoon
      M.telescope_marks = function()
        local conf = require("telescope.config").values
        local finders = require("telescope.finders")
        local pickers = require("telescope.pickers")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        
        local list = harpoon:list()
        local items = {}
        
        for i, item in ipairs(list.items) do
          table.insert(items, {
            index = i,
            filename = item.value,
            display = string.format("%d: %s", i, vim.fn.fnamemodify(item.value, ":t")),
          })
        end
        
        if #items == 0 then
          vim.notify("No Harpoon marks found", vim.log.levels.INFO)
          return
        end
        
        pickers.new({}, {
          prompt_title = "Harpoon Marks",
          finder = finders.new_table({
            results = items,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.display,
                ordinal = entry.filename,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              harpoon:list():select(selection.value.index)
            end)
            
            map("i", "<C-d>", function()
              local selection = action_state.get_selected_entry()
              harpoon:list():remove_at(selection.value.index)
              actions.close(prompt_bufnr)
              M.telescope_marks() -- Refresh the picker
            end)
            
            return true
          end,
        }):find()
      end
      
      -- Make functions globally available
      _G.harpoon_custom = M
      
      -- Auto-save harpoon state on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          harpoon:list():sync()
        end,
      })
      
      -- Notify successful loading
      if _G.nvim_config.env.is_standalone then
        vim.notify("Harpoon loaded successfully! 🎯", vim.log.levels.INFO)
      end
    end,
    
    keys = {
      -- Core harpoon functionality
      { "<leader>ha", "<cmd>lua _G.harpoon_custom.add_file()<cr>", desc = "Harpoon Add File" },
      { "<leader>hm", "<cmd>lua _G.harpoon_custom.toggle_quick_menu()<cr>", desc = "Harpoon Menu" },
      { "<leader>hr", "<cmd>lua _G.harpoon_custom.remove_file()<cr>", desc = "Harpoon Remove File" },
      { "<leader>hc", "<cmd>lua _G.harpoon_custom.clear_all()<cr>", desc = "Harpoon Clear All" },
      { "<leader>ht", "<cmd>lua _G.harpoon_custom.telescope_marks()<cr>", desc = "Harpoon Telescope" },
      
      -- Quick navigation to specific marks (1-9)
      { "<leader>h1", "<cmd>lua _G.harpoon_custom.nav_to(1)<cr>", desc = "Harpoon File 1" },
      { "<leader>h2", "<cmd>lua _G.harpoon_custom.nav_to(2)<cr>", desc = "Harpoon File 2" },
      { "<leader>h3", "<cmd>lua _G.harpoon_custom.nav_to(3)<cr>", desc = "Harpoon File 3" },
      { "<leader>h4", "<cmd>lua _G.harpoon_custom.nav_to(4)<cr>", desc = "Harpoon File 4" },
      { "<leader>h5", "<cmd>lua _G.harpoon_custom.nav_to(5)<cr>", desc = "Harpoon File 5" },
      { "<leader>h6", "<cmd>lua _G.harpoon_custom.nav_to(6)<cr>", desc = "Harpoon File 6" },
      { "<leader>h7", "<cmd>lua _G.harpoon_custom.nav_to(7)<cr>", desc = "Harpoon File 7" },
      { "<leader>h8", "<cmd>lua _G.harpoon_custom.nav_to(8)<cr>", desc = "Harpoon File 8" },
      { "<leader>h9", "<cmd>lua _G.harpoon_custom.nav_to(9)<cr>", desc = "Harpoon File 9" },
      
      -- Navigation between marks
      { "<C-h>", "<cmd>lua _G.harpoon_custom.nav_prev()<cr>", desc = "Harpoon Previous" },
      { "<C-l>", "<cmd>lua _G.harpoon_custom.nav_next()<cr>", desc = "Harpoon Next" },
      
      -- Alternative quick access
      { "<M-1>", "<cmd>lua _G.harpoon_custom.nav_to(1)<cr>", desc = "Harpoon File 1" },
      { "<M-2>", "<cmd>lua _G.harpoon_custom.nav_to(2)<cr>", desc = "Harpoon File 2" },
      { "<M-3>", "<cmd>lua _G.harpoon_custom.nav_to(3)<cr>", desc = "Harpoon File 3" },
      { "<M-4>", "<cmd>lua _G.harpoon_custom.nav_to(4)<cr>", desc = "Harpoon File 4" },
      { "<M-5>", "<cmd>lua _G.harpoon_custom.nav_to(5)<cr>", desc = "Harpoon File 5" },
    },
  },

  -- Flash.nvim - Modern replacement for hop.nvim with better performance
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Flash configuration for optimal performance
      labels = "etovxqpdygfblzhckisuran", -- Same as hop.nvim for consistency
      search = {
        multi_window = false, -- Limit to current window for performance
        forward = true,
        wrap = false,
        mode = "exact", -- Exact matching for speed
      },
      jump = {
        jumplist = true, -- Add jumps to jumplist
        pos = "start", -- Jump to start of match
        history = false, -- Don't save history for performance
        register = false, -- Don't save to register
        nohlsearch = false, -- Keep search highlighting
        autojump = true, -- Auto jump if only one match
      },
      label = {
        uppercase = true, -- Use uppercase labels for visibility
        exclude = "", -- Don't exclude any labels
        current = true, -- Include current position
        after = true, -- Show labels after matches
        before = false, -- Don't show labels before matches
        style = "overlay", -- Overlay style for labels
        reuse = "lowercase", -- Reuse lowercase letters
        distance = true, -- Show distance in labels
      },
      highlight = {
        backdrop = false, -- Don't dim backdrop for performance
        matches = true, -- Highlight matches
        priority = 5000, -- High priority for highlights
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      modes = {
        search = {
          enabled = true, -- Enable search mode
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
        },
        char = {
          enabled = true,
          config = function(opts)
            opts.autohide = opts.autohide == nil and vim.fn.mode(true):find("no") and vim.v.operator == "y"
          end,
          autohide = false,
          jump_labels = false,
          multi_line = true,
          label = { exclude = "hjkliardc" },
          keys = { "f", "F", "t", "T", ";", "," },
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
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
          },
        },
        treesitter_search = {
          jump = { pos = "range" },
          search = { multi_window = true, wrap = true, incremental = false },
          remote_op = { restore = true },
          label = { before = true, after = true, style = "inline" },
        },
        remote = {
          remote_op = { restore = true, motion = true },
        },
      },
      prompt = {
        enabled = true,
        prefix = { { "⚡", "FlashPromptIcon" } },
        win_config = {
          relative = "editor",
          width = 1, -- when <=1 it's a percentage of the editor width
          height = 1,
          row = -1, -- when negative it's an offset from the bottom
          col = 0, -- when negative it's an offset from the right
          zindex = 1000,
        },
      },
      remote_op = {
        restore = false, -- Don't restore for performance
        motion = false, -- Don't use motion for performance
      },
    },
    keys = {
      {
        "<space>hw",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump to word",
      },
      {
        "<space>hl",
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
        "<space>hc",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            mode = "char",
            search = { mode = "char" },
          })
        end,
        desc = "Flash jump to character",
      },
      {
        "<space>h/",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            mode = "search",
            search = { mode = "search" },
          })
        end,
        desc = "Flash jump with pattern",
      },
      {
        "<space>hf",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            mode = "char",
            search = { mode = "char", max_length = 1 },
            label = { after = { 0, 0 } },
            pattern = ".",
          })
        end,
        desc = "Flash jump to character (current line)",
      },
      {
        "<space>hv",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "\\w+",
          })
        end,
        desc = "Flash jump to visible words",
      },
      {
        "<space>hj",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
            action = function(match, state)
              state:hide()
              if match.pos[1] > vim.fn.line(".") then
                vim.api.nvim_win_set_cursor(0, { match.pos[1], match.pos[2] - 1 })
              end
            end,
          })
        end,
        desc = "Flash jump to line below",
      },
      {
        "<space>hk",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
            action = function(match, state)
              state:hide()
              if match.pos[1] < vim.fn.line(".") then
                vim.api.nvim_win_set_cursor(0, { match.pos[1], match.pos[2] - 1 })
              end
            end,
          })
        end,
        desc = "Flash jump to line above",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      
      -- Set up highlights to match the existing hop.nvim theme
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#c678dd", bold = true })
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#56b6c2", bold = true })
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#61afef", bold = true })
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#5c6370" })
      
      -- Notify successful loading
      if _G.nvim_config.env.is_standalone then
        vim.notify("Flash.nvim loaded successfully! (Replaced hop.nvim)", vim.log.levels.INFO)
      end
    end,
  },
}