-- Centralized keymaps (moved from which-key spec)
local config_root = vim.fn.stdpath "config"

--- Define a normal-mode keymap with silent + description.
-- @param lhs string
-- @param rhs string|function
-- @param desc string
local function n(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc }) end
--- Define a visual-mode keymap with silent + description.
-- @param lhs string
-- @param rhs string|function
-- @param desc string
local function v(lhs, rhs, desc) vim.keymap.set("v", lhs, rhs, { silent = true, desc = desc }) end
--- Define a terminal-mode keymap with silent + description.
-- @param lhs string
-- @param rhs string|function
-- @param desc string
local function t(lhs, rhs, desc) vim.keymap.set("t", lhs, rhs, { silent = true, desc = desc }) end

-- Global :Format command (buffer-local versions may override); safe if already defined
pcall(vim.api.nvim_create_user_command, "Format", function()
  if vim.lsp and vim.lsp.buf and vim.lsp.buf.format then
    vim.lsp.buf.format()
  else
    vim.notify(":Format requires LSP", vim.log.levels.WARN)
  end
end, { desc = "Format current buffer with LSP" })

-- General
n("<C-s>", "<cmd>write<cr>", "write buffer")
n("<leader><leader>", "<c-^>", "alternate buffer")
n("<c-w>\\", function()
  local ok, w = pcall(require, "which-key")
  if ok then w.show { keys = "<c-w>", loop = true } end
end, "window mode")

-- Help
n("<leader>h?", "<cmd>Cheatsheet<cr>", "cheatsheet")

-- [Neo]VIM Plugin Management
n("<leader>Vl", "<cmd>Lazy<cr>", "Lazy: UI")
n("<leader>Vs", "<cmd>Lazy sync<cr>", "Lazy: Sync")
n("<leader>Vu", "<cmd>Lazy update<cr>", "Lazy: Update")
n("<leader>Vp", "<cmd>Lazy profile<cr>", "Lazy: Profile")
n("<leader>Vm", "<cmd>Mason<cr>", "Mason: UI")
n("<leader>Vi", function() vim.cmd.edit(config_root .. "/init.lua") end, "Edit Config")
n("<leader>VM", function()
  local log = vim.fn.stdpath "cache" .. "/mason.log"
  if vim.loop.fs_stat(log) then
    vim.cmd.edit(log)
  else
    vim.notify("No mason.log yet", vim.log.levels.INFO)
  end
end, "Open mason.log")

-- Buffers
n("<leader>bN", "<cmd>bnew<cr>", "new buffer")
n("<leader>bd", "<cmd>bdelete<cr>", "delete buffer")
n("<leader>be", "<cmd>enew<cr>", "new scratch")
n("<leader>bn", "<cmd>bNext<cr>", "next buffer")
n("<leader>bp", "<cmd>bprev<cr>", "prev buffer")
n("<leader>bw", "<cmd>write<cr>", "write buffer")

-- Files / project config
n("<leader>pc", "<cmd>Neoconf<cr>", "project config")
n("<leader>ps", function()
  local ok, p = pcall(require, "persistence")
  if ok then p.load() end
end, "session load")
n("<leader>pS", function()
  local ok, p = pcall(require, "persistence")
  if ok then p.load { last = true } end
end, "last session")
n("<leader>p/", function() require("custom.pick").files() end, "find file")

-- Git
n("<leader>gg", "<cmd>Neogit kind=tab<cr>", "git gui")
n("<leader>gd", "<cmd>DiffviewOpen<cr>", "diff view")
n("<leader>gq", "<cmd>DiffviewClose<cr>", "diff close")

-- DAP / Debugger
n("<leader>db", function() require("dap").toggle_breakpoint() end, "breakpoint")
n("<leader>dc", function() require("dap").continue() end, "continue")
n("<leader>di", function() require("dap").step_into() end, "step into")
n("<leader>do", function() require("dap").step_out() end, "step out")
n("<leader>dn", function() require("dap").step_over() end, "step over")
n("<leader>dr", function() require("dap").restart() end, "restart")
n("<leader>de", function() require("dapui").eval(nil, { enter = true }) end, "eval")
n("<leader>du", function() require("dapui").toggle() end, "ui toggle")

