local M = { servers = vim.empty_dict() }

M.servers["lua"] = {
  Lua = {
    diagnostics = {
      globals = {
        "vim",
      },
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = vim.api.nvim_get_runtime_file("", true),
      checkThirdParty = false,
    },
    telemetry = {
      enable = false,
    },
  },
}

-- M.servers["clangd"] = {
--   capabilities = { offsetEncoding = "utf-8" },
-- }

M.servers["tsserver"] = {
  javascript = {
    inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
    },
  },
  typescript = {
    inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
    },
  },
}

M.servers["yamlls"] = {
  yaml = {
    schemas = {
      ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      ["http://json.schemastore.org/catalog-info"] = "{catalog-info,catalog/**/*}.{yml,yaml}",
      ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    },
  },
}

M.servers["gopls"] = {
  ["memoryMode"] = "DegradedClosed",
  gopls = {
    ["build.directoryFilters"] = { "-**/node_modules" },
    ["build.buildFlags"] = { "-trimpath" },
    ["formatting.gofumpt"] = true,
    ["ui.diagnostic.diagnosticsDelay"] = "500ms",
    ["build.env"] = {
      GONOPROXY = table.concat({
        "github.internal.digitalocean.com",
        "github.com/polis-dev/sol",
        "github.com/digitalocean",
      }, ","),
      GONOSUMDB = table.concat({
        "github.internal.digitalocean.com",
        "github.com/polis-dev/sol",
        "github.com/digitalocean",
      }, ","),
      GOPRIVATE = table.concat({
        "github.internal.digitalocean.com",
        "github.com/polis-dev/sol",
        "github.com/digitalocean",
      }, ","),
    },
    analyses = {
      unusedparams = true,
      -- unusedvariable = true,
      -- unusedwrite = true,
      -- nilness = true,
      -- shadow = true,
    },
    staticcheck = true,
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
  },
}

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
function M.on_attach(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Diagnostic keymaps
  nmap("[d", vim.diagnostic.goto_prev, "prev diag")
  nmap("]d", vim.diagnostic.goto_next, "next diag")
  nmap("<localleader>od", vim.diagnostic.open_float, "diag popup")
  nmap("<localleader>ol", vim.diagnostic.setloclist, "diag loclist")

  nmap("<localleader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<localleader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<localleader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<localleader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<localleader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<localleader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<localleader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap(
    "<localleader>wl",
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    "[W]orkspace [L]ist Folders"
  )

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Format",
    function(_) vim.lsp.buf.format() end,
    { desc = "Format current buffer with LSP" }
  )
end

function M.setup_server(name)
  require("lspconfig")[name].setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(M.default_capabilities),
    on_attach = M.on_attach,
    settings = M.servers[name],
  }
end

M.ensure_installed = vim.tbl_keys(M.servers)
M.default_capabilities = vim.lsp.protocol.make_client_capabilities()
return M
