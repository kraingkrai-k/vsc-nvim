-- Common plugins used in both VS Code and Standalone

return {
  -- Surround (LazyVim standard)
  -- gsa: add, gsd: delete, gsr: replace
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },

  -- Comment toggling (LazyVim standard)
  -- gcc: line, gc: visual
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairs (LazyVim standard)
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },

  -- Flash - super fast navigation (LazyVim standard)
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
  },

  -- Spider - smart word movement (camelCase aware)
  -- ย้ายไป Alt key เพื่อให้ w/e/b เป็น native Vim (ฝึก standard ก่อน)
  -- native w/e/b = word boundary ปกติ (ใช้ได้ทุกเครื่อง)
  -- Alt-w/e/b = camelCase aware (bonus สำหรับ code)
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "<A-w>", function() require("spider").motion("w") end, mode = { "n", "o", "x" }, desc = "Spider-w (camelCase)" },
      { "<A-e>", function() require("spider").motion("e") end, mode = { "n", "o", "x" }, desc = "Spider-e (camelCase)" },
      { "<A-b>", function() require("spider").motion("b") end, mode = { "n", "o", "x" }, desc = "Spider-b (camelCase)" },
    },
    opts = {
      skipInsignificantPunctuation = true,
    },
  },
}
