local default_others = require "plugins.configs.others"
local utils = require "core.utils"

local plugins = {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  { "b0o/schemastore.nvim", event = "VeryLazy", ft = { "json" } },
  {
    "notjedi/nvim-rooter.lua",
    lazy = false,
    config = function()
      require("nvim-rooter").setup {
        fallback_to_parent = true,
      }
    end,
  },

  -- log highlight colours
  {
    "MTDL9/vim-log-highlighting",
    event = "VeryLazy",
    ft = "log",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "prettier",
        "stylua",
        "jsonls",
        "marksman",
        "yamlls",
        "pylsp",
        "bashls",
        "sqlls",
        "dockerls",
        "glint",
        "gopls",
        "clangd",
      },
    },
  },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = function()
      require "custom.configs.persisted"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>T", "<cmd>TodoQuickFix<cr>", desc = "Search TODO" },
      { "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", { desc = "Next todo comment" } },
      { "[t", "<cmd>lua require('todo-comments').jump_prev()<cr>", { desc = "Previous todo comment" } },
    },
    opts = require "custom.configs.todo-comments",
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cf", '<cmd>lua require("conform").format()<cr>', desc = "Format current file" },
    },
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      require "custom.configs.harpoon"
    end,
  },
  -- git
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      local opts_gitsigns = default_others.gitsigns

      opts_gitsigns = {
        current_line_blame_formatter = " <author>:<author_time:%Y-%m-%d> - <summary>",
      }

      opts_gitsigns.signs = require("custom.configs.gitsigns").signs

      opts_gitsigns.on_attach = function(bufnr)
        utils.load_mappings("gitsigns", { buffer = bufnr })
      end

      return opts_gitsigns
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    enabled = true,
    keys = {
      {
        "<leader>G",
        function()
          return vim.cmd [[LazyGit]]
        end,
        desc = "Lazygit",
      },
    },
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lcheylus/overlength.nvim",
    event = "BufReadPre",
    config = function()
      require("overlength").setup {
        bg = "#840000",
        default_overlength = 80, -- INFO: seems to not work
        disable_ft = { "help", "dashboard", "which-key", "lazygit", "term" },
      }
      require("overlength").set_overlength({ "go", "lua", "vim" }, 120)
      require("overlength").set_overlength({ "cpp", "bash" }, 80)
      require("overlength").set_overlength({ "rust", "python" }, 100)
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    -- can't use 'opts' because module has non standard name 'project_nvim'
    config = function()
      require("project_nvim").setup {
        patterns = {
          ".git",
          "package.json",
          "go.mod",
          "requirements.yml",
          "pyrightconfig.json",
          "pyproject.toml",
        },
        detection_methods = { "lsp", "pattern" },
        -- detection_methods = { "pattern" },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    -- INFO: disabled for now
    enabled = false,
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = require "custom.configs.illuminate",
  },
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "folke/twilight.nvim",
        config = function()
          require("twilight").setup {
            context = -1,
            treesitter = true,
          }
        end,
      },
    },
    config = require "custom.configs.zen",
  },
  {
    "stevearc/oil.nvim",
    config = true,
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        { desc = "Open parent directory" },
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    opts = {
      skipInsignificantPunctuation = true,
    },
    event = "VeryLazy",
    keys = { "w", "e", "b", "ge" },
    config = function()
      require "custom.configs.spider"
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    enable = true,
    event = { "WinNew" },
    opts = require "custom.configs.winsep",
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = true,
    opts = require "custom.configs.early-retirement",
  },
  {
    "beauwilliams/focus.nvim",
    event = "VimEnter",
    init = function()
      require("core.utils").load_mappings "focus"
    end,
    config = function()
      require "custom.configs.focus"
    end,
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    enabled = true,
    version = false,
    config = function()
      local animate = require "mini.animate"
      local timing = animate.gen_timing.linear { duration = 100, unit = "total" }
      animate.setup {
        cursor = {
          timing = animate.gen_timing.linear { duration = 10, unit = "total" },
        },
        resize = {
          enable = false,
          timing = animate.gen_timing.linear { duration = 10, unit = "total" },
        },
        scroll = {
          timing = timing,
        },
        open = { enable = true },
        close = { enable = false },
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "BufReadPre",
    opts = {
      search_method = "cover_or_next",
      highlight_duration = 2000,
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        highlight = "",
        find = "",
        find_left = "",
        update_n_lines = "",
      },
      custom_surroundings = {
        ["("] = { output = { left = "( ", right = " )" } },
        ["["] = { output = { left = "[ ", right = " ]" } },
        ["{"] = { output = { left = "{ ", right = " }" } },
        ["<"] = { output = { left = "<", right = ">" } },
        ["|"] = { output = { left = "|", right = "|" } },
        ["%"] = { output = { left = "<% ", right = " %>" } },
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "gopls",
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   init = function()
  --     require("core.utils").load_mappings("dap")
  --   end
  -- },
  -- {
  --   "dreamsofcode-io/nvim-dap-go",
  --   ft = "go",
  --   dependencies = "mfussenegger/nvim-dap",
  --   config = function(_, opts)
  --     require("dap-go").setup(opts)
  --     require("core.utils").load_mappings("dap_go")
  --   end
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require "plugins.configs.lspconfig"
  --     require "custom.configs.lspconfig"
  --   end,
  -- },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   ft = "go",
  --   opts = function()
  --     return require "custom.configs.null-ls"
  --   end,
  -- },
  -- {
  --   "olexsmir/gopher.nvim",
  --   ft = "go",
  --   config = function(_, opts)
  --     require("gopher").setup(opts)
  --     require("core.utils").load_mappings("gopher")
  --   end,
  --   build = function()
  --     vim.cmd [[silent! GoInstallDeps]]
  --   end,
  -- },
}
return plugins
