_G.statusline = {}
local fs = require "utils.fs"
local options = {
  diagnostics = {
    " 0 ",
    "󰅚 0 ",
  },
  default_icon = "󰈚 ",
  symbols = {
    modified = "● ",
    readonly = "🔒 ",
    unnamed = "[No Name]",
    newfile = "[New]",
  },
  file_status = true,
  newfile_status = false,
  path = 0,
  shorting_target = 40,
}
local function is_activewin()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

local assets = {
  dir = "󰉖 ",
  file = "󰈙 ",
}

local get_file_icon = function()
  local filename = vim.fn.expand "%:t"
  local extension = vim.fn.expand "%:e"
  local present, icons = pcall(require, "nvim-web-devicons")
  local icon = present and icons.get_icon(filename, extension) or assets.file
  return " " .. icon .. " "
end

function statusline.lsp_progress()
  local progress = require("configs.lsp.lsp-progress").message()
  -- local progress = require("/ utils.lsp.progress").lsp_progress()

  return string.format(
    "%s %s ",
    "%#St_LspProgress#",
    progress

    -- require("lsp-progress").progress {
    --   max_size = 80,
    --   format = function(messages)
    --     if #messages > 0 then
    --       return #messages > 0 and table.concat(messages, " ") or ""
    --     end
    --     return ""
    --   end,
    -- }
  )
end

function statusline.LSP_Diagnostics()
  local errors =
    #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
  local warnings =
    #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
  local hints =
    #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
  local info =
    #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

  errors = (errors and errors > 0) and ("󰅚 " .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and (" " .. warnings .. " ") or ""
  hints = (hints and hints > 0) and ("󰛩 " .. hints .. " ") or ""
  info = (info and info > 0) and (" " .. info .. " ") or ""

  local icons = string.format("%s%s%s%s", errors, warnings, hints, info)
  local diagnostic_icon = (vim.o.columns > 140 and icons or "")

  return diagnostic_icon
end

function statusline.line_percentage()
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  if curr_line == 1 then
    return "Top"
  elseif curr_line == lines then
    return "Bot"
  else
    return string.format("%2d%%%%", math.ceil(curr_line / lines * 99))
  end
end

function statusline.search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local result = vim.fn.searchcount { maxcount = 999, timeout = 250 }

  if result.incomplete == 1 or next(result) == nil then
    return ""
  end

  return string.format(
    "[%d/%d] ",
    result.current,
    math.min(result.total, result.maxcount)
  )
end

function statusline.file_info()
  local path_separator = package.config:sub(1, 1)
  local symbols = {}
  local filename = fs.filename()

  if filename ~= options.symbols.unnamed then
    if options.file_status then
      if vim.bo.modified then
        table.insert(symbols, options.symbols.modified)
      end
      if vim.bo.modifiable == false or vim.bo.readonly == true then
        table.insert(symbols, options.symbols.readonly)
      end
    end
  else
    filename = options.default_icon .. filename
  end

  if options.shorting_target ~= 0 then
    local windwidth = vim.go.columns or vim.fn.winwidth(0)
    local estimated_space_available = windwidth - options.shorting_target

    filename =
      fs.shorten_path(filename, path_separator, estimated_space_available)
  end

  if options.newfile_status and fs.is_new_file() then
    table.insert(symbols, options.symbols.newfile)
  end

  local file_symbol = (#symbols > 0 and " " .. table.concat(symbols, "") or "")
  return string.format("%s%s%s ", "%#StText# ", filename, file_symbol)
end

function statusline.macro()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register .. " "
  end
end

function statusline.cwd()
  local dir_name = "%#St_Mode# 󰉖 "
    -- .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    .. fs.shorten_path(fs.get_root(), "/", 0)
    .. " "
  return (vim.o.columns > 85 and dir_name) or ""
end

return statusline
