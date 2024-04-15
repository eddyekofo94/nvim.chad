local utils = require "utils.general"
local utils_buffer = require "utils.buffer"
local keymap = require("utils.keymaps").set_keymap
local fs = require "utils.fs"

local autocmd = vim.api.nvim_create_autocmd
local augroup = utils.create_augroup
local augroup_autocmd = utils.augroup_autocmd
local contains = vim.tbl_contains

local smart_close_filetypes = {
  "prompt",
  "qf",
  "checkhealth",
  "nofile",
  "quickfix",
  "git-conflict",
  "term",
  "lazygit",
  "dap-repl",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_watches",
  "dapui_repl",
  "undotree",
  "noice",
  "man",
  "messages",
  "undotree",
  "help",
  "NeogitStatus",
  "notify",
  "Trouble",
  "diffview",
  "telescope",
  "lazy",
  "Outline",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePreview",
}

autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("highlighturl", { clear = true }),
  callback = function()
    utils.set_url_match()
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if buffers changed on editor focus",
  group = augroup("checktime", { clear = true }),
  command = "checktime",
})

autocmd("BufWritePre", {
  desc = "Automatically create parent directories if they don't exist when saving a file",
  group = augroup("create_dir", { clear = true }),
  callback = function(args)
    if args.match:match "^%w%w+://" then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(vim.loop.fs_realpath(args.match) or args.match, ":p:h"), "p")
  end,
})

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
    if vim.api.nvim_get_mode().mode == "i" then
      return
    end
    vim.api.nvim_feedkeys("zz", "n", false)
  end,
})

