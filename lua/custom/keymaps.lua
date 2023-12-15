local utils = require "core.utils"
local keymap = utils.keymap_set
local escapePair = utils.escapePair
local nxo = utils.nxo

keymap("v", "/", '"fy/\\V<C-R>f<CR>')
keymap("v", "*", '"fy/\\V<C-R>f<CR>')

keymap("i", "jj", "<ESC>", "Escape")

-- Easier line-wise movement
keymap(nxo, "gh", "g^")
keymap(nxo, "gl", "g$")

-- select until the end of the line
keymap("x", "v", "$h", "select until end")
-- don't yank on paste
keymap("x", "p", '"_dP', "don't yank on paste")

-- Whatever you delete, make it go away
keymap({ "n", "x" }, "c", '"_c')
keymap(nxo, "%", "gg0vG$")
keymap({ "n", "x" }, "C", '"_C')
keymap({ "n", "x" }, "S", '"_S', "Don't save to register")

keymap({ "n", "x" }, "x", '"_x')
keymap("x", "X", '"_c')
-- move over a closing element in insert mode
keymap("i", "<C-l>", function()
  return escapePair()
end, { desc = "move over a closing element in insert mode" })

keymap({ "n", "x" }, "*", "*N", { desc = "Search word or selection" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap(nxo, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap(nxo, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
