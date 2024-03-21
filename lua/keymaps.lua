--  INFO: Utils
local utils = require "utils.keymaps"
local utils_buffer = require "utils.buffer"
local keymap = utils.set_keymap
local nxo = utils.nxo
local maps = require("utils").empty_map_table()
local set_leader_keymap = utils.set_leader_keymap
local Telescope = require "utils.telescope"
local Buffers = require "utils.buffer"

local Keymap = {}

-- set_leader_keymap("space", Telescope.find "files", "Search ")

-- INFO: Disable mappings
local nomap = vim.keymap.del

nomap("i", "<C-k>")
nomap("i", "<C-l>")
nomap("i", "<C-j>")
nomap("i", "<C-h>")

nomap("n", "<C-k>")

Keymap.__index = Keymap
function Keymap.new(mode, lhs, rhs, opts)
  local action = function()
    local merged_opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, merged_opts)
  end
  return setmetatable({ action = action }, Keymap)
end

function Keymap:bind(nextMapping)
  self.action()
  return nextMapping
end

function Keymap:execute()
  self.action()
end

vim.keymap.set({ "n", "x" }, "<Space>", "<Ignore>")

-- Search always center
Keymap.new("n", "<C-u>", "zz<C-u>")
  :bind(Keymap.new("n", "<C-d>", "zz<C-d>"))
  :bind(Keymap.new("n", "{", "zz{"))
  :bind(Keymap.new("n", "}", "zz}"))
  :bind(Keymap.new("n", "n", "zzn"))
  :bind(Keymap.new("n", "N", "zzN"))
  :bind(Keymap.new("n", "<C-i>", "zz<C-i>"))
  :bind(Keymap.new("n", "<C-o>", "zz<C-o>"))
  :bind(Keymap.new("n", "%", "zz%"))
  :bind(Keymap.new("n", "*", "zz*"))
  :bind(Keymap.new("n", "#", "zz#"))
  :execute()

keymap("n", "<C-a>", ": %y+<CR>", "COPY EVERYTHING/ALL")

-- keymap("n", "<C-s>", ":w!<CR>", "Save file")

keymap("v", "/", '"fy/\\V<C-R>f<CR>')
keymap("v", "*", '"fy/\\V<C-R>f<CR>')

-- INFO: using:   "max397574/better-escape.nvim",
-- keymap("i", "jj", "<ESC>", "Escape")

keymap("i", "<C-c>", "<esc>", "CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.")

keymap(nxo, "gh", "g^", " move to start of line")
keymap(nxo, "gl", "g$", " move to end of line")

keymap("x", "p", '"_dP', "don't yank on paste")

-- keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
-- keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- select until the end of the line
keymap("x", "v", "$h", "select until end")

keymap("x", "p", '"_dP', "don't yank on paste")

-- Whatever you delete, make it go away
keymap({ "n", "x" }, "c", '"_c')

keymap({ "n", "x" }, "C", '"_C')
keymap({ "n", "x" }, "S", '"_S', "Don't save to register")

keymap({ "n", "x" }, "x", '"_x')
keymap("x", "X", '"_c')

keymap("n", "<ESC>", function()
  vim.cmd "nohl"
end, {
  desc = "Clear highlight from search and close notifications",
  silent = true,
})

-- better up/down
-- INFO: don't know about this
-- keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move over a closing element in insert mode
keymap("i", "<C-l>", function()
  return utils.escapePair()
end, "move over a closing element in insert mode")

keymap("n", "<M-l>", function()
  return utils.escapePair()
end, "move over a closing element in normal mode")

