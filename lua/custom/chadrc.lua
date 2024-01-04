---@type ChadrcConfig
local M = {}
local statusline = require "custom.ui.statusline"

M.ui = {
  statusline = {
    theme = "vscode", -- minimal, vscode, default,  "vscode_colored"
    overriden_modules = function(modules)
      -- adding a module between 2 modules
      -- Use the table.insert function to insert at specific index
      -- This will insert a new module at index 2 and previous index 2 will become 3 now

      modules[2] = statusline.file_info()

      table.insert(
        modules,
        6,
        (function()
          return statusline.lsp_progress()
        end)()
      )
      table.insert(
        modules,
        10,
        (function()
          return statusline.line_percentage()
        end)()
      )
    end,
  },
  theme = "aquarium",
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
