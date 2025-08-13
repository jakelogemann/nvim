return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog" },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    event = "BufReadPre",
    config = function()
      -- Server-specific settings table (mirrors former custom/lsp.lua)
      local servers = {}

      servers["lua_ls"] = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
          telemetry = { enable = false },
        },
      }

      servers["yamlls"] = {
        yaml = {
          schemas = {
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
            ["http://json.schemastore.org/catalog-info"] = "{catalog-info,catalog/**/*}.{yml,yaml}",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
          },
        },
      }

      servers["gopls"] = {
        gopls = {
          memoryMode = "DegradedClosed",
          ["build.directoryFilters"] = { "-**/node_modules" },
          ["build.buildFlags"] = { "-trimpath" },
          ["formatting.gofumpt"] = true,
          ["ui.diagnostic.diagnosticsDelay"] = "500ms",
          ["build.env"] = (function()
            local list = {
              "github.com/polis-dev/polis.dev",
              "polis.dev",
            }
            local joined = table.concat(list, ",")
            return { GONOPROXY = joined, GONOSUMDB = joined, GOPRIVATE = joined }
          end)(),
          analyses = {
            unusedparams = true,
            unusedvariable = true,
            unusedwrite = true,
            nilness = true,
            shadow = true,
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

      --- LSP client attach callback to set buffer-local keymaps & inlay hints.
      -- @param _ table unused client
      -- @param bufnr integer buffer number
      local function on_attach(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then desc = "LSP: " .. desc end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("[d", vim.diagnostic.goto_prev, "prev diag")
        nmap("]d", vim.diagnostic.goto_next, "next diag")
        nmap("<localleader>od", vim.diagnostic.open_float, "diag popup")
        nmap("<localleader>ol", vim.diagnostic.setloclist, "diag loclist")
        nmap("<localleader>rn", vim.lsp.buf.rename, "rename")
        nmap("<localleader>ca", vim.lsp.buf.code_action, "code action")
        nmap("gd", vim.lsp.buf.definition, "definition")
        nmap("gr", require("telescope.builtin").lsp_references, "references")
        nmap("gI", vim.lsp.buf.implementation, "implementation")
        nmap("<localleader>D", vim.lsp.buf.type_definition, "type def")
        nmap("<localleader>ds", require("telescope.builtin").lsp_document_symbols, "doc symbols")
        nmap("<localleader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "workspace symbols")
        nmap("K", vim.lsp.buf.hover, "hover")
        nmap("<C-k>", vim.lsp.buf.signature_help, "signature help")
        nmap("gD", vim.lsp.buf.declaration, "declaration")
        nmap("<localleader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
        nmap("<localleader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
        nmap(
          "<localleader>wl",
          function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          "list workspace folders"
        )

        if vim.lsp.inlay_hint then
          pcall(function()
            if type(vim.lsp.inlay_hint.enable) == "function" then
              vim.lsp.inlay_hint.enable(bufnr, true)
            elseif type(vim.lsp.inlay_hint) == "function" then
              vim.lsp.inlay_hint(bufnr, true)
            end
          end)
        end

        vim.api.nvim_buf_create_user_command(
          bufnr,
          "Format",
          function() vim.lsp.buf.format() end,
          { desc = "Format current buffer with LSP" }
        )
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then capabilities = cmp_lsp.default_capabilities(capabilities) end

      require("mason").setup()
      local ensure = vim.tbl_keys(servers)
      require("mason-lspconfig").setup { ensure_installed = ensure, automatic_installation = true }

      local lspconfig = require "lspconfig"
      for _, name in ipairs(ensure) do
        lspconfig[name].setup { capabilities = capabilities, on_attach = on_attach, settings = servers[name] }
      end
    end,
  }
}
