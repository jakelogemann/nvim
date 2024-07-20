local set = vim.keymap.set
local augroup = vim.api.nvim_create_augroup("my-terminal", { clear = true })
local o = vim.opt_local

set("t", "<esc><esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode." })
set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode." })
set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move to left window." })
set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Move to lower window." })
set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Move to upper window." })
set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move to right window." })

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  desc = "on opening a new terminal buffer",
  group = augroup,
  pattern = "term://*",
  callback = function()
    o.number = false
    o.spell = false
    o.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ "TermEnter" }, {
  desc = "on entering terminal mode",
  group = augroup,
  pattern = "term://*",
  callback = function()
    o.number = false
    o.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ "TermLeave" }, {
  desc = "on leaving terminal mode",
  group = augroup,
  pattern = "term://*",
  callback = function() return end,
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
  desc = "on closing a terminal buffer",
  group = augroup,
  pattern = "term://*",
  callback = function() return end,
})
