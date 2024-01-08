local utils = require "custom.utils.keymaps"
local keymap = utils.set_keymap
local nxo = utils.nxo

keymap("v", "/", '"fy/\\V<C-R>f<CR>')
keymap("v", "*", '"fy/\\V<C-R>f<CR>')

keymap("i", "jj", "<ESC>", "Escape")
-- CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
keymap("i", "<C-c>", "<esc>")

-- Easier line-wise movement
keymap(nxo, "gh", "g^")
keymap(nxo, "gl", "g$")

keymap("n", "<S-x>", [[<Cmd>bdelete!<CR>]]) -- close all other buffers but this one

-- don't yank on paste
keymap("x", "p", '"_dP')

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- select until the end of the line
keymap("x", "v", "$h", "select until end")
-- don't yank on paste
keymap("x", "p", '"_dP', "don't yank on paste")

-- Whatever you delete, make it go away
keymap({ "n", "x" }, "c", '"_c')

keymap({ "n", "x" }, "C", '"_C')
keymap({ "n", "x" }, "S", '"_S', "Don't save to register")

keymap({ "n", "x" }, "x", '"_x')
keymap("x", "X", '"_c')

-- better up/down
-- INFO: don't know about this
-- keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move over a closing element in insert mode
keymap("i", "<C-l>", function()
  return utils.escapePair()
end, { desc = "move over a closing element in insert mode" })

keymap({ "n", "x" }, "*", "*N", { desc = "Search word or selection" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- keymap(nxo, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- keymap(nxo, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

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
