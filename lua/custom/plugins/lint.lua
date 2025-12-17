return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, lint = pcall(require, "lint")
      if not ok then return end

      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.lua = { "luacheck" }
      lint.linters_by_ft.sh = { "shellcheck" }
      lint.linters_by_ft.bash = { "shellcheck" }
      lint.linters_by_ft.zsh = { "shellcheck" }
      lint.linters_by_ft.markdown = { "markdownlint" }
      lint.linters_by_ft.javascript = { "eslint_d" }
      lint.linters_by_ft.javascriptreact = { "eslint_d" }
      lint.linters_by_ft.typescript = { "eslint_d" }
      lint.linters_by_ft.typescriptreact = { "eslint_d" }
      lint.linters_by_ft.go = { "golangci_lint" }

      local group = vim.api.nvim_create_augroup("nvim-lint-config", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          -- respect buffer diagnostics toggle
          if vim.b._diagnostics_disabled then return end
          pcall(lint.try_lint)
        end,
      })

      vim.api.nvim_create_user_command("Lint", function() lint.try_lint() end, { desc = "Run linters for current buffer" })
    end,
  },
}

