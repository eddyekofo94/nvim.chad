local gitsigns = {
  signs = {
    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "GitSignsDelete", text = "│ ", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "GitSignsDelete", text = " ", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsChangeNr" },
    untracked = { text = "│" },
  },
}

return gitsigns
