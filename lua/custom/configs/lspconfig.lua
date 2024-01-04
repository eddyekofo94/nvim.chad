local configs = require "plugins.configs.lspconfig"
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"
-- local servers = { "html", "cssls", "clangd" }

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end

local small_dot = " "

vim.cmd.highlight "DiagnosticUnderlineError gui=undercurl" -- use undercurl for error, if supported by terminal
vim.cmd.highlight "DiagnosticUnderlineWarn  gui=undercurl" -- use undercurl for warning, if supported by terminal
sign { name = "DiagnosticSignError", text = small_dot }
sign { name = "DiagnosticSignWarn", text = small_dot }
sign { name = "DiagnosticSignHint", text = small_dot }
sign { name = "DiagnosticSignInfo", text = small_dot }

vim.diagnostic.config {
  underline = true,
  -- Hide/Show virtual text
  virtual_text = {
    prefix = " ",
    severity_limit = "Warning",
    spacing = 4,
  },
  signs = true,
  update_in_insert = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    focusable = false,
  },
}

-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   }
-- end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  analyses = {
    shadow = true,
    nilness = true,
    unusedparams = true,
    unusedwrite = true,
    useany = true,
  },
  experimentalPostfixCompletions = true,
  gofumpt = true,
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = false,
    },
  },
  setting = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  usePlaceholders = true,
  hints = {
    assignVariableTypes = true,
    compositeLiteralFields = true,
    compositeLiteralTypes = true,
    constantValues = true,
    functionTypeParameters = true,
    parameterNames = true,
    rangeVariableTypes = true,
  },
  staticcheck = true,
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391" },
          maxLineLength = 100,
        },
      },
    },
  },
}

lspconfig.yamlls.setup {
  keyOrdering = false,
  schemaStore = {
    url = "https://www.schemastore.org/api/json/catalog.json",
    enable = true,
  },
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--all-scopes-completion",
    "--completion-style=detailed",
    "--clang-tidy",
    "--cross-file-rename",
    "--fallback-style=Google",
    "--header-insertion=iwyu",
  },
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    clangdFileStatus = true,
  },
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

lspconfig.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sh", "bash" },
}
-- Without the loop, you would have to manually set up each LSP
--
-- lspconfig.html.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
--
-- lspconfig.cssls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
