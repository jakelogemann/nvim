return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        json = { "jq" },
        jsonc = { "jq" },
        yaml = { "yamlfmt" },
        markdown = { "prettier" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
      },
      -- we drive autoformat via our own autocmd + :FormatToggle
      format_on_save = false,
      notify_on_error = true,
    },
    config = function(_, opts)
      local ok, conform = pcall(require, "conform")
      if not ok then return end
      conform.setup(opts)
    end,
  },
}

