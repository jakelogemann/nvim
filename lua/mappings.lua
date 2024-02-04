local nmap = function(keys, desc, fn) vim.keymap.set("n", keys, fn, { desc = desc }) end

require("which-key").register({
  a = { name = "Actions" },
  b = { name = "Buffer" },
  f = { name = "File" },
  g = { name = "Git" },
  h = { name = "Help" },
  i = { name = "Insert" },
  o = { name = "Open" },
  p = { name = "Project" },
  s = { name = "Search" },
  t = { name = "Tab" },
  u = { name = "UI" },
  U = { name = "User" },
  w = { name = "Window" },
  z = { name = "Toggle" },
}, { prefix = "<leader>" })

nmap("<C-s>", "Save current buffer", "<cmd>write<cr>")
nmap("<f1>", "Find help", "<cmd>FindHelp<cr>")
nmap("<leader>e", "Browse project", "<cmd>Neotree focus toggle<cr>")
nmap("<leader>`", "Toggle Terminal", "<cmd>ToggleTerm direction=float<cr>")
nmap("<leader>ac", "Combine arguments", function() require("spread").combine() end)
nmap("<leader>as", "Spread arguments", function() require("spread").out() end)
nmap("<leader>b/", "Search Buffers", "<cmd>Buffers<cr>")
nmap("<leader>bN", "New File Buffer", "<cmd>bnew<cr>")
nmap("<leader>bn", "Select Next Buffer", "<cmd>bNext<cr>")
nmap("<leader>bd", "Delete buffer", "<cmd>bdelete<cr>")
nmap("<leader>bp", "Select Prev Buffer", "<cmd>bprevious<cr>")
nmap("<leader>bs", "New Scratch Buffer", "<cmd>enew<cr>")
nmap("<leader>bw", "Write Buffer", "<cmd>write<cr>")
nmap("<leader>tn", "Select Next Tab", "<cmd>tabNext<cr>")
nmap("<leader>tp", "Select Previous Tab", "<cmd>tabNext<cr>")
nmap("-", "Explore directory", "<cmd>Oil<cr>")
nmap("<leader>f/", "search", "<cmd>LiveGrep<cr>")
nmap("<leader>g[", "prev hunk", "<cmd>Gitsigns prev_hunk<cr>")
nmap("<leader>g]", "next hunk", "<cmd>Gitsigns next_hunk<cr>")
nmap("<leader>gg", "git", "<cmd>Neogit kind=tab<cr>")
nmap("<leader>h/", "Search :help", "<cmd>FindHelp<cr>")
nmap("<leader>hL", "Lua Reference", "<cmd>help luaref-Lib<cr>")
nmap("<leader>hM", "Search manpages", "<cmd>ManPages<cr>")
nmap("<leader>hN", "NVIM Reference", "<cmd>help nvim.txt<cr>")
nmap("<leader>hP", "Plugin Manager", "<cmd>help lazy.nvim.txt<cr>")
nmap("<leader>hl", "Lua Guide", "<cmd>help lua.vim<cr>")
nmap("<leader>id", "Date", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date()), "n", true) end)
nmap("<leader>it", "Time", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%R"), "n", true) end)
nmap("<leader>iy", "Year", function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%Y"), "n", true) end)
nmap("<leader>p/", "Search Project", "<cmd>FindFiles<cr>")
nmap("<leader>pc", "Project Config", "<cmd>Neoconf<cr>")
nmap("<leader>s/", "available", "<cmd>Telescope builtin<cr>")
nmap("<leader>s`", "Search Marks", "<cmd>Telescope marks<cr>")
nmap("<leader>sb", "Buffers", "<cmd>Buffers<cr>")
nmap("<leader>sc", "Commands", "<cmd>Telescope commands<cr>")
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
nmap("<leader>zgs", "Gitsigns", "<cmd>Gitsigns toggle_signs<cr>")
nmap("<leader>zl", "list", function() vim.bo.list = not vim.opt.list:get() end)
nmap("<leader>zo", "outline", "<cmd>SymbolsOutline<cr>")
nmap("<leader>zp", "paste", function() vim.bo.paste = not vim.opt.paste:get() end)
nmap("<leader>zr", "ruler", function() vim.wo.ruler = not vim.opt.ruler:get() end)
nmap("<leader>zs", "spell", function() vim.bo.spell = not vim.opt.spell:get() end)
nmap("<leader>zw", "wrap", function() vim.wo.wrap = not vim.opt.wrap:get() end)
nmap("gcb", "comment block", "<Plug>(comment_toggle_linewise)<cr>")
nmap("gcc", "comment line", "<Plug>(comment_toggle_linewise)<cr>")
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
