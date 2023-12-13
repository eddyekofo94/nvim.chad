local actions = require "telescope.actions"
local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    pickers = {
      buffers = {
        sort_mru = true,
        ignore_current_buffer = true,
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer", -- this overrides the built in preview scroller
            ["<c-b>"] = "preview_scrolling_down",
          },
          n = {
            ["<c-d>"] = "delete_buffer", -- this overrides the built in preview scroller
            ["<c-b>"] = "preview_scrolling_down",
          },
        },
      },
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = actions.close },
      i = {

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-Down>"] = require("telescope.actions").cycle_history_next,
        ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
        ["<C-t>"] = actions.select_tab,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
        -- Add up multiple actions
        ["<CR>"] = actions.select_default + actions.center,
        -- ["<a-i>"] = function()
        --   require("telescope").telescope("find_files", { no_ignore = true })()
        -- end,
        -- ["<a-h>"] = function()
        --   Util.telescope("find_files", { hidden = true })()
        -- end,
      },
    },
  },

  extensions_list = { "themes", "terms", "fzf" },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

return options