augroup_autocmd("WinCloseJmp", {
  "WinClosed",
  {
    nested = true,
    desc = "Jump to last accessed window on closing the current one.",
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

augroup_autocmd("BigFileSettings", {
  "BufReadPre",
  {
    desc = "Set settings for large files.",
    callback = function(info)
      vim.b.midfile = false
      vim.b.bigfile = false
      local stat = vim.uv.fs_stat(info.match)
      if not stat then
        return
      end
      if stat.size > 48000 then
        vim.b.midfile = true
        autocmd("BufReadPost", {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.schedule(function()
              pcall(vim.treesitter.stop, info.buf)
            end)
            return true
          end,
        })
      end
      if stat.size > 1024000 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.statuscolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.winbar = ""
        autocmd("BufReadPost", {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.opt_local.syntax = ""
            return true
          end,
        })
      end
    end,
  },
})

-- BUG: this breaks the LazyGit plugin
-- -- Automatically close terminal unless exit code isn't 0
-- local term_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
-- autocmd("TermClose", {
--   group = term_augroup,
--   callback = function()
--     if vim.v.event.status == 0 then
--       vim.api.nvim_buf_delete(0, {})
--       vim.notify_once "Previous terminal job was successful!"
--     else
--       vim.notify_once "Error code detected in the current terminal job!"
--     end
--   end,
-- })

---Change window-local directory to `dir`
---@param dir string
---@return nil
local function lcd(dir)
  local ok = pcall(vim.cmd.lcd, dir)
  if not ok then
    vim.notify_once("failed to cd to " .. dir, vim.log.levels.WARN)
  end
end

local groupid = vim.api.nvim_create_augroup("SyncCwd", {})
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
  desc = "Set cwd to follow buffers' directory.",
  group = groupid,
  pattern = "*",
  callback = function(info)
    local current = vim.api.nvim_get_current_win()
    local is_win_valid = utils_buffer.is_win_valid(current)
    vim.schedule(function()
      if is_win_valid then
        -- local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
        local cwd = fs.get_root()

        if cwd ~= vim.fn.getcwd() then
          print("cd to " .. cwd)
          lcd(cwd)
        end
      end
    end)
  end,
})

autocmd({ "BufWinEnter", "FileChangedShellPost" }, {
  pattern = "*",
  desc = "Automatically change local current directory.",
  callback = function(info)
    vim.schedule(function()
      if
        info.file == ""
        or not vim.api.nvim_buf_is_valid(info.buf)
        or vim.bo[info.buf].bt ~= ""
        or (vim.uv.fs_stat(info.file) or {}).type ~= "file"
      then
        return
      end
      local current_dir = vim.fn.getcwd(0)
      local target_dir = require("utils.fs").proj_dir(info.file) or vim.fs.dirname(info.file)
      local stat = target_dir and vim.uv.fs_stat(target_dir)
      -- Prevent unnecessary directory change, which triggers
      -- DirChanged autocmds that may update winbar unexpectedly
      if current_dir ~= target_dir and stat and stat.type == "directory" then
        print("CWD: " .. target_dir)
        vim.cmd.lcd(target_dir)
      end
    end)
  end,
})

autocmd("BufReadPre", {
  desc = "Set settings for large files.",
  callback = function(info)
    if vim.b.large_file ~= nil then
      return
    end
    vim.b.large_file = false
    local stat = vim.uv.fs_stat(info.match)
    if stat and stat.size > 1000000 then
      vim.b.large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.api.nvim_create_autocmd("BufReadPost", {
        buffer = info.buf,
        once = true,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
    end
  end,
})

autocmd("QuickFixCmdPost", {
  desc = "Open quickfix window if there are results.",
  callback = function(info)
    if #vim.fn.getqflist() <= 1 then
      return
    end
    if vim.startswith(info.match, "l") then
      vim.schedule(function()
        vim.cmd.lwindow {
          mods = { split = "belowright" },
        }
      end)
    else
      vim.schedule(function()
        vim.cmd.cwindow {
          mods = { split = "botright" },
        }
      end)
    end
  end,
})

autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  desc = "Disable New Line Comment",
})

local fix_virtual_edit_pos = augroup "FixVirtualEditCursorPos"
autocmd("CursorMoved", {
  desc = "Record cursor position in visual mode if virtualedit is set.",
  group = fix_virtual_edit_pos,
  callback = function()
    if vim.wo.ve:find "all" then
      vim.w.ve_cursor = vim.fn.getcurpos()
    end
  end,
})

autocmd("TextYankPost", {
  pattern = "*",
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank {
      higroup = "HighlightedyankRegion",
      clear = true,
      timeout = 400,
    }
  end,
})

-- NOTE: should restore cursor position on the last one
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- close some filetypes with <q>
local smart_close_buftypes = {}
local function smart_close()
  if vim.fn.winnr "$" ~= 1 then
    vim.api.nvim_win_close(0, true)
    vim.cmd "wincmd p"
  end
end

-- Close certain filetypes by pressing q.
autocmd("FileType", {
  pattern = { "*" },
  callback = function(event)
    local is_unmapped = vim.fn.hasmapto("q", "n") == 0
    local is_eligible = is_unmapped
      or vim.wo.previewwindow
      or contains(smart_close_buftypes, vim.bo.buftype)
      or contains(smart_close_filetypes, vim.bo.filetype)
    if is_eligible then
      vim.bo[event.buf].buflisted = false
      keymap("n", "q", smart_close, {
        desc = "Close window",
        buffer = 0,
        nowait = true,
      })
    end
  end,
})

autocmd("FileType", {
  group = augroup "man_unlisted",
  pattern = { "man" },
  desc = "make it easier to close man-files when opened inline",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = { "gitcommit", "markdown" },
  desc = "wrap and check for spell in text filetypes",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ "FileType" }, {
  group = augroup "json_conceal",
  pattern = { "json", "jsonc", "json5" },
  desc = "Fix conceallevel for json files",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

local disable_codespell = augroup "DisableCodespell"
autocmd({ "BufEnter" }, {
  group = disable_codespell,
  pattern = { "*.log", "" },
  callback = function()
    vim.diagnostic.disable()
  end,
})

-- wrap telescope previewwindow
local telescope_preview_wrap = augroup "WrapTelescopePreviewer"
autocmd("User", {
  group = telescope_preview_wrap,
  pattern = { "TelescopePreviewerLoaded" },
  command = "setlocal wrap",
})

autocmd("BufHidden", {
  desc = "Delete [No Name] buffers",
  -- pattern = "VeryLazy",
  pattern = {},
  callback = function(data)
    if data.file == "" and vim.bo[data.buf].buftype == "" and not vim.bo[data.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, data.buf, {})
      end)
    end
  end,
})

-- remove trailing whitespaces and ^M chars
autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function(_)
    if not fs.is_git_repo() then
      return
    end

    local save_cursor = vim.fn.getpos "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

augroup_autocmd("PromptBufKeymaps", {
  "BufEnter",
  {
    desc = "Undo automatic <C-w> remap in prompt buffers.",
    callback = function(info)
      if vim.bo[info.buf].buftype == "prompt" then
        vim.keymap.set("i", "<C-w>", "<C-S-W>", { buffer = info.buf })
      end
    end,
  },
})

augroup_autocmd("QuickFixAutoOpen", {
  "QuickFixCmdPost",
  {
    desc = "Open quickfix window if there are results.",
    callback = function(info)
      if #vim.fn.getqflist() > 1 then
        vim.schedule(vim.cmd[info.match:find "^l" and "lwindow" or "cwindow"])
      end
    end,
  },
})
