local utils = require "core.utils"
local autocmd = vim.api.nvim_create_autocmd
local augroup = utils.create_augroup
local contains = vim.tbl_contains
local keymap = utils.keymap_set
local opt_local = vim.opt_local

local smart_close_filetypes = {
  "prompt",
  "qf",
  "quickfix",
  "git-conflict",
  "term",
  "lazygit",
  "dap-repl",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_watches",
  "dapui_repl",
  "undotree",
  "noice",
  "man",
  "messages",
  "undotree",
  "help",
  "NeogitStatus",
  "notify",
  "Trouble",
  "diffview",
  "oil",
  "telescope",
  "lazy",
  "Outline",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePreview",
}

-- use bash-treesitter-parser for zsh
local ft_as_bash = augroup "ftAsBash"
autocmd("BufRead", {
  group = ft_as_bash,
  pattern = { "*.env", ".zprofile", "*.zsh", ".zshenv", ".zshrc" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

-- Center the buffer after search in cmd mode
autocmd("CmdLineLeave", {
  callback = function()
    vim.api.nvim_feedkeys("zz", "n", false)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "HighlightedyankRegion", timeout = 500 }
  end,
})

-- Bring back to the last position
-- autocmd("BufReadPost", {
--   callback = function()
--     local last_pos = vim.fn.line "'\""
--     if last_pos > 0 and last_pos <= vim.fn.line "$" then
--       vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
--     end
--   end,
-- })

-- NOTE: should restore cursor position on the last one
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
local smart_close_buftypes = {}
local function smart_close()
  if vim.fn.winnr "$" ~= 1 then
    vim.api.nvim_win_close(0, true)
    vim.cmd "wincmd p"
  end
end

-- Close certain filetypes by pressing q.
autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local is_unmapped = vim.fn.hasmapto("q", "n") == 0
    local is_eligible = is_unmapped
      or vim.wo.previewwindow
      or contains(smart_close_buftypes, vim.bo.buftype)
      or contains(smart_close_filetypes, vim.bo.filetype)
    if is_eligible then
      keymap("n", "q", smart_close, { buffer = 0, nowait = true })
    end
  end,
})

-- local cursor_line = augroup "LocalCursorLine"
--
-- autocmd({ "BufNew", "BufEnter", "BufWinEnter" }, {
--   group = cursor_line,
--   pattern = smart_close_filetypes,
--   callback = function()
--     opt_local.number = false -- Display line numbers in the focussed window only
--     opt_local.relativenumber = false -- Display relative line numbers in the focussed window only
--     opt_local.cursorcolumn = false
--   end,
-- })
--
-- autocmd({ "BufLeave", "BufWinLeave" }, {
--   group = cursor_line,
--   pattern = smart_close_filetypes,
--   callback = function()
--     opt_local.number = true -- Display line numbers in the focussed window only
--     opt_local.relativenumber = true -- Display relative line numbers in the focussed window only
--     opt_local.cursorline = true -- Display a cursorline in the focussed window only
--     opt_local.cursorcolumn = true
--   end,
-- })

local disable_codespell = augroup "DisableCodespell"
autocmd({ "BufEnter" }, {
  group = disable_codespell,
  pattern = { "*.log", "" },
  callback = function()
    vim.diagnostic.disable()
  end,
})

-- wrap telescope previewwindow
local telescope_preview_wrap = augroup "WrapTelescopePreviewer"
autocmd("User", {
  group = telescope_preview_wrap,
  pattern = { "TelescopePreviewerLoaded" },
  command = "setlocal wrap",
  --   callback = function()
  --     vim.opt_local.wrap = true
  --   end,
})
