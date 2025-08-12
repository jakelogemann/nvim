-- User-defined autocommands
local my_autocmds = vim.api.nvim_create_augroup("my-autocmds", { clear = true })
--- Buffer-local keymap helper (unused placeholder for future mappings).
-- @param mode string|table
-- @param lhs string
-- @param rhs string|function
local bufmap = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = 0 }) end

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = my_autocmds,
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
  desc = "things for go source code.",
  group = my_autocmds,
  pattern = "*.go",
  callback = function() return end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Reorder golang imports",
  group = my_autocmds,
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

-- vim.api.nvim_create_autocmd("BufWritePre", {
--  desc = "Automatically Format",
--  group = my_autocmds,
--  pattern = { "*.lua", "*.json", "*.go", "*.ts", "*.js" },
--  callback = function() vim.cmd "Format" end,
-- })

-- Terminal buffer local options
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  desc = "Terminal local opts",
  group = my_autocmds,
  pattern = "term://*",
  callback = function()
    local o = vim.opt_local
    o.number = false
    o.relativenumber = false
    o.spell = false
  end,
})

vim.api.nvim_create_autocmd({ "TermEnter" }, {
  desc = "Reapply terminal opts",
  group = my_autocmds,
  pattern = "term://*",
  callback = function()
    local o = vim.opt_local
    o.number = false
    o.relativenumber = false
  end,
})

-- Filetype specific (migrated from after/ftplugin/*)
vim.api.nvim_create_autocmd("FileType", {
  group = my_autocmds,
  pattern = "c",
  desc = "c local opts",
  callback = function()
    local o = vim.opt_local
    o.shiftwidth = 2
    o.formatoptions:remove "o"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = my_autocmds,
  pattern = "go",
  desc = "go local opts",
  callback = function()
    local o = vim.opt_local
    o.list = false
    o.listchars = vim.tbl_extend("force", o.listchars:get(), { tab = "| " })
    o.expandtab = false
    o.foldmethod = "syntax"
    o.foldenable = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = my_autocmds,
  pattern = "help",
  desc = "help local opts",
  callback = function()
    vim.opt_local.colorcolumn = { 80 }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = my_autocmds,
  pattern = "lua",
  desc = "lua local opts",
  callback = function()
    local o = vim.opt_local
    o.listchars = vim.tbl_extend("force", o.listchars:get(), { tab = "" })
  end,
})
