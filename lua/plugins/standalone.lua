-- Standalone Neovim UI and feature plugins

if vim.g.vscode then
  return {}
end

return {
  -- Colorscheme (Tokyo Night - LazyVim default)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        on_highlights = function(hl, c)
          -- path ใน picker (filename_first) เดิมเป็น #545c7e บนพื้น #1e2030 = contrast 2.5:1 แทบมองไม่เห็น
          -- fg_dark (#828bb8) = ~4.9:1 อ่านออก แต่ยังจางกว่าชื่อไฟล์
          hl.TelescopeResultsComment = { fg = c.fg_dark }
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } }, -- path จาก cwd เช่น src/app.controller.ts
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Buffer/tab line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          -- ไม่ใช้ bdelete! (ทิ้งงานที่ยังไม่ save) → Snacks.bufdelete ถามก่อน
          close_command = function(n) Snacks.bufdelete(n) end,
          right_mouse_command = function(n) Snacks.bufdelete(n) end,
          left_mouse_command = "buffer %d",
          separator_style = "thin",
          always_show_bufferline = true,
          max_name_length = 30, -- default 18 ตัดชื่อไฟล์ยาวเป็น app.controller.…
        },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        -- ขยายตามชื่อไฟล์ที่ยาวที่สุด (30–50 คอลัมน์) แทน 30 ตายตัว
        view = { width = { min = 30, max = 50 }, side = "left" },
        -- tree ตามไฟล์ที่กำลังเปิดอยู่เสมอ (highlight + กางโฟลเดอร์ให้) เหมือน VS Code
        update_focused_file = { enable = true },
        renderer = {
          group_empty = true,
          icons = {
            show = { file = true, folder = true, folder_arrow = true, git = true },
          },
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        git = { enable = true, ignore = false },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- fzf syntax in prompt: 'exact ^prefix suffix$ !negate
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- lazy-load ตอนเรียก :Telescope ด้วย (LSP keymap gr/gI/gy เรียกผ่าน command ไม่ใช่ keys)
    cmd = "Telescope",
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      -- custom (ไม่ใช่ LazyVim): รวมไฟล์ใน .gitignore ด้วย (node_modules, dist, practice/, .env)
      { "<leader>fF", "<cmd>Telescope find_files no_ignore=true<cr>", desc = "Find files (+ignored)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      -- Search (LazyVim standard)
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      {
        "<leader>sG",
        function() require("telescope.builtin").live_grep({ additional_args = { "--no-ignore" } }) end,
        desc = "Grep (+ignored)",
      },
      { "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", desc = "Word under cursor" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "v", desc = "Selection" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer lines" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols (file)" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols (project)" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- fd/rg เคารพ .gitignore อยู่แล้ว (node_modules, dist, ...) → กันแค่ .git/ ที่โผล่เพราะ hidden = true
          file_ignore_patterns = { "^%.git/", "/%.git/" },
          -- grep ค้นไฟล์ซ่อนด้วย (.github/, .env.example, .claude/) ให้ตรงกับ find_files hidden = true
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
            "--smart-case", "--hidden", "--glob=!**/.git/*",
          },
          -- จอกว้าง ≥ 120 คอลัมน์: list ซ้าย preview ขวา / แคบกว่านั้น: preview บน list เต็มความกว้าง
          layout_strategy = "flex",
          layout_config = {
            width = 0.9,
            height = 0.9,
            flex = { flip_columns = 120 },
            horizontal = { preview_width = 0.5 },
            vertical = { preview_height = 0.4 },
          },
          -- ชื่อไฟล์ขึ้นก่อน folder ตามหลัง (จาง) → อ่านชื่อไฟล์ได้ครบเสมอ
          path_display = { "filename_first" },
          mappings = {
            -- ซ่อน/แสดง preview → list ได้ความกว้างเต็ม (เหมือน <a-p> ของ snacks picker ใน LazyVim)
            i = { ["<M-p>"] = require("telescope.actions.layout").toggle_preview },
            n = { ["<M-p>"] = require("telescope.actions.layout").toggle_preview },
          },
        },
        pickers = {
          find_files = { hidden = true },
          -- ไฟล์ที่เพิ่งใช้อยู่บนสุด, ไม่แสดงไฟล์ที่เปิดอยู่ตอนนี้ (LazyVim standard)
          buffers = { sort_mru = true, ignore_current_buffer = true },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
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
        -- ชื่อคนแก้ + เวลา + commit message ท้ายบรรทัดปัจจุบัน (แบบ GitLens)
        -- ปิดชั่วคราว: :Gitsigns toggle_current_line_blame
        current_line_blame = true,
        current_line_blame_opts = { delay = 300 },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buf = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation (LazyVim standard: ]h/[h — ]c/[c ใช้กับ class ของ treesitter-textobjects)
          map("n", "]h", function()
            if vim.wo.diff then return vim.cmd.normal({ "]c", bang = true }) end
            gs.nav_hunk("next")
          end, { desc = "Next hunk" })
          map("n", "[h", function()
            if vim.wo.diff then return vim.cmd.normal({ "[c", bang = true }) end
            gs.nav_hunk("prev")
          end, { desc = "Prev hunk" })
          map("n", "]H", function() gs.nav_hunk("last") end, { desc = "Last hunk" })
          map("n", "[H", function() gs.nav_hunk("first") end, { desc = "First hunk" })

          -- Actions (LazyVim standard: <leader>gh*)
          map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
          map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
          map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
          map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
          map("n", "<leader>ghB", function() gs.blame() end, { desc = "Blame buffer" })
          map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Git blame" })
          map("n", "<leader>gd", gs.diffthis, { desc = "Git diff" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
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

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp", -- ต้องโหลดก่อน LSP start เพื่อส่ง completion capabilities
    },
    config = function()
      -- Diagnostics: Neovim 0.11 ปิด virtual_text เป็น default → เปิดให้เห็น error ท้ายบรรทัด
      vim.diagnostic.config({
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      -- LSP keymaps (LazyVim standard)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buf = ev.buf, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          -- nowait: 0.11 มี grn/grr/gra/gri เป็น default → ไม่งั้น gr ต้องรอ timeoutlen
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "References", nowait = true }))
          vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Type definition" }))
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))

          -- TypeScript code actions (LazyVim lang.typescript standard)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "vtsls" then
            local function action(kind)
              return function()
                vim.lsp.buf.code_action({ apply = true, context = { only = { kind }, diagnostics = {} } })
              end
            end
            vim.keymap.set("n", "<leader>co", action("source.organizeImports"), vim.tbl_extend("force", opts, { desc = "Organize imports" }))
            vim.keymap.set("n", "<leader>cM", action("source.addMissingImports.ts"), vim.tbl_extend("force", opts, { desc = "Add missing imports" }))
            vim.keymap.set("n", "<leader>cu", action("source.removeUnused.ts"), vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
          end
        end,
      })

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      -- Server configs: merge กับ defaults ของ nvim-lspconfig (lsp/*.lua) ไม่ต้องเขียน cmd/root_markers เอง
      vim.lsp.config("vtsls", {
        settings = {
          complete_function_calls = true,
          vtsls = {
            autoUseWorkspaceTsdk = true, -- ใช้ typescript version ของ project (node_modules)
            enableMoveToFileCodeAction = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- eslint: attach เฉพาะ project ที่มี eslint config, ใช้ eslint ใน node_modules ของ project
      vim.lsp.enable({ "vtsls", "eslint", "gopls", "lua_ls" })
    end,
  },

  -- Markdown rendering in buffer (headings, tables, checkboxes)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Snacks: images/mermaid (needs Kitty graphics terminal + mmdc), lazygit, bufdelete
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- LazyVim standard: lazygit ใน float, กด e ใน lazygit เปิดไฟล์ใน nvim ตัวนี้ (nvim-remote)
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      -- LazyVim standard: ขยาย window ปัจจุบันเต็มจอ / กดซ้ำเพื่อกลับ
      { "<leader>wm", function() Snacks.zen.zoom() end, desc = "Zoom window" },
    },
    opts = {
      lazygit = {},
      image = {
        enabled = true,
        -- cmux's embedded Ghostty lacks unicode placeholders: show images in a float on hover
        doc = { inline = vim.env.CMUX_BUNDLED_CLI_PATH == nil },
      },
    },
  },

  -- Claude Code IDE integration: Claude CLI เห็นไฟล์/บรรทัด/selection ที่เปิดอยู่ใน nvim (LazyVim extra ai.claudecode)
  -- Claude รันใน pane อื่น (cmux) → `claude --ide` หรือพิมพ์ /ide แล้วเลือก Neovim
  -- ไม่เปิด terminal ใน nvim: libvterm วาด TUI ของ Claude เพี้ยน (โดยเฉพาะสระ/วรรณยุกต์ไทย)
  {
    "coder/claudecode.nvim",
    -- โหลดตอน startup: server + lock file (~/.claude/ide/) ต้องมีก่อน /ide จาก terminal ภายนอกจะเห็น
    event = "VeryLazy",
    opts = {
      terminal = { provider = "none" },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "NvimTree" } },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- Mason for LSP server management
  {
    "mason-org/mason.nvim",
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
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "vtsls", "eslint", "gopls", "lua_ls" },
        -- enable เองใน nvim-lspconfig ด้านบน (กัน ts_ls ที่ยังติดตั้งอยู่ attach ซ้อนกับ vtsls)
        automatic_enable = false,
      })
    end,
  },

  -- Treesitter: syntax highlight/indent สำหรับ TS/TSX + ทำให้ flash `S` ใช้ได้
  -- main branch: ต้องการ Neovim 0.12+ และ tree-sitter-cli 0.26.1+ (brew install tree-sitter-cli)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- plugin ไม่รองรับ lazy-load
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "typescript", "tsx", "javascript", "jsdoc", "json", "yaml",
        "html", "css", "graphql", "prisma", "dockerfile", "bash", "regex",
        "lua", "luadoc", "vim", "vimdoc", "query", "go",
        "markdown", "markdown_inline",
      })

      -- main branch ไม่เปิด highlight/indent ให้เอง → start ทุก filetype ที่มี parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", {}),
        callback = function(ev)
          if not pcall(vim.treesitter.start, ev.buf) then return end
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if lang and vim.treesitter.query.get(lang, "indents") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- JSX-aware commentstring: gcc ใน JSX ได้ {/* */} (LazyVim standard)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Completion (LazyVim default)
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = { preset = "enter" }, -- <CR> accept, <C-n>/<C-p> เลือก, <C-space> เปิดเมนู
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Formatter: prettier จาก node_modules ของ project
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      -- global (ไม่ผูกกับ LSP) → format json/yaml/markdown/css ได้แม้ไม่มี LSP
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
      },
      formatters = {
        -- run เฉพาะ project ที่มี prettier config (ไม่ไป format repo ที่ไม่ได้ใช้ prettier)
        prettier = { require_cwd = true },
      },
      -- format on save ด้วย prettier เท่านั้น (ไม่ fallback ไป LSP ตอน save)
      format_on_save = { timeout_ms = 3000, lsp_format = "never" },
    },
  },

  -- Auto close/rename JSX tags (LazyVim default)
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Treesitter text objects + motions (LazyVim default): ]f/[f function, ]c/[c class, ]a/[a argument
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      local function attach(buf)
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not (lang and vim.treesitter.query.get(lang, "textobjects")) then return end
        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              -- diff mode: ]c/[c คือ next/prev change แบบ native
              if vim.wo.diff and key:find("[cC]") then return vim.cmd("normal! " .. key) end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, { buf = buf, silent = true, desc = method:gsub("_", " ") .. " " .. query })
          end
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTextobjects", {}),
        callback = function(ev) attach(ev.buf) end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },

  -- Extra text objects (LazyVim default): af/if function, ac/ic class, aa/ia argument, at/it tag, ...
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- word with case (camelCase parts)
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- function call ("usage")
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
  },

  -- Search & replace ทั้ง project (LazyVim default)
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },

  -- Diagnostics / quickfix list (LazyVim default)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- Test runner: Vitest (LazyVim test.core keys) — rstest ยังไม่มี neotest adapter
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-vitest") },
        status = { virtual_text = true },
        output = { open_on_run = true },
      })
    end,
    keys = {
      { "<leader>t", "", desc = "+test" },
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test (Neotest)" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
    },
  },
}
