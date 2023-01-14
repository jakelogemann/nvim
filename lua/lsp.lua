local M = { servers = vim.empty_dict() }

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

M.default_capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.default_capabilities)

M.servers["sumneko_lua"] = {
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
  },
}

function M.setup_server(name)
  require("lspconfig")[name].setup {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    settings = M.servers[name],
  }
end

M.ensure_installed = vim.tbl_keys(M.servers)

return M
