-- Common plugins used in both VS Code and Standalone

return {
  -- Surround text objects
  { 
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  
  -- Repeat for surround
  { "tpope/vim-repeat", event = "VeryLazy" },
  
  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },
  
  -- Auto pairs
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --   config = function()
  --     require("nvim-autopairs").setup()
  --   end,
  -- },
  
  -- Flash - super fast navigation
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
      -- ปิด S ไว้ก่อน เพราะอาจงงกับการใช้งาน
      -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    config = function()
      require("flash").setup({
        modes = {
          char = { enabled = false }, -- ปิด f/F/t/T enhancement เพื่อไม่ conflict
        },
      })
    end,
  },
  
  -- Spider - smart word movement
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", function() require('spider').motion('w') end, mode = { "n", "o", "x" }, desc = "Spider-w" },
      { "e", function() require('spider').motion('e') end, mode = { "n", "o", "x" }, desc = "Spider-e" },
      { "b", function() require('spider').motion('b') end, mode = { "n", "o", "x" }, desc = "Spider-b" },
    },
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true
      })
    end,
  },
}