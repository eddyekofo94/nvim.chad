local M = {}
local Util = require "core.utils"

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
    ["<C-c>"] = "",
    ["<leader>b"] = { "" },
  },
}

M.lsp = {
  n = {
    -- d = {
    -- name = "+diagnostics",
    ["<leader>dd"] = { "<cmd>Telescope diagnostics<cr>", "diagnostics" },
    ["<leader>dn"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "diagnostics next" },
    ["<leader>dp"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "diagnostics prev" },
    ["<leader>dt"] = { "<cmd>TroubleToggle<cr>", "trouble" },
    ["<leader>dw"] = {
      "<cmd>Telescope lsp_workspace_diagnostics<cr>",
      "Workspace Diagnostics",
    },
  },
  -- },
}

M.general = {
  n = {
    ["<leader>oo"] = {
      ':<C-u>call append(line("."),   repeat([""], v:count1))<CR>',
      "inset line",
    },
    ["<leader>h"] = { '<cmd>let @/ = ""<cr>', "Clear Highlight" },
    -- ["<leader>h"] = { "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", "Clear Highlight" },
    ["<leader>m"] = { "<cmd>messages<cr>", "messages" },
    ["<leader>M"] = { "<cmd>Mason<cr>", "Mason" },
    ["<leader>N"] = { "<cmd>Noice<cr>", "Noice" },
    ["<leader>L"] = { "<cmd>Lazy<cr>", "Lazy" },
    ["<leader>mm"] = { "<cmd>messages<cr>", "messages" },
    ["<leader>OO"] = {
      ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
      "inset line",
    },
    ["<leader>W"] = { "<C-W>q", "Close Window" },
    ["<leader>z"] = { "<cmd>ZenMode<cr>", "zen mode" },
  },
}
-- Your custom mappings
M.telescope = {
  n = {
    ["<leader><space>"] = { Util.telescope "files", "Find files" },
    ["<leader>p"] = { Util.telescope("files", { cwd = "%:p:h" }), "Find files current dir" },
    ["<leader>sa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>ss"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>sx"] = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    ["<leader>bb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>sh"] = { "<cmd> Telescope harpoon marks<CR>", "Harpoon files" },
    ["<leader>sk"] = { "<cmd> Telescope keymaps<CR>", "Keymaps" },
    ["<leader>so"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>sp"] = { "<cmd> Telescope projects<CR>", "Find projects" },
    ["<leader>sz"] = { "<cmd> Telescope zoxide list<CR>", "Find zoxide" },
    ["<leader>sr"] = { "<cmd> Telescope resume<CR>", "resume" },
    ["<leader>st"] = {
      "<cmd>Telescope help_tags<cr>",
      "Vim Help Tags",
    },
    ["<leader>s/"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
    ["<leader>:"] = { "<cmd> Telescope command_history<CR>", "Old files" },
    ["<leader>s*"] = {
      Util.telescope "grep_string",
      "Grep String [Root]",
    },
    ["<leader>*"] = {
      Util.telescope("grep_string", { cwd = false }),
      "Grep String",
    },
  },

  i = {
    ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
    -- ...
  },
}

M.nvterm = {
  n = {

    ["<leader>th"] = {
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
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

M.persisted = {
  plugin = true,
  n = {
    ["<leader>Ss"] = {
      "<cmd>SessionSave<cr>",
      "Save Session",
    },
    ["<leader>Sr"] = {
      "<cmd>SessionLoad<cr>",
      "Restore Load",
    },
    ["<leader>sS"] = { "<cmd>Telescope persisted<cr>", "Sessions" },
    ["<leader>Sl"] = {
      '<cmd>lua require("persistence").load({ last = true })<cr>',
      "Restore Last Session",
    },
    ["<leader>Sx"] = {
      "<cmd>SessionDelete<cr>",
      "Don't Save Current Session",
    },
  },
}

return M
