local M = {}
local Telescope = require "utils.telescope"
local Buffers = require "utils.buffer"

-- local visual_selection =
--   require("custom.utils.visual_selection").get_visual_selection_text

-- In order to disable a default keymap, use
M.disabled = {
  i = {
    ["<C-h>"] = { "", "Move left" },
    ["<C-l>"] = { "", "Move right" },
    ["<C-j>"] = { "", "Move down" },
    ["<C-k>"] = { "", "Move up" },
  },

  n = {
    ["<leader>h"] = "",
    ["<C-a>"] = "",
    ["<C-s>"] = "",
    ["<esc>"] = "",
    ["<C-c>"] = "",
    ["<leader>b"] = { "" },
    ["<leader>ra"] = { "" },
    ["<leader>ff"] = { "" },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>xb"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>xus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging sidebar",
    },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>xgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>xgl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
  },
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>csj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags",
    },
    ["<leader>csy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags",
    },
  },
}

M.refactoring = {
  x = {
    ["<leader>ro"] = { "<cmd>Refactor<CR>" },
    ["<leader>rf"] = { "<cmd>Refactor extract_to_file<cr>", "extract to file" },
    ["<leader>rv"] = { "<cmd>Refactor extract_var<cr>", "extract var" },
    ["<leader>ri"] = {
      "<cmd>Refactor inline_var<cr>",
      "inline variable",
      -- mode = { "n", "x" },
    },
  },
  n = {
    ["<leader>ri"] = {
      "<cmd>Refactor inline_var<cr>",
      "inline variable",
      -- mode = { "n", "x" },
    },
    ["<leader>rb"] = {
      "<cmd>Refactor extract_block<cr>",
      "extract block",
    },
    ["<leader>rbf"] = {
      "<cmd>Refactor extract_block_to_file<cr>",
      "extract block to file",
    },
  },
  v = {
    ["<leader>rr"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      -- "<cmd>lua require('refactoring').select_refactor()<CR>",
      "Select refactor",
    },
  },
}

M.lsp = {
  n = {
    ["<c-]>"] = {
      Telescope.find("lsp_definitions", { jump_type = "vsplit", reuse_win = true }),
      "definition",
    },
    ["<leader>dd"] = { "<cmd>Telescope diagnostics<cr>", "diagnostics" },
    ["<leader>dn"] = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "diagnostics next",
    },
    ["<leader>dp"] = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "diagnostics prev",
    },
    ["<leader>dt"] = { "<cmd>TroubleToggle<cr>", "trouble" },
    ["<leader>dw"] = {
      "<cmd>Telescope lsp_workspace_diagnostics<cr>",
      "Workspace Diagnostics",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Goto prev",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },
    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },
  },
}

M.general = {
  n = {
    ["<leader>oo"] = {
      ':<C-u>call append(line("."),   repeat([""], v:count1))<CR>',
      "inset line",
    },
    ["<leader>OO"] = {
      ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
      "inset line",
    },
    ["<leader>hh"] = { "<cmd>nohlsearch<cr>", "Clear Highlight" },
    ["<leader>m"] = { "<cmd>messages<cr>", "messages" },
    ["<leader>M"] = { "<cmd>Mason<cr>", "Mason" },
    ["<leader>N"] = { "<cmd>Noice<cr>", "Noice" },
    ["<leader>L"] = { "<cmd>Lazy<cr>", "Lazy" },
    ["<leader>mm"] = { "<cmd>messages<cr>", "messages" },
    ["<leader>wh"] = {
      function()
        return Buffers.hide_window(0)
      end,
      "Hide Window",
    },
    ["<leader>wx"] = {
      function()
        return Buffers.close_window()
      end,
      "Close Window",
    },
    ["<leader>wX"] = {
      function()
        return Buffers.close_all_visible_window(false)
      end,
      "Close all windows but current",
    },
    --  TODO: 2024-02-15 13:25 PM - Implement this in the near
    -- future
    -- ["<leader>wV"] = {
    --   function()
    --     return Buffers.close_all_hidden_buffers()
    --   end,
    --   "Close all windows but current",
    -- },
    ["<leader>bH"] = {
      function()
        Buffers.close_all_empty_buffers()
      end,
      "Close hidden/empty buffers",
    },
    ["<leader>bx"] = {
      function()
        Buffers.close_buffer(0, false)
      end,
      "Close all buffers except current",
    },
    ["<leader>bX"] = {
      function()
        Buffers.close_all_buffers(true, true)
      end,
      "Close all buffers except current",
    },
    ["<leader>bR"] = {
      function()
        Buffers.reset()
      end,
      "Close all buf/win except current",
    },
    ["<leader>zz"] = { "<cmd>ZenMode<cr>", "zen mode" },
  },
}

M.glance = {
  n = {
    ["<leader>ld"] = {
      "<cmd>Glance definitions<cr>",
      "definitions",
    },
    ["<leader>lD"] = { "<cmd>Glance type_definitions<cr>", "type definitions" },
    ["<leader>li"] = { "<cmd>Glance implementations<cr>", "implementations" },
    ["<leader>lR"] = { "<cmd>Glance references<cr>", "References" },
  },
}

M.session = {
  n = {
    ["<leader>sS"] = { "<cmd>Autosession search<CR>", "Autosession search" },
  },
}

