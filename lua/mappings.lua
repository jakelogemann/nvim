function nmap(keys, desc, fn) vim.keymap.set("n", keys, fn, { desc = desc }) end

require("which-key").register({
  a = { name = "actions" },
  b = { name = "buffer" },
  f = { name = "file" },
  g = { name = "git" },
  h = { name = "help" },
  i = { name = "insert" },
  o = { name = "open" },
  p = { name = "project" },
  s = { name = "search" },
  t = { name = "tab" },
  u = { name = "ui" },
  U = { name = "user" },
  w = { name = "window" },
  z = { name = "toggle" },
}, { prefix = "<leader>" })

nmap("gcc", "comment line", "<Plug>(comment_toggle_linewise)<cr>")
nmap("gcb", "comment block", "<Plug>(comment_toggle_linewise)<cr>")
nmap("<C-s>", "Save current buffer", "<cmd>write<cr>")
nmap("<f1>", "Find help", "<cmd>FindHelp<cr>")
nmap("<leader>e", "explore", "<cmd>Oil<cr>")
nmap("<leader>ac", "combine args", function() require("spread").combine() end)
nmap("<leader>as", "spread args", function() require("spread").out() end)
nmap("<leader>bN", "new buf", "<cmd>bnew<cr>")
nmap("<leader>bn", "next buf", "<cmd>bNext<cr>")
nmap("<leader>bp", "prev buf", "<cmd>bprevious<cr>")
nmap("<leader>bs", "scratch", "<cmd>enew<cr>")
nmap("<leader>bw", "write buf", "<cmd>write<cr>")
nmap("<leader><leader>", "browse", "<cmd>NeoTreeFloatToggle<cr>")
nmap("<leader>f/", "search", "<cmd>LiveGrep<cr>")
nmap("<leader>g[", "prev hunk", "<cmd>Gitsigns prev_hunk<cr>")
nmap("<leader>g]", "next hunk", "<cmd>Gitsigns next_hunk<cr>")
nmap("<leader>gg", "git", "<cmd>Neogit kind=tab<cr>")
nmap("<leader>h/", "search help", "<cmd>FindHelp<cr>")
nmap("<leader>hl", "lua.vim", "<cmd>help lua.vim<cr>")
nmap("<leader>hL", "lua-ref", "<cmd>help luaref-Lib<cr>")
nmap("<leader>hN", "nvim.txt", "<cmd>help nvim.txt<cr>")
nmap("<leader>hP", "lazy.nvim", "<cmd>help lazy.nvim.txt<cr>")
nmap("<leader>hM", "search man", "<cmd>ManPages<cr>")
nmap("<leader>id", "date", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date()), "n", true) end)
nmap("<leader>it", "time", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%R"), "n", true) end)
nmap("<leader>iy", "year", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%Y"), "n", true) end)
nmap("<leader>p/", "search", "<cmd>FindFiles<cr>")
nmap("<leader>b/", "search", "<cmd>Buffers<cr>")
nmap("<leader>pc", "project config", "<cmd>Neoconf<cr>")
nmap("<leader>s/", "available", "<cmd>Telescope builtin<cr>")
nmap("<leader>s`", "marks", "<cmd>Telescope marks<cr>")
nmap("<leader>sb", "buffers", "<cmd>Buffers<cr>")
nmap("<leader>sc", "commands", "<cmd>Telescope commands<cr>")
nmap("<leader>sd", "diagnostics", "<cmd>Telescope diagnostics<cr>")
nmap("<leader>sf", "find files", "<cmd>FindFiles<cr>")
nmap("<leader>sg", "live grep", "<cmd>LiveGrep<cr>")
nmap("<leader>sh", "help tags", "<cmd>FindHelp<cr>")
nmap("<leader>sl", "loclist", "<cmd>LOC<cr>")
nmap("<leader>sm", "man pages", "<cmd>ManPages<cr>")
nmap("<leader>sq", "quickfix", "<cmd>QF<cr>")
nmap("<leader>ss", "symbols", "<cmd>Symbols<cr>")
nmap("<leader>st", "treesitter", "<cmd>Telescope treesitter<cr>")
nmap("<leader>sw", "grep by word", "<cmd>GrepByWord<cr>")
nmap("<leader>zc", "conceal", function() vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0 end)
nmap("<leader>zgs", "gitsigns", "<cmd>Gitsigns toggle_signs<cr>")
nmap("<leader>`", "term", "<cmd>ToggleTerm direction=float<cr>")
nmap("<leader>zl", "list", function() vim.bo.list = not vim.opt.list:get() end)
nmap("<leader>zp", "paste", function() vim.bo.paste = not vim.opt.paste:get() end)
nmap("<leader>zr", "ruler", function() vim.wo.ruler = not vim.opt.ruler:get() end)
nmap("<leader>zs", "spell", function() vim.bo.spell = not vim.opt.spell:get() end)
nmap("<leader>zo", "outline", "<cmd>SymbolsOutline<cr>")
nmap("<leader>zw", "wrap", function() vim.wo.wrap = not vim.opt.wrap:get() end)
nmap("<leader>z<tab>", "tabs/spaces", function()
  vim.ui.select({ "tabs", "spaces" }, {
    prompt = "Select tabs or spaces:",
    format_item = function(item) return "I'd like to use " .. item end,
  }, function(choice)
    if choice == "spaces" then
      vim.bo.expandtab = true
    else
      vim.bo.expandtab = false
    end
  end)
end)

nmap("<leader>zn", "number", function()
  local ln = vim.opt.number:get()
  vim.wo.number = not ln
  vim.wo.relativenumber = ln
end)

nmap("<leader>usw", "shiftwidth", function()
  vim.ui.input(
    { prompt = "set shiftwidth " },
    function(input) vim.o.shiftwidth = tonumber(input) or vim.o.shiftwidth end
  )
end)
