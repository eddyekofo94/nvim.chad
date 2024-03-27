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
  extended_integrations = { "trouble", "dap", "notify", "todo" },
  statusline = {
    theme = "vscode", -- default/vscode/vscode_colored/minimal
    order = {
      "mode",
      "file",
      "search_count",
      "diagnostics",
      "git",
      "macro",
      "%=",
      "lsp_msg",
      "%=",
      "lsp",
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
      diagnostics = function()
        return statusline.LSP_Diagnostics()
      end,
      macro = function()
        return statusline.macro()
      end,
      line_percentage = function()
        return statusline.line_percentage()
      end,
      cwd = function()
        return statusline.cwd()
      end,
    },
    overriden_modules = function(modules)
      -- adding a module between 2 modules
      -- Use the table.insert function to insert at specific index
      -- This will insert a new module at index 2 and previous index 2 will become 3 now

      modules[1] = statusline.file_info()
      modules[4] = statusline.LSP_Diagnostics()

      table.insert(
        modules,
        4,
        (function()
          return statusline.search_count()
        end)()
      )
      table.insert(
        modules,
        5,
        (function()
          return statusline.macro()
        end)()
      )
      table.insert(
        modules,
        8,
        (function()
          return statusline.lsp_progress()
        end)()
      )
      table.insert(
        modules,
        11,
        (function()
          return statusline.line_percentage()
        end)()
      )
      modules[17] = statusline.cwd()
    end,
  },
  theme = "tundra",
  changed_themes = {
    tundra = {},
  },
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    FloatBorder = { link = "EndOfBuffer", bg = "None" },
    Enum = { link = "Macro" },
    Method = { link = "Normal" },
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
