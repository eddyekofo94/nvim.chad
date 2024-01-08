_G.statusline = {}
local groupid = vim.api.nvim_create_augroup("StatusLine", {})

local function is_activewin()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

-- local spinner_icons =
--   { ' ', '󰪞 ', '󰪟 ', '󰪠 ', '󰪢 ', '󰪣 ', '󰪤 ', '󰪥 ' }
-- local spinners = { "󰸶", "󰸸", "󰸷", "󰸴", "󰸵", "󰸳" }

local spinner_icons = { " ", " ", " ", "󰺕 ", " ", " " }

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

local success_icon = {
  "󰄳 ",
  "󰄳 ",
  "󰄳 ",
}

local function get_succes_frame()
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #success_icon
  return string.format(success_icon[frame + 1])
end

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms

-- local spinner_icon_done = vim.trim(success_icon[1])
local spinner_icon_done = vim.trim(get_succes_frame())
local spinner_timer = vim.uv.new_timer()
---Id and additional info of language servers in progress
---@type table<integer, { name: string, timestamp: integer, type: 'begin'|'report'|'end' }>
local server_info_in_progress = {}

vim.api.nvim_create_autocmd("LspProgress", {
  desc = "Update LSP progress info for the status line.",
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(spinner_progress_keep, spinner_progress_keep, vim.schedule_wrap(vim.cmd.redrawstatus))
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    server_info_in_progress[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data.result.value.kind,
    } -- Update LSP progress data
    -- Clear client message after a short time if no new message is received
    vim.defer_fn(function()
      -- No new report since the timer was set
      local last_timestamp = (server_info_in_progress[id] or {}).timestamp
      if not last_timestamp or last_timestamp == now then
        server_info_in_progress[id] = nil
        if vim.tbl_isempty(server_info_in_progress) and spinner_timer then
          spinner_timer:stop()
        end
        vim.cmd.redrawstatus()
      end
    end, spinner_end_keep)
  end,
})

function statusline.lsp_progress()
  if vim.tbl_isempty(server_info_in_progress) then
    return ""
  end

  local buf = vim.api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info_in_progress) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then
    return ""
  end

  local now = vim.uv.now()
  ---@return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if #server_ids == 1 and server_info_in_progress[server_ids[1]].type == "end" then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done .. " " -- INFO: keep the space there
    end
  else
    -- INFO: a way to edit this?
    -- local spinner_icon_progress = spinner_icons[math.ceil(
    --   now / spinner_progress_keep
    -- ) % #spinner_icons + 1]

    local ms = vim.loop.hrtime() / 1000000
    local spinner_icon_progress = spinner_icons[math.floor(ms / 120) % #spinner_icons + 1]

    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    "%s %s %s ",
    "%#St_LspProgress#",
    table.concat(
      vim.tbl_map(function(id)
        return server_info_in_progress[id].name
      end, server_ids),
      ", "
    ),
    vim.b.spinner_icon
  )
end

-- local workspace_path = vim.lsp.buf.list_workspace_folders()[1]
-- local rel_path = vim.lsp.buf.list_workspace_folders()[1]
-- don't think it works as intended but I am happy with it
-- I wanted to return just the filename when not in focus
function statusline.filename()
  if is_activewin() then
    -- return "%#StText# " .. get_file_icon() .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "/" .. vim.fn.expand "%:."
    return "%#StText# " .. get_file_icon() .. vim.fn.expand "%:."
  else
    return vim.fn.expand "%:."
  end
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

  return string.format("[%d/%d] ", result.current, math.min(result.total, result.maxcount))
end

function statusline.file_info()
  local icon = "󰈚 "
  local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

  if name ~= "Empty " then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end

    name = " " .. vim.fn.expand "%:." .. " "
  end

  return "%#StText# " .. icon .. name
end

return statusline