keymap({ "n", "x" }, "*", "*N", "Search word or selection")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- keymap(nxo, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- keymap(nxo, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

keymap("n", "i", function()
  if #vim.fn.getline "." == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "rebind 'i' to do a smart-indent if its a blank line" })

keymap("n", "dd", function()
  if vim.api.nvim_get_current_line():match "^%s*$" then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, desc = "Don't yank empty lines into the main register" })

-- Abbreviations
keymap("!a", "ture", "true")
keymap("!a", "Ture", "True")
keymap("!a", "flase", "false")
keymap("!a", "false", "false")
keymap("!a", "Flase", "False")
keymap("!a", "False", "False")
keymap("!a", "lcaol", "local")
keymap("!a", "lcoal", "local")
keymap("!a", "local", "local")
keymap("!a", "sahre", "share")
keymap("!a", "saher", "share")
keymap("!a", "balme", "blame")

vim.api.nvim_create_autocmd("CmdlineEnter", {
  once = true,
  callback = function()
    utils.command_abbrev("S", "%s")
    utils.command_abbrev(":", "lua")
    utils.command_abbrev("man", "Man")
    utils.command_abbrev("ep", "e%:p:h")
    utils.command_abbrev("vep", "vs%:p:h")
    utils.command_abbrev("sep", "sp%:p:h")
    utils.command_abbrev("tep", "tabe%:p:h")
    utils.command_abbrev("rm", "!rm")
    utils.command_abbrev("mv", "!mv")
    utils.command_abbrev("mkd", "!mkdir")
    utils.command_abbrev("mkdir", "!mkdir")
    utils.command_abbrev("touch", "!touch")
    return true
  end,
})

---@param linenr integer? line number
---@return boolean
local function is_wrapped(linenr)
  if not vim.wo.wrap then
    return false
  end
  linenr = linenr or vim.fn.line "."
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  return vim.fn.strdisplaywidth(vim.fn.getline(linenr) --[[@as string]]) >= wininfo.width - wininfo.textoff
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped(key, remap)
  return function()
    return is_wrapped() and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_cur_or_next_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and (is_wrapped() or is_wrapped(vim.fn.line "." + 1)) and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_cur_or_prev_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and (is_wrapped() or is_wrapped(vim.fn.line "." - 1)) and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_first_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and is_wrapped(1) and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_last_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and is_wrapped(vim.fn.line "$") and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_eol(key, remap)
  local remap_esc = vim.api.nvim_replace_termcodes(remap, true, true, true)
  return function()
    if not is_wrapped() then
      return key
    end
    vim.api.nvim_feedkeys(remap_esc, "nx", false)
    return vim.fn.col "." == vim.fn.col "$" - 1 and key or remap
  end
end

keymap({ "n", "x" }, "j", map_wrapped_cur_or_next_line_nocount("j", "gj"), { expr = true })
keymap({ "n", "x" }, "k", map_wrapped_cur_or_prev_line_nocount("k", "gk"), { expr = true })
keymap({ "n", "x" }, "<Down>", map_wrapped_cur_or_next_line_nocount("<Down>", "g<Down>"), { expr = true })
keymap({ "n", "x" }, "<Up>", map_wrapped_cur_or_prev_line_nocount("<Up>", "g<Up>"), { expr = true })
keymap({ "n", "x" }, "gg", map_wrapped_first_line_nocount("gg", "gg99999gk"), { expr = true })
keymap({ "n", "x" }, "G", map_wrapped_last_line_nocount("G", "G99999gj"), { expr = true })
keymap({ "n", "x" }, "<C-Home>", map_wrapped_first_line_nocount("<C-Home>", "<C-Home>99999gk"), { expr = true })
keymap({ "n", "x" }, "<C-End>", map_wrapped_last_line_nocount("<C-End>", "<C-End>99999gj"), { expr = true })
keymap({ "n", "x" }, "0", map_wrapped("0", "g0"), { expr = true })
keymap({ "n", "x" }, "$", map_wrapped_eol("$", "g$"), { expr = true })
keymap({ "n", "x" }, "^", map_wrapped("^", "g^"), { expr = true })
keymap({ "n", "x" }, "<Home>", map_wrapped("<Home>", "g<Home>"), { expr = true })
keymap({ "n", "x" }, "<End>", map_wrapped_eol("<End>", "g<End>"), { expr = true })

-- maps.n["<leader>bc"] = {
--   function()
--     utils_buffer.close_buffer()
--   end,
--   desc = "Close buffer",
-- }

maps.n["<leader>bsp"] = {
  function()
    utils_buffer.sort "full_path"
  end,
  desc = "By full path",
}

maps.n["<leader>bsi"] = {
  function()
    utils_buffer.sort "bufnr"
  end,
  desc = "By buffer number",
}

maps.n["<leader>bsm"] = {
  function()
    utils_buffer.sort "modified"
  end,
  desc = "By modification",
}

maps.n["<S-x>"] = {
  function()
    utils_buffer.close_buffer(0, true)
  end,
  desc = "Force close buffer",
}

-- maps.n["<leader>ff"] = {
--   function()
--     require("telescope.builtins").find_files()
--   end,
--   desc = "find files",
-- }

utils.set_mappings(maps)
