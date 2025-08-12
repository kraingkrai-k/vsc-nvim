-- Compatibility layer initialization
-- Handles environment-aware loading of compatibility modules

local plugin_loader = require("utils.plugin_loader")

-- Environment-specific compatibility loading
local compat_plugins = {}

-- Load VS Code compatibility if in VS Code environment
if plugin_loader.env.is_vscode then
  local vscode_plugins = require("plugins.compat.vscode")
  if type(vscode_plugins) == "table" then
    vim.list_extend(compat_plugins, vscode_plugins)
  end
end

-- Load Kiro compatibility if in Kiro environment
if plugin_loader.env.is_kiro then
  local kiro_plugins = require("plugins.compat.kiro")
  if type(kiro_plugins) == "table" then
    vim.list_extend(compat_plugins, kiro_plugins)
  end
end

-- Universal compatibility plugins that work in all environments
local universal_plugins = {
  -- Enhanced error handling for all environments
  {
    "folke/neoconf.nvim",
    enabled = function()
      return plugin_loader.env.is_standalone
    end,
    cmd = "Neoconf",
    config = function()
      require("neoconf").setup({
        -- Global settings
        global_settings = "neoconf.json",
        -- Local settings
        local_settings = ".neoconf.json",
        -- Import existing settings
        import = {
          vscode = true, -- Import from VS Code settings
          coc = false,   -- Don't import from coc.nvim
          nlsp = false,  -- Don't import from nlsp-settings
        },
        -- Live reload
        live_reload = true,
        -- File type associations
        filetype_jsonc = true,
      })
      
      vim.notify("Neoconf loaded for configuration management", vim.log.levels.DEBUG)
    end,
  },

  -- Optional mini.icons for better which-key integration
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Universal keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      { "echasnovski/mini.icons", optional = true },
      { "nvim-tree/nvim-web-devicons", optional = true },
    },
    opts = function()
      local base_opts = {
        -- Modern which-key configuration (v3 compatible)
        preset = "modern",
        delay = function(ctx)
          return ctx.plugin and 0 or 200
        end,
        -- New filter option (replaces ignore_missing)
        filter = function(mapping)
          -- Only show mappings with descriptions
          return mapping.desc and mapping.desc ~= ""
        end,
        spec = {}, -- Will be populated in config
        notify = true,
        -- New triggers format (must be table)
        triggers = {
          { "<auto>", mode = "nxsot" },
        },
        defer = function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>"
        end,
        plugins = {
          marks = not plugin_loader.env.is_vscode, -- VS Code handles marks differently
          registers = true,
          spelling = {
            enabled = not plugin_loader.env.is_vscode, -- VS Code has spell check
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = plugin_loader.env.is_standalone, -- Only in standalone
            nav = true,
            z = true,
            g = true,
          },
        },
        -- New win option (replaces window)
        win = {
          border = plugin_loader.env.is_standalone and "rounded" or "none",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 1, 2, 1, 2 },
          winblend = plugin_loader.env.is_kiro and 10 or 0,
          zindex = 1000,
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
        expand = 0,
        replace = {
          key = {
            function(key)
              return require("which-key.view").format(key)
            end,
          },
          desc = {
            { "<Plug>%(.*)%)", "%1" },
            { "^%+", "" },
            { "<[cC]md>", "" },
            { "<[cC][rR]>", "" },
            { "<[sS]ilent>", "" },
            { "^lua%s+", "" },
            { "^call%s+", "" },
            { "^:%s*", "" },
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          mappings = vim.g.have_nerd_font ~= false,
          rules = false,
          colors = true,
          keys = {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            D = "󰘳 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "󰁮",
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫",
            F2 = "󱊬",
            F3 = "󱊭",
            F4 = "󱊮",
            F5 = "󱊯",
            F6 = "󱊰",
            F7 = "󱊱",
            F8 = "󱊲",
            F9 = "󱊳",
            F10 = "󱊴",
            F11 = "󱊵",
            F12 = "󱊶",
          },
        },
        show_help = true,
        show_keys = true,
        disable = {
          buftypes = {},
          filetypes = {},
        },
      }
      
      return base_opts
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Environment-specific key group registration using the new spec format
      local key_groups = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>b", group = "Buffer" },
        { "<leader>w", group = "Save" },
        { "<leader>q", group = "Quit" },
        { "<leader>h", group = "Help" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>s", group = "Search" },
        { "<leader>r", group = "Replace" },
        { "<leader>t", group = "Toggle" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>n", group = "Notes" },
        { "<leader>p", group = "Project" },
        { "<leader>u", group = "UI" },
        { "<leader>v", group = "Visual" },
        { "<leader>z", group = "Fold" },
      }
      
      -- Add environment-specific groups
      if plugin_loader.env.is_kiro then
        vim.list_extend(key_groups, {
          { "<leader>a", group = "AI/Kiro" },
          { "<leader>sp", group = "Specs" },
          { "<leader>st", group = "Steering" },
          { "<leader>pk", group = "Kiro Config" },
        })
      elseif plugin_loader.env.is_vscode then
        vim.list_extend(key_groups, {
          { "<leader>d", group = "Multi-cursor" },
          { "<leader>z", group = "Focus" },
          { "<leader>pp", group = "Project Manager" },
        })
      elseif plugin_loader.env.is_standalone then
        vim.list_extend(key_groups, {
          { "<leader>x", group = "Diagnostics" },
          { "<leader>t", group = "Terminal" },
          { "<leader>l", group = "LSP" },
        })
      end
      
      -- Register all key groups using the new API
      wk.add(key_groups)
      
      local env_name = plugin_loader.env.is_vscode and "VS Code" or 
                      plugin_loader.env.is_kiro and "Kiro" or 
                      "Standalone"
      vim.notify(string.format("Which-key configured for %s", env_name), vim.log.levels.DEBUG)
    end,
  },

  -- Universal commenting support
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
        extra = not plugin_loader.env.is_vscode, -- Limit extra mappings in VS Code
      },
      pre_hook = nil,
      post_hook = nil,
    },
    config = function(_, opts)
      require("Comment").setup(opts)
      vim.notify("Comment.nvim loaded for all environments", vim.log.levels.DEBUG)
    end,
  },

  -- Environment detection utility plugin
  {
    "folke/neodev.nvim",
    enabled = function()
      return plugin_loader.env.is_standalone and plugin_loader.features.lsp_available()
    end,
    ft = "lua",
    opts = {
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
      },
      setup_jsonls = true,
      lspconfig = true,
      pathStrict = true,
    },
    config = function(_, opts)
      require("neodev").setup(opts)
      vim.notify("Neodev loaded for Lua development", vim.log.levels.DEBUG)
    end,
  },
}

