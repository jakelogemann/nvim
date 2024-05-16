return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      local lspconfig = require "lspconfig"
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
          },
        },
      }
    end,
  },
  { -- Useful status updates for LSP
    "j-hui/fidget.nvim",
  },
  { -- adds icons for current signature (as defined by the LSP)
    "onsails/lspkind.nvim",
    lazy = true,
    enable = not vim.g.icons,
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "cshuaimin/ssr.nvim",
    opts = {
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
  },
}
-- vim: fdl=1 fen fdm=expr
