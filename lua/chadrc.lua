---@type ChadrcConfig
local M = {}
local statusline = require "ui.statusline"

M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  tabufline = {
    enabled = false,
  },
  statusline = {
    theme = "vscode", -- default/vscode/vscode_colored/minimal
    order = {
      "mode",
      "file",
      "search_count",
      "macro",
      "diagnostics",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "lsp",
      "treesitter",
      "cursor",
      "line_percentage",
      "cwd",
    },
    modules = {
      file = function()
        return statusline.file_info()
      end,
      search_count = function()
        return statusline.search_count()
      end,
      lsp_msg = function()
        return statusline.lsp_progress()
        -- return statusline.lsp_msg()
      end,
      git = function()
        return statusline.gitdiff()
      end,
      diagnostics = function()
        return statusline.LSP_Diagnostics()
      end,
      macro = function()
        return statusline.macro()
      end,
      treesitter = function()
        return statusline.treesitter_status()
      end,
      line_percentage = function()
        return statusline.line_percentage()
      end,
      cwd = function()
        return statusline.cwd()
      end,
    },
  },
  theme = "catppuccin",
  changed_themes = {
    catppuccin = {},
  },
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    FloatBorder = { link = "EndOfBuffer", bg = "None" },
    Enum = { link = "Macro" },
    Method = { link = "Normal" },
  },
}

M.base46 = {
  integrations = {
    "cmp",
    "git",
    "trouble",
    "dap",
    "notify",
    "statusline",
    "notify",
    "todo",
  },
}
-------------------------------------- snippets ------------------------------------------
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"

-------------------------------------- highlight ------------------------------------------
require "ui.highlights"

-------------------------------------- usercmds ------------------------------------------
require "usercommands"

-------------------------------------- autocmds ------------------------------------------
require "autocommands"

return M
