-------------------------------------- globals -----------------------------------------
-- INFO use this

-------------------------------------- options ------------------------------------------
-- vim.opt.title = true
-- vim.o.titlestring = "%<%F%=%l/%L - nvim"

vim.opt.errorbells = false

vim.opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.opt.listchars = {
  tab = "→\\ ",
  trail = "•",
  precedes = "«",
  extends = "»",
  eol = "↲",
  nbsp = "␣",
}

vim.opt.shortmess = {
  A = true, -- ignore annoying swap file messages
  c = true, -- Do not show completion messages in command line
  F = true, -- Do not show file info when editing a file, in the command line
  I = true, -- Do not show the intro message
  W = true, -- Do not show "written" in command line when writing
}

vim.o.wildmenu = true
vim.o.wildoptions = "pum"

-- Use ripgrep as grep tool
vim.o.grepprg = "rg --vimgrep --no-heading"
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Indenting

-- completion
vim.opt.pumheight = 10 -- Makes popup menu smaller

-- Numbers

vim.opt.signcolumn = "yes:1"
vim.opt.inccommand = "split"
vim.opt.splitkeep = "screen" -- topline
vim.o.history = 10000 -- Number of command-lines that are remembered
vim.opt.swapfile = true

vim.o.lazyredraw = false -- Faster scrolling

vim.opt.undodir = vim.fn.stdpath "data" .. "undo"

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescroll = 6

vim.opt.sessionoptions = "resize,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.cmd [[highlight HighlightedyankRegion cterm=reverse gui=reverse guifg=reverse guibg=reverse]]

vim.opt.list = true

vim.cmd [[set guicursor+=i-ci:ver30-Cursor-blinkwait500-blinkon400-blinkoff300]]
vim.cmd [[set guicursor+=n-v-c:blinkon10]]

vim.cmd [[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]]

-- BUG: not working
local number_cl = vim.api.nvim_get_hl(0, { name = "Number" })["fg"]
vim.api.nvim_set_hl(0, "WinSeparator", { fg = number_cl })
vim.api.nvim_set_hl(0, "OverLength", { bg = "#840000" })

-------------------------------------- autocmds ------------------------------------------
require "custom.autocommands"
-------------------------------------- keymaps ------------------------------------------
require "custom.keymaps"
-------------------------------------- commands ------------------------------------------
-- See how to use this?
local new_cmd = vim.api.nvim_create_user_command

-- new_cmd("NvChadUpdate", function()
--   require "nvchad.updater"()
-- end, {})
