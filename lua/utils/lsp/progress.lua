local utils = require "utils.general"
local buffer = require "utils.buffer"
local augroup = utils.create_augroup
local groupid = vim.api.nvim_create_augroup("StatusLine", {})

local M = {}
-- local spinner_icons =
--   { ' ', '󰪞 ', '󰪟 ', '󰪠 ', '󰪢 ', '󰪣 ', '󰪤 ', '󰪥 ' }
-- local spinners = { "󰸶", "󰸸", "󰸷", "󰸴", "󰸵", "󰸳" }

local spinner_icons = { " ", " ", " ", "󰺕 ", " ", " " }
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
---@type table<integer, { name: string, timestamp: integer, progress: vim.Ringbuf, type: 'begin'|'report'|'end' }>
local server_info_in_progress = {}

local message = {}

vim.api.nvim_create_autocmd("LspProgress", {
  desc = "Update LSP progress info for the status line.",
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(
        spinner_progress_keep,
        spinner_progress_keep,
        vim.schedule_wrap(vim.cmd.redrawstatus)
      )
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    server_info_in_progress[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      progress = message,
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

function M.lsp_progress()
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
    return not vim.b.spinner_state_changed
      or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  local client = vim.lsp.get_client_by_id(server_ids[1])
  local progress = client.progress

  if server_info_in_progress[server_ids[1]].type == "report" then
    message = progress
  end

  if
    #server_ids == 1 and server_info_in_progress[server_ids[1]].type == "end"
  then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done .. " " -- INFO: keep the space there
    end
  else
    local ms = vim.loop.hrtime() / 1000000
    local spinner_icon_progress =
      spinner_icons[math.floor(ms / 120) % #spinner_icons + 1]

    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    "%s %s",
    vim.b.spinner_icon,
    table.concat(
      vim.tbl_map(function(id)
        return server_info_in_progress[id].name
        -- .. server_info_in_progress[id].progress
      end, server_ids),
      ", "
    )
  )
end

return M
