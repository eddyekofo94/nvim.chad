local M = {}

local fs = require "utils.fs"
local root_patterns, get_root = fs.root_patterns, fs.get_root

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

local function is_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree"

  return vim.v.shell_error == 0
end
local function live_grep_from_project_git_root()
  local function is_git_repo()
    vim.fn.system "git rev-parse --is-inside-work-tree"

    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require("telescope.builtin").live_grep(opts)
end

-- this will return a function that calls telescope.
-- cwd will default to utils.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.find(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
    if builtin == "files" then
      return M.project_files(opts)
    end
    require("telescope.builtin")[builtin](opts)
  end
end

M.project_files = function(opts)
  -- local opts = {} -- define here if you want to define something
  local builtin = require "telescope.builtin"
  local current = vim.api.nvim_get_current_win()

  local cwd = (opts.cwd or vim.uv.cwd())
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system "git rev-parse --is-inside-work-tree"
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if not is_inside_work_tree[cwd] then
    -- if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. "/.git") then -- info: working
    opts.show_untracked = true
    opts.no_ignore = false
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
  return builtin
end

M.send_to_harpoon_action = function(prompt_bufnr)
  local actions_state = require "telescope.actions.state"
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local ok, mark = pcall(require, "harpoon.mark")

  if not ok then
    return
  end

  if #picker:get_multi_selection() < 1 then
    mark.add_file(picker:get_selection()[1])
    return
  end

  for _, entry in ipairs(picker:get_multi_selection()) do
    mark.add_file(entry[1])
  end
end

return M