-- Add universal plugins to the compatibility list
vim.list_extend(compat_plugins, universal_plugins)

-- Environment-specific fallback configurations
local fallback_configs = {
  -- Fallback for missing file explorer in extensions
  file_explorer = function()
    if not plugin_loader.env.is_standalone then
      vim.keymap.set("n", "<leader>e", function()
        plugin_loader.fallbacks.explorer_fallback()
      end, { desc = "File explorer (fallback)" })
    end
  end,
  
  -- Fallback for missing fuzzy finder
  fuzzy_finder = function()
    if not plugin_loader.env.is_standalone then
      vim.keymap.set("n", "<leader>ff", function()
        plugin_loader.fallbacks.finder_fallback()
      end, { desc = "Find files (fallback)" })
    end
  end,
  
  -- Fallback for missing LSP
  lsp_fallback = function()
    if not plugin_loader.features.lsp_available() then
      vim.keymap.set("n", "gd", function()
        plugin_loader.fallbacks.lsp_fallback()
      end, { desc = "Go to definition (fallback)" })
      
      vim.keymap.set("n", "gr", function()
        plugin_loader.fallbacks.lsp_fallback()
      end, { desc = "Go to references (fallback)" })
    end
  end,
}

-- Setup fallback configurations
for _, config_func in pairs(fallback_configs) do
  config_func()
end

-- Add environment info to startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local env_name = plugin_loader.env.is_vscode and "VS Code" or 
                    plugin_loader.env.is_kiro and "Kiro" or 
                    "Standalone"
    
    vim.notify(
      string.format("Compatibility layer loaded for %s environment", env_name),
      vim.log.levels.DEBUG,
      { title = "Plugin Compatibility" }
    )
  end,
})

return compat_plugins