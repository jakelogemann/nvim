local groups = {}

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("yank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Reorder golang imports",
  group = vim.api.nvim_create_augroup("golang", { clear = true }),
  pattern = "*.go",
  callback = function()
    local wait_ms = 10
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Automatically Format",
  group = vim.api.nvim_create_augroup("autoformat", { clear = true }),
  pattern = { "*.lua", "*.json", "*.go", "*.ts", "*.js" },
  callback = function() vim.cmd "Format" end,
})
