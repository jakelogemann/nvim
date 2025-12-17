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
          -- Use local SchemaStore catalog for offline-first behavior
          schemaStore = { enable = false, url = "" },
          schemas = (function()
            local ok, schemastore = pcall(require, "schemastore")
            return ok and schemastore.yaml.schemas() or {}
          end)(),
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
        nmap("<localleader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folders")

        if vim.lsp.inlay_hint then
          pcall(function()
            -- Neovim 0.10+ signature
            if type(vim.lsp.inlay_hint.enable) == "function" then
              local ok_new = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
              if not ok_new then
                -- Some intermediary versions use (bufnr, true)
                pcall(vim.lsp.inlay_hint.enable, bufnr, true)
              end
            elseif type(vim.lsp.inlay_hint) == "function" then
              -- Older API: vim.lsp.inlay_hint(bufnr, true)
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

      -- Apply defaults to all installed servers via handlers when available,
      -- otherwise iterate installed servers directly.
      local mlsp = require "mason-lspconfig"
      local function configure(name)
        if vim.lsp and vim.lsp.config then
          local cfg = vim.tbl_deep_extend(
            "force",
            vim.lsp.config[name] or {},
            { capabilities = capabilities, on_attach = on_attach, settings = servers[name] or {} }
          )
          vim.lsp.config[name] = cfg
        else
          local ok_lsp, lspconfig = pcall(require, "lspconfig")
          if ok_lsp and lspconfig[name] then
            lspconfig[name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[name],
            }
          end
        end
      end

      if type(mlsp.setup_handlers) == "function" then
        mlsp.setup_handlers { function(name) configure(name) end }
      else
        for _, name in ipairs(mlsp.get_installed_servers()) do
          configure(name)
        end
      end
    end,
  },
}
