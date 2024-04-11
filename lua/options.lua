require "nvchad.options"

-- add yours here!

local o = vim.o
local g = vim.g
local opt = vim.opt

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

g.has_ui = #vim.api.nvim_list_uis() > 0
o.cursorlineopt = "both" -- to enable cursorline!
opt.iskeyword:append "-"
vim.opt.errorbells = false
vim.opt.joinspaces = false

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- vim.g.loaded_python3_provider = 1

if g.modern_ui then
  opt.listchars:append { nbsp = "␣" }
  opt.fillchars:append {
    foldopen = "",
    foldclose = "",
    diff = "╱",
  }
end

vim.opt.listchars = {
  -- tab = "→\\ ",
  tab = "→ ",
  trail = "•",
  precedes = "«",
  extends = "»",
  eol = "↲",
  -- nbsp = "␣",
  nbsp = "░",
}

-- vim.opt.shortmess:append "sI"
vim.opt.shortmess = {
  o = true,
  A = true, -- ignore annoying swap file messages
  c = true, -- Do not show completion messages in command line
  F = true, -- Do not show file info when editing a file, in the command line
  I = true, -- Do not show the intro message
  W = true, -- Do not show "written" in command line when writing
}

vim.o.wildmenu = true
vim.o.wildoptions = "pum"

vim.opt.backupcopy = "yes"
vim.opt.undolevels = 1000
vim.opt.autoread = true

vim.opt.conceallevel = 0
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
opt.splitright = true
opt.splitbelow = true
vim.o.history = 10000 -- Number of command-lines that are remembered

-- Buffer
vim.opt.swapfile = false
vim.opt.fileformat = "unix"
vim.opt.autochdir = true
vim.opt.shiftround = true

-- opt.colorcolumn = "80"
opt.autowriteall = true
opt.mousemoveevent = true
opt.relativenumber = true

vim.o.lazyredraw = false -- Faster scrolling

-- vim.opt.wrap = false
vim.cmd [[set nowrap]] -- Display long lines as just one line

vim.opt.showmode = false

vim.opt.undodir = vim.fn.stdpath "data" .. "undo"
vim.opt.undofile = true
vim.opt.wrapscan = true

vim.opt.smoothscroll = true
vim.opt.statuscolumn = [[%!v:lua.require'ui.statuscolumn'.statuscolumn()]]

-- Recognize numbered lists when formatting text
opt.formatoptions:append "n"

-- Folding
vim.opt.foldlevel = 99
-- vim.opt.foldtext = [[v:lua.require'ui.folds'.foldtext()]]

-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = [[v:lua.require'ui.folds'.foldexpr()]]
else
  vim.opt.foldmethod = "indent"
end

vim.opt.scrolloff = 8
vim.opt.sidescroll = 6

-- make backspace behave in a sane manner
vim.opt.backspace = "indent,eol,start"

-- searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- enable auto indentation
vim.opt.autoindent = true

-- vim.opt.sessionoptions = "resize,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.sessionoptions = {
  "resize",
  "winpos",
  "winsize",
  "terminal",
  "localoptions",
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

vim.opt.list = true

opt.gcr = {
  "i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor",
  "i-ci:ver30-Cursor-blinkwait500-blinkon400-blinkoff300",
  "n-v:block-Curosr/lCursor-blinkon10",
  "o:hor50-Curosr/lCursor",
  "r-cr:hor20-Curosr/lCursor",
}

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append {
  "algorithm:histogram",
  "indent-heuristic",
}

-- Use system clipboard
opt.clipboard:append "unnamedplus"

-- Align columns in quickfix window
opt.quickfixtextfunc = [[v:lua.require'utils.misc'.qftf]]

opt.backup = false
opt.backupdir:remove "."
vim.opt.writebackup = false
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.startofline = true

-- Autom. save file before some action
-- vim.o.autowrite = true

vim.cmd [[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]]
