local utils = require "core.utils"
local keymap = utils.keymap_set
local nxo = utils.nxo

keymap(nxo, "w", function()
  require("spider").motion("w", { skipInsignificantPunctuation = false })
end, "Spider-w")
keymap(nxo, "e", "<cmd>lua require('spider').motion('e')<CR>", "Spider-e")
keymap(nxo, "b", "<cmd>lua require('spider').motion('b')<CR>", "Spider-b")
keymap(nxo, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
