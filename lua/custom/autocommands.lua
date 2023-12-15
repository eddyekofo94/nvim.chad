local autocmd = vim.api.nvim_create_autocmd
local augroup = require("core.utils").create_augroup

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

-- Highlight on yank
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "HighlightedyankRegion", timeout = 500 }
  end,
})

-- Bring back to the last position
autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line "'\""
    if last_pos > 0 and last_pos <= vim.fn.line "$" then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end,
})
