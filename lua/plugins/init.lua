return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "dgagn/diagflow.nvim",
        event = "LspAttach",
        enabled = true,
        config = function()
          require("diagflow").setup {
            placement = "top",
            text_align = "left", -- 'left', 'right'
            show_sign = true, -- set to true if you want to render the diagnostic sign before the diagnostic message
            scope = "cursor", -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
          }
        end,
      },
      {
        "deathbeam/lspecho.nvim",
        enabled = false,
        config = function()
          require("lspecho").setup { echo = false, decay = 2000 }
        end,
      },
      {
        "linrongbin16/lsp-progress.nvim",
        enabled = false,
        config = function()
          require "configs.lsp.lsp-progress-extra"
        end,
      },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        keys = {
          {
            "<leader>nn",
            "<cmd>Navbuddy<CR>",
            desc = "Navbuddy open",
          },
        },
        opts = { lsp = { auto_attach = true } },
        config = function()
          require "configs.lsp.navbuddy"
        end,
      },
      {
        --  INFO: 2023-10-19 - this temporarily disables lsp to save the
        --  CPU usage...
        "hinell/lsp-timeout.nvim",
        enabled = true,
        init = function()
          vim.g.lspTimeoutConfig = {
            stopTimeout = 1000 * 60 * 5, -- ms, timeout before stopping all LSP servers
            startTimeout = 1000 * 10, -- ms, timeout before restart
            silent = false, -- true to suppress notifications
          }
        end,
      },
      {
        "dnlhc/glance.nvim",
        event = "LspAttach",
        config = function()
          require("glance").setup {}
        end,
      },
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup {
            library = { plugins = { "nvim-dap-ui" }, types = true },
          }
        end,
        lazy = true,
        ft = "lua",
      },
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lsp.lspconfig"
    end,
  },
  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
  {
    "altermo/ultimate-autopair.nvim",
    enabled = true,
    branch = "v0.6", --recomended as each new version will have breaking changes
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require "configs.ultimate-autopair"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "prochri/telescope-all-recent.nvim",
    lazy = false,
    enabled = true,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
      -- optional, if using telescope for vim.ui.select
      "stevearc/dressing.nvim",
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtins").find_files()
        end,
        desc = "Find files",
      },
    },
    config = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "kyoh86/telescope-windows.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
          require("window-picker").setup()
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      "jvgrootveld/telescope-zoxide",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "prochri/telescope-picker-history-action",
        opts = true,
      },
    },
    opts = function()
      return require "configs.telescope"
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    enabled = false,
    lazy = false,
    config = function()
      require("auto-dark-mode").setup {
        update_interval = 1000,
        set_dark_mode = function()
          vim.g.nvchad_theme = "gruvbox"
          vim.g.transparency = false
          require("nvchad.utils").replace_word('theme = "gruvbox_light"', 'theme = "gruvbox"')
          require("base46").load_all_highlights()
        end,
        set_light_mode = function()
          vim.g.nvchad_theme = "gruvbox_light"
          require("nvchad.utils").replace_word('theme = "gruvbox"', 'theme = "gruvbox_light"')
          vim.g.transparency = true
          require("base46").load_all_highlights()
        end,
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        -- INFO: additional snippets
        "mireq/luasnip-snippets",
        --  INFO: 2024-02-13 15:29 PM - This is disabled because it uses python which
        -- is disabled by nvchad
        enabled = false,
        init = function()
          require("luasnip_snippets.common.snip_utils").setup()
        end,
      },
      { "lukas-reineke/cmp-rg" },
      { "hrsh7th/cmp-buffer" }, -- Optional
      { "hrsh7th/cmp-cmdline" },
      { "ray-x/cmp-treesitter" },
      { "dmitmel/cmp-cmdline-history" },
      {
        "tzachar/cmp-fuzzy-path",
        dependencies = { "tzachar/fuzzy.nvim" },
      },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      {
        "onsails/lspkind.nvim",
        lazy = true,
        opts = {
          mode = "symbol",
          symbol_map = {
            Array = "󰅪",
            Boolean = "⊨",
            Class = "󰌗",
            Constructor = "",
            Key = "󰌆",
            Namespace = "󰅪",
            Null = "NULL",
            Number = "#",
            Object = "󰀚",
            Package = "󰏗",
            Property = "",
            Reference = "",
            Snippet = "",
            String = "󰀬",
            TypeParameter = "󰊄",
            Unit = "",
          },
          menu = {},
        },
        -- enabled = vim.g.icons_enabled,
        config = require "configs.lsp.lspkind",
      },
      -- { "onsails/lspkind-nvim" },
    },
    config = function()
      -- local conf = require "plugins.configs.cmp"
      -- require "plugins.configs.lspconfig"
      require "configs.nvim-cmp"
    end,
  },
  -- treesitter HERE
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "RRethy/nvim-treesitter-endwise",
        event = "FileType",
      },
      { "nvim-treesitter/nvim-treesitter-context", config = true },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- config = true,
        init = function() end,
      },
    },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "danymat/neogen",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  -- Automatically fill/change/remove xml-like tags
  { "windwp/nvim-ts-autotag", opts = {} },
  {
    "willothy/flatten.nvim",
    config = function()
      require "configs.flatten"
    end,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
  -- Better notifications and messagess
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      hover = {
        enabled = false,
      },
    },
    config = function()
      -- code
      require "configs.noice"
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "BufEnter",
    init = function()
      vim.notify = require "notify"
    end,
  },
  {
    "samjwill/nvim-unception",
    enabled = false,
    init = function()
      vim.g.unception_delete_replaced_buffer = true
      vim.api.nvim_create_autocmd("User", {
        pattern = "UnceptionEditRequestReceived",
        callback = function()
          require("nvterm.terminal").hide "horizontal"
        end,
      })
    end,
  },
  { "b0o/schemastore.nvim", event = "VeryLazy", ft = { "json" } },
  -- Global search and replace within cwd
  {
    "nvim-pack/nvim-spectre",
    enabled = true,
    event = "VeryLazy",
    config = function()
      local spectre = require "spectre"
      vim.keymap.set(
        "n",
        "<leader>S",
        -- spectre.toggle,
        '<cmd>lua require("spectre").toggle()<CR>',
        {
          desc = "Toggle Spectre",
        }
      )
      vim.keymap.set(
        "n",
        "<leader>sW",
        -- spectre.open_visual { select_word = true },
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        {
          desc = "Search current word",
        }
      )
      vim.keymap.set("v", "<leader>sW", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word",
      })
      vim.keymap.set(
        "n",
        "<leader>sM",
        -- spectre.open_file_search { select_word = true },
        '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        {
          desc = "Search on current file",
        }
      )
      -- vim.keymap.set("n", "<D-S-r>", spectre.toggle, {
      --   desc = "Toggle Spectre",
      -- })
      -- vim.keymap.set("v", "<D-S-r>", spectre.open_visual, {
      --   desc = "Toggle Spectre",
      -- })
    end,
  },
  {
    "notjedi/nvim-rooter.lua",
    lazy = false,
    enabled = true,
    config = function()
      require("nvim-rooter").setup {
        fallback_to_parent = true,
        exclude_filetypes = { "oil" },
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
        "vim-language-server",
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
    "stevearc/resession.nvim",
    -- enabled = vim.g.resession_enabled == true,
    enabled = false,
    lazy = true,
    event = "VimEnter",
    config = true,
    opts = {
      buf_filter = function(bufnr)
        return require("utils.buffer").is_restorable(bufnr)
      end,
      tab_buf_filter = function(tabpage, bufnr)
        return vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
      end,
      -- extensions = { astronvim = {} },
    },
  },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    enabled = true,
    config = function()
      require "configs.persisted"
    end,
  },
  {
    "rmagatti/auto-session",
    enabled = false,
    event = "VimEnter",
    config = function()
      require "configs.auto-session"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>T", "<cmd>TodoQuickFix<cr>", desc = "Search TODO" },
      {
        "]t",
        "<cmd>lua require('todo-comments').jump_next()<cr>",
        { desc = "Next todo comment" },
      },
      {
        "[t",
        "<cmd>lua require('todo-comments').jump_prev()<cr>",
        { desc = "Previous todo comment" },
      },
    },
    opts = require "configs.todo-comments",
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
    end,
    keys = {
      {
        "<leader>cf",
        '<cmd>lua require("conform").format()<cr>',
        desc = "Format current file",
      },
    },
    config = function()
      require "configs.conform"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      require "configs.harpoon"
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "VeryLazy",
    config = function()
      require("refactoring").setup {}
    end,
  },
  -- git
  {
    "FabijanZulj/blame.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>gB",
        "<cmd>ToggleBlame virtual<CR>",
        "Git blame side",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.git_conf.gitsigns"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = function()
      require "configs.git_conf.git-conflict"
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup()
    end,
  },
  {
    "smjonas/live-command.nvim",
    event = "CmdlineEnter",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },
  {
    "nguyenvukhang/nvim-toggler",
    keys = {
      { "<leader>ii", desc = "Toggle Word" },
    },
    config = function()
      require("nvim-toggler").setup {
        remove_default_keybinds = true,
      }
      vim.keymap.set({ "n", "v" }, "<leader>ii", require("nvim-toggler").toggle, { desc = "Toggle a Word" })
    end,
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require "configs.git_conf.neogit"
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
          "Makefile",
          "pom.xml",
          "requirements.yml",
          "pyrightconfig.json",
          "pyproject.toml",
        },
        detection_methods = { "lsp", "pattern" },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- @type Flash.Config
    opts = {
      search = {
        multi_window = false,
      },
    },
    keys = require "configs.flash",
  },
  {
    "RRethy/vim-illuminate",
    -- INFO: disabled for now
    -- enabled = false,
    event = "BufWinEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = require "configs.illuminate",
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "andymass/vim-matchup",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    opts = {},
    cmd = {
      "MCstart",
      "MCvisual",
      "MCclear",
      "MCpattern",
      "MCvisualPattern",
      "MCunderCursor",
    },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>mc",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {
      show_numbers = true,
      show_cursorline = true,
      number_only = false,
      centered_peeking = true,
    },
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
    config = require "configs.zen",
  },

  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("guess-indent").setup(opts)
      vim.cmd.lua {
        args = { "require('guess-indent').set_from_buffer('auto_cmd')" },
        mods = { silent = true },
      }
    end,
  },

  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require "configs.git_conf.git-worktree"
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    -- event = "VeryLazy",
    lazy = false,
    opts = require("configs.ufo").opts,
    init = require("configs.ufo").init(),
    config = function(opts)
      require("configs.ufo").config(opts)
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufWinEnter",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
    opts = {
      user_default_options = {
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        mode = "virtualtext",
      },
    },
  },
  {
    "arsham/indent-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "arsham/arshlib.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = true,
    -- keys = { "]i", "[i", { "v", "ii" }, { "o", "ii" } },
    -- or to provide configuration
    -- config = { normal = {..}, textobj = {..}},
  },
  {
    -- INFO: does this work?
    "ironhouzi/starlite-nvim",
    event = "WinEnter",
    config = function()
      local map = vim.keymap.set
      local default_options = { silent = true }
      map("n", "*", ":lua require'starlite'.star()<cr>", default_options)
      map("n", "g*", ":lua require'starlite'.g_star()<cr>", default_options)
      map("n", "#", ":lua require'starlite'.hash()<cr>", default_options)
      map("n", "g#", ":lua require'starlite'.g_hash()<cr>", default_options)
    end,
  },
  {
    "stevearc/oil.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require "configs.oil"
    end,
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
      require "configs.spider"
    end,
  },
  {
    "ashfinal/qfview.nvim",
    event = "UIEnter",
    opts = {},
  },
  {
    "gabrielpoca/replacer.nvim",
    event = "VeryLazy",
    opts = { rename_files = true },
    keys = {
      {
        "<leader>qf",
        function()
          require("replacer").run()
        end,
        desc = "run replacer.nvim",
      },
      {
        "<leader>qs",
        function()
          require("replacer").save()
        end,
        desc = "save replacer.nvim",
      },
    },
  },
  {
    "ten3roberts/qf.nvim",
    enabled = false,
    config = function()
      require("qf").setup {}
    end,
  },
  {
    -- INFO: jj == esc
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = true,
    branch = "main", -- change to alpha if satisfied with its updates
    event = { "WinNew" },
    opts = require "configs.winsep",
    config = true,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = true,
    opts = require "configs.early-retirement",
  },
  {
    "beauwilliams/focus.nvim",
    event = "VimEnter",
    config = function()
      require "configs.focus"
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
    "echasnovski/mini.trailspace",
    version = "*",
    event = "BufEnter",
    config = function()
      require("mini.trailspace").setup()
    end,
  },
  {
    "folke/lsp-trouble.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- mapped to <space>lt -- this shows a list of diagnostics
      require("trouble").setup {
        height = 12, -- height of the trouble list
        mode = "document_diagnostics",
        use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
        action_keys = {
          -- key mappings for actions in the trouble list
          close = "q", -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
          jump_close = { "o" }, -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- preview item
          next = "j", -- next item
        },
      }
    end,
    keys = {
      {
        "<leader>dt",
        "<cmd>TroubleToggle<cr>",
        desc = "Trouble Toggle",
      },
    },
  },
  {
    "simonmclean/triptych.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      { "<leader>-", "<cmd>Triptych<CR>", desc = "File explorere [Triptych]" },
    },
    config = function()
      require "configs.triptych"
    end,
  },
  {
    "echasnovski/mini.surround",
    enabled = false,
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
  {
    "echasnovski/mini.bufremove",
    version = "*",
    -- event = "VeryLazy",
    lazy = false,
    config = function()
      require("mini.bufremove").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" } },
      { "S", mode = "x" },
    },
    config = function()
      require "configs.nvim-surround"
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
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
          require("dap-go").setup(opts)
        end,
      },
    },
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
