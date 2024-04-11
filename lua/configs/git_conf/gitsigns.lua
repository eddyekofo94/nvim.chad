local map = require("utils.keymaps").set_buf_keymap
local icons = require("utils").static.icons

local options = {
  current_line_blame_formatter = " <author>:<author_time:%Y-%m-%d> - <summary>",
  preview_config = {
    border = "solid",
    style = "minimal",
  },
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 100,
  },
  worktree = vim.g.git_worktree,
  signs = {
    add = { text = vim.trim(icons.GitSignAdd) },
    untracked = { text = vim.trim(icons.GitSignUntracked) },
    change = { text = vim.trim(icons.GitSignChange) },
    delete = { text = vim.trim(icons.GitSignDelete) },
    topdelete = { text = vim.trim(icons.GitSignTopdelete) },
    changedelete = { text = vim.trim(icons.GitSignChangedelete), numhl = "GitSignsChangeNr" },
    -- add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    -- change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    -- delete = { hl = "GitSignsDelete", text = "▁", numhl = "GitSignsDeleteNr" },
    -- topdelete = {
    --   hl = "GitSignsDelete",
    --   text = "▔",
    --   numhl = "GitSignsDeleteNr",
    -- }, --  " "
    -- untracked = { text = "│" },
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function opts(desc)
      return { expr = true, buffer = bufnr, desc = desc }
    end

    map({ "n", "x" }, "]x", function()
      if vim.wo.diff then
        return "]x"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, opts "Jump to next hunk")

    map({ "n", "x" }, "[x", function()
      if vim.wo.diff then
        return "[x"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, opts "Jump to prev hunk")
    map({ "n", "v" }, "<leader>gg", gs.stage_hunk, "Stage Hunk")

    map("x", "<leader>gg", function()
      gs.stage_hunk {
        vim.fn.line ".",
        vim.fn.line "v",
      }
    end, opts "Stage Hunk")

    map("x", "<leader>gx", function()
      gs.reset_hunk {
        vim.fn.line ".",
        vim.fn.line "v",
      }
    end, opts "Reset Hunk")

    map({ "n", "v" }, "<leader>gx", gs.reset_hunk, "Reset Hunk")
    map("n", "<leader>gG", gs.stage_buffer, opts "Stage Buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, opts "Undo Stage Hunk")
    map("n", "<leader>gX", gs.reset_buffer, opts "Reset Buffer")
    map("n", "<leader>gB", gs.toggle_current_line_blame, "toggle blame line")
    map("n", "<leader>gv", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>gb", function()
      gs.blame_line { full = true }
    end, opts "Blame Line")
    map("n", "<leader>gd", gs.diffthis, opts "Diff This")
    map("n", "<leader>gD", function()
      gs.diffthis "~"
    end, opts "Diff This ~")
    map({ "o", "x" }, "ih", "<cmd>C-U>Gitsigns select_hunk<CR>", opts "GitSigns Select Hunk")

    -- Text object
    map({ "o", "x" }, "ic", ":<C-U>Gitsigns select_hunk<CR>", opts "select hunk")
    map({ "o", "x" }, "ac", ":<C-U>Gitsigns select_hunk<CR>", opts "select hunk")
  end,
}

return options