-- LSP
n("<leader>la", function() vim.lsp.buf.code_action() end, "code action")
n("<leader>ld", function() vim.diagnostic.open_float() end, "line diag")
n("<leader>lf", function() vim.lsp.buf.format { async = true } end, "format")
n("<leader>lh", function() vim.lsp.buf.hover() end, "hover")
n("<leader>li", function() vim.lsp.buf.implementation() end, "impl")
n("<leader>lr", function() vim.lsp.buf.rename() end, "rename")
n("<leader>lR", function() vim.lsp.buf.references() end, "references")
n("<leader>ls", function() vim.lsp.buf.document_symbol() end, "doc symbols")
n("<leader>lS", function() vim.lsp.buf.workspace_symbol() end, "ws symbols")

-- Toggle inlay hints (buffer-local), supports both new/old APIs
n("<leader>lI", function()
  local ih = vim.lsp.inlay_hint
  if not ih then return end
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.b._inlay_hints_enabled
  if type(ih.is_enabled) == "function" then
    local ok, res = pcall(ih.is_enabled, { bufnr = bufnr })
    if ok then enabled = res end
  end
  enabled = not enabled
  vim.b._inlay_hints_enabled = enabled
  if type(ih.enable) == "function" then
    local ok_new = pcall(ih.enable, enabled, { bufnr = bufnr })
    if not ok_new then pcall(ih.enable, bufnr, enabled) end
  elseif type(ih) == "function" then
    ih(bufnr, enabled)
  end
  vim.notify("Inlay hints: " .. (enabled and "on" or "off"), vim.log.levels.INFO)
end, "toggle hints")

-- Ollama AI
local function _sel_prefix() return (vim.fn.mode():match "[vV]" and "'<,'>" or "") end
n("<leader>op", function() vim.cmd(_sel_prefix() .. "Ollama") end, "Ollama prompt")
n("<leader>oc", function() vim.cmd(_sel_prefix() .. "Ollama Change_Code") end, "Change code")
n("<leader>oe", function() vim.cmd(_sel_prefix() .. "Ollama Enhance_Code") end, "Enhance code")
n("<leader>or", function() vim.cmd(_sel_prefix() .. "Ollama Review_Code") end, "Review code")
n("<leader>os", function() vim.cmd(_sel_prefix() .. "Ollama Summarize") end, "Summarize")
n("<leader>om", function()
  local ok, o = pcall(require, "ollama")
  if ok and o.select_model then
    o.select_model()
  else
    vim.notify("No model selector", "warn")
  end
end, "Model select")
n("<leader>ox", function() vim.cmd "Ollama" end, "Pick prompt")

-- Copilot
n("<leader>Ce", function() vim.cmd "Copilot enable" end, "Copilot enable")
n("<leader>Cd", function() vim.cmd "Copilot disable" end, "Copilot disable")
n("<leader>Cs", function() vim.cmd "Copilot status" end, "Copilot status")
n("<leader>Cp", function() vim.cmd "Copilot panel" end, "Copilot panel")
n("<leader>Ca", function()
  local k = vim.api.nvim_replace_termcodes("<M-CR>", true, false, true)
  vim.api.nvim_feedkeys(k, "i", false)
end, "Copilot accept")
n("<leader>CT", function()
  if vim.g.copilot_enabled == 1 then
    vim.cmd "Copilot disable"
  else
    vim.cmd "Copilot enable"
  end
end, "Copilot toggle")

-- Rust
n("<leader>rt", function() require("custom.utils").run_in_term "cargo test" end, "cargo test")
n("<leader>rf", function()
  local f = vim.fn.expand "%"
  require("custom.utils").run_in_term("cargo test -- " .. f)
end, "test file")
n("<leader>rr", function() require("custom.utils").run_in_term "cargo run" end, "cargo run")
n("<leader>rb", function() require("custom.utils").run_in_term "cargo build" end, "cargo build")

-- Go
n("<leader>Gt", function() vim.cmd "GoTest" end, "go test package")
n("<leader>GF", function() vim.cmd "GoTestFunc" end, "go test func")
n("<leader>Gf", function() vim.cmd "GoTestFile" end, "go test file")
n("<leader>Gb", function() vim.cmd "GoBuild" end, "go build")
n("<leader>Gi", function() vim.cmd "GoInstall" end, "go install")

