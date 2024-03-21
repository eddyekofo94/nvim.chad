dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"
local utils_keymaps = require "utils.keymaps"
local utils_custom = require "utils"
local keymap = utils_keymaps.set_keymap

local M = {}
-- local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

local function generate_buf_keymapper(bufnr)
  return function(type, input, output, opts)
    local options = { buffer = bufnr }
    if type(opts) == "table" then
      options = vim.tbl_deep_extend("force", options, opts)
    elseif type(opts) == "string" then
      opts = { desc = opts }
      options = vim.tbl_deep_extend("force", options, opts)
    end
    keymap(type, input, output, options)
  end
end

M.on_attach = function(client, bufnr)
  -- utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  -- if
  --   not utils.load_config().ui.lsp_semantic_tokens
  --   and client.supports_method "textDocument/semanticTokens"
  -- then
  -- client.server_capabilities.semanticTokensProvider = nil
  -- end
end

-- M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

return M
