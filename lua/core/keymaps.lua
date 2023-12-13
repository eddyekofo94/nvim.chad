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

-- move over a closing element in insert mode
keymap("i", "<C-l>", function()
  return escapePair()
end, { desc = "move over a closing element in insert mode" })