-- Execute current file
n("<leader>xx", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand "%:p"
  local cmd
  if ft == "go" then
    cmd = "go run " .. file
  elseif ft == "rust" then
    cmd = "cargo run"
  elseif ft == "python" then
    cmd = "python " .. file
  elseif ft == "sh" or ft == "bash" or ft == "zsh" or ft == "fish" then
    cmd = file
  else
    cmd = file
  end
  local ok, u = pcall(require, "custom.utils")
  if ok and u.run_in_term then
    u.run_in_term(cmd)
  else
    vim.cmd("!" .. cmd)
  end
end, "run file")

-- Editing utilities
n("<leader>yd", function() vim.cmd "t." end, "duplicate line")
n("<leader>sS", function()
  local w = vim.fn.expand "<cword>"
  vim.cmd("%%s/\\<" .. w .. "\\>//gI")
end, "substitute word")
n("<leader>mj", function() vim.cmd "move .+1 | normal ==" end, "line down")
n("<leader>mk", function() vim.cmd "move .-2 | normal ==" end, "line up")
n("<leader>sw", function() vim.cmd "set list!" end, "toggle invisibles")
n("<leader>zc", function() vim.opt.conceallevel = vim.opt.conceallevel == 0 and 2 or 0 end, "Toggle conceal")
n("<leader>zg", "<cmd>GitSignsToggle<cr>", "Toggle git signs")
n("<leader>zl", function() vim.bo.list = not vim.bo.list end, "Toggle list")
n("<leader>zi", "<cmd>IndentGuidesToggle<cr>", "Toggle guides")
n("<leader>zI", "<cmd>IndentDetect<cr>", "Detect indent")
n("<leader>zo", "<cmd>SymbolsOutline<cr>", "Toggle symbols")
n("<leader>zp", function() vim.o.paste = not vim.o.paste end, "Toggle paste")
n("<leader>zr", function() vim.wo.ruler = not vim.wo.ruler end, "Toggle ruler")
n("<leader>zs", function() vim.bo.spell = not vim.bo.spell end, "Toggle spell")
n("<leader>zw", function()
  vim.ui.input({ prompt = "set shiftwidth " }, function(input)
    local n = tonumber(input)
    if n then vim.o.shiftwidth = n end
  end)
end, "Set shiftwidth")
n("<leader>zW", function() vim.wo.wrap = not vim.wo.wrap end, "Toggle wrap")

-- Quickfix
n("<leader>qq", "<cmd>copen<cr>", "copen")
n("<leader>qc", "<cmd>cclose<cr>", "cclose")
n("<leader>qn", "<cmd>cnext<cr>", "cnext")
n("<leader>qp", "<cmd>cprev<cr>", "cprev")

-- Tabs
n("<leader>tn", "<cmd>tabNext<cr>", "next tab")
n("<leader>tp", "<cmd>tabprev<cr>", "prev tab")

-- Terminal
n("<leader>Tt", "<cmd>ToggleTerm direction=float<cr>", "float term")

-- Terminal mode navigation / escape
t("<esc><esc>", [[<C-\><C-n>]], "term: normal mode")
t("jk", [[<C-\><C-n>]], "term: normal mode")
t("<C-h>", [[<Cmd>wincmd h<CR>]], "term: left")
t("<C-j>", [[<Cmd>wincmd j<CR>]], "term: down")
t("<C-k>", [[<Cmd>wincmd k<CR>]], "term: up")
t("<C-l>", [[<Cmd>wincmd l<CR>]], "term: right")

-- Groups for which-key (register all at end if available)
pcall(function()
  local wk = require "which-key"
  wk.add {
    { "<leader>a", group = "Action" },
    { "<leader>c", desc = "comment toggle" },
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "Debugger" },
    { "<leader>f", group = "Find (Snacks)" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Help" },
    { "<leader>i", group = "Insert" },
    { "<leader>l", group = "LSP" },
    { "<leader>o", group = "Ollama" },
    { "<leader>p", group = "Project" },
    { "<leader>V", group = "neoVIM" },
    { "<leader>q", group = "Quickfix" },
    { "<leader>r", group = "Rust" },
    { "<leader>s", group = "Search (Snacks)" },
    { "<leader>t", group = "Tab" },
    { "<leader>T", group = "Terminal" },
    { "<leader>x", group = "Execute" },
    { "<leader>y", group = "Yank/dup" },
    { "<leader>z", group = "Toggle" },
    { "<leader>C", group = "Copilot" },
    { "<leader>G", group = "Go" },
    { "<leader>m", group = "Move" },
  }
end)