M.telescope = {
  n = {
    ["<leader><space>"] = { Telescope.find "files", "Find files" },
    ["<leader>p"] = {
      Telescope.find("files", { cwd = "%:p:h" }),
      "Find files current dir",
    },
    ["<leader>sa"] = {
      Telescope.find("files", { follow = true, no_ignore = true, hidden = true }),
      "Find all",
    },

    ["<leader>sP"] = {
      "<cmd> Telescope persisted<CR>",
      "List Sessions",
    },

    ["<leader>ss"] = {
      Telescope.find "live_grep",
      "[Root] Live grep",
    },
    ["<leader>s."] = {
      Telescope.find("live_grep", { cwd = "%:p:h" }),
      "[Cur] Live grep",
    },
    ["<leader>sx"] = { Telescope.find "git_status", "Open changed file" },
    ["<leader>bb"] = {
      Telescope.find("buffers", { cwd = false }),
      "[All] List buffers",
    },
    ["<leader>s,"] = {
      "<cmd>Telescope frecency<cr>",
      "[Root] Frecency",
    },
    ["<leader>sb"] = {
      Telescope.find "buffers",
      "[Root] List buffers",
    },
    ["<leader>sh"] = { "<cmd> Telescope harpoon marks<CR>", "Harpoon files" },
    ["<leader>sk"] = { Telescope.find "keymaps", "Keymaps" },
    ["<leader>so"] = {
      Telescope.find "oldfiles",
      "Find oldfiles",
    },
    ["<leader>sw"] = {
      function()
        require("telescope").extensions.windows.list()
      end,
      "Find windows",
    },
    ["<leader>sO"] = {
      Telescope.find("oldfiles", { cwd = false }),
      "[Root] Find oldfiles",
    },
    ["<leader>sp"] = { "<cmd> Telescope projects<CR>", "Find projects" },
    ["<leader>sz"] = { "<cmd> Telescope zoxide list<CR>", "Find zoxide" },
    ["<leader>sr"] = { Telescope.find "resume", "resume" },
    ["<leader>st"] = {
      Telescope.find "help_tags",
      "Vim Help Tags",
    },
    -- ["<leader>sT"] = {
    --   -- Telescope.find("help_tags" ),
    --   "<cmd> Telescope help_tags default_text="
    --     -- .. word_under_cursor
    --     .. vim.fn.expand "<cword>"
    --     .. "<CR>",
    --   "Vim Help Tags [Cur Word]",
    -- },
    ["<leader>s/"] = {
      Telescope.find "current_buffer_fuzzy_find",
      "Find in current buffer",
    },
    ["<leader>:"] = {
      Telescope.find "command_history",
      "Old files",
    },
    ["<leader>s*"] = {
      Telescope.find "grep_string",
      "Grep String [Root]",
    },
    ["<leader>*"] = {
      Telescope.find("grep_string", { cwd = false }),
      "Grep String",
    },
  },

  x = {
    ["<leader>s*"] = {
      Telescope.find "grep_string",
      "Grep String [Root]",
    },
    ["<leader>*"] = {
      Telescope.find("grep_string", { cwd = false }),
      "Grep String",
    },
  },

  i = {
    ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
  },
}

M.triptych = {
  n = {
    ["<leader>-"] = {
      "<cmd>Triptych<CR>",
      "File explorere [Triptych]",
    },
  },
}

M.nvterm = {
  n = {

    ["<leader>tb"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "New horizontal term",
    },

    ["<leader>tv"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "New vertical term",
    },
  },
}

M.focus = {

  n = {
    ["<leader>vv"] = {
      "<cmd>FocusSplitNicely<cr>",
      "Split Nicely",
    },

    ["<C-\\>"] = {
      "<cmd>FocusAutoresize<cr>",
      "Activate autoresise",
    },
    ["<leader>ww"] = {
      "<cmd>FocusMaxOrEqual<cr>",
      "Max window",
    },

    ["<leader>vr"] = {
      "<cmd>FocusSplitRight<cr>",
      desc = "Split Right",
    },

    ["<leader>vd"] = {
      "<cmd>FocusSplitDown<CR>",
      desc = "split horizontally",
    },
    ["<leader>="] = {
      "<cmd>FocusEqualise<CR>",
      "balance windows",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]x"] = {
      function()
        if vim.wo.diff then
          return "]x"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[x"] = {
      function()
        if vim.wo.diff then
          return "[x"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>gx"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>gg"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage hunk",
    },

    ["<leader>gv"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gG"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage buffer",
    },

    ["<leader>gX"] = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Toggle deleted",
    },

    ["<leader>gu"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo Stage Hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>gD"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
  x = {
    -- ["ih"] = {
    --   vim.cmd "Gitsigns select_hunk",
    --   "Select hunk",
    -- },
  },
  o = {
    -- ["ih"] = {
    --   vim.cmd "Gitsigns select_hunk",
    --   "Select hunk",
    -- },
  },
}

M.persisted = {
  plugin = true,
  n = {
    ["<leader>Ps"] = {
      "<cmd>SessionSave<cr>",
      "Save Session",
    },
    ["<leader>Pr"] = {
      "<cmd>SessionLoad<cr>",
      "Restore Load",
    },
    ["<leader>sP"] = { "<cmd>Telescope persisted<cr>", "Sessions" },
    ["<leader>Px"] = {
      "<cmd>SessionDelete<cr>",
      "Don't Save Current Session",
    },
  },
}

return M
