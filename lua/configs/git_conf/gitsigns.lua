local map = require("utils.keymaps").set_buf_keymap

local options = {
  current_line_blame_formatter = " <author>:<author_time:%Y-%m-%d> - <summary>",
  worktree = vim.g.git_worktree,
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "▁", numhl = "GitSignsDeleteNr" },
    topdelete = {
      hl = "GitSignsDelete",
      text = "▔",
      numhl = "GitSignsDeleteNr",
    }, --  " "
    changedelete = {
      hl = "GitSignsDelete",
      text = "│",
      numhl = "GitSignsChangeNr",
    },
    untracked = { text = "│" },
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    map("n", "]x", function()
      if vim.wo.diff then
        return "]x"
      end
      vim.schedule(function()
        require("gitsigns").next_hunk()
      end)
      return "<Ignore>"
    end, {
      desc = "Jump to next hunk",
      expr = true,
    })

    map("n", "[x", function()
      if vim.wo.diff then
        return "[x"
      end
      vim.schedule(function()
        require("gitsigns").prev_hunk()
      end)
      return "<Ignore>"
    end, {
      desc = "Jump to prev hunk",
      expr = true,
    })
    map({ "n", "v" }, "<leader>gg", "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>gx", "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>gG", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>gX", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", "toggle blame line")
    map("n", "<leader>gv", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>gb", function()
      gs.blame_line { full = true }
    end, "Blame Line")
    map("n", "<leader>gd", gs.diffthis, "Diff This")
    map("n", "<leader>gD", function()
      gs.diffthis "~"
    end, "Diff This ~")
    map({ "o", "x" }, "ih", "<cmd>C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
}

return options
