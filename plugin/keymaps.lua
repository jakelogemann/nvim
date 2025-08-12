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

-- General
n("<C-s>", "<cmd>write<cr>", "write buffer")
n("<leader><leader>", "<c-^>", "alternate buffer")
n("<c-w>\\", function()
  local ok, w = pcall(require, "which-key")
  if ok then w.show { keys = "<c-w>", loop = true } end
end, "window mode")

-- Plugin management
n("<leader>pl", "<cmd>Lazy<cr>", "Lazy: UI")
n("<leader>ps", "<cmd>Lazy sync<cr>", "Lazy: sync (install/update)")
n("<leader>pu", "<cmd>Lazy update<cr>", "Lazy: update only")
n("<leader>pp", "<cmd>Lazy profile<cr>", "Lazy: profile load times")
n("<leader>pm", "<cmd>Mason<cr>", "Mason: UI")

-- Buffers
n("<leader>bN", "<cmd>bnew<cr>", "new buffer")
n("<leader>bd", "<cmd>bdelete<cr>", "delete buffer")
n("<leader>be", "<cmd>enew<cr>", "new scratch")
n("<leader>bn", "<cmd>bNext<cr>", "next buffer")
n("<leader>bp", "<cmd>bprev<cr>", "prev buffer")
n("<leader>bw", "<cmd>write<cr>", "write buffer")

-- Files / project config
n("<leader>pi", function() vim.cmd.edit(config_root .. "/init.lua") end, "Edit init.lua")
n(
  "<leader>pf",
  function() require("telescope.builtin").find_files { cwd = config_root, prompt_title = "Config files" } end,
  "Find config files"
)
n(
  "<leader>pP",
  function()
    require("telescope.builtin").find_files { cwd = config_root .. "/lua/custom/plugins", prompt_title = "Plugin specs" }
  end,
  "Find plugin specs"
)
n(
  "<leader>pR",
  function()
    require("telescope.builtin").find_files {
      prompt_title = "Runtime files",
      search_dirs = vim.api.nvim_list_runtime_paths(),
    }
  end,
  "Find runtime files"
)
n("<leader>pL", function()
  require("telescope.builtin").live_grep {
    prompt_title = "Lua (config) grep",
    search_dirs = { config_root .. "/lua" },
    additional_args = function() return { "--glob", "*.lua" } end,
  }
end, "Grep Lua in config")
n("<leader>pS", function()
  require("telescope.builtin").live_grep {
    prompt_title = "Lua (runtime) grep",
    search_dirs = vim.tbl_map(function(p) return p .. "/lua" end, vim.api.nvim_list_runtime_paths()),
    additional_args = function() return { "--glob", "*.lua" } end,
  }
end, "Grep Lua runtime")
n("<leader>pM", function()
  local log = vim.fn.stdpath "cache" .. "/mason.log"
  if vim.loop.fs_stat(log) then
    vim.cmd.edit(log)
  else
    vim.notify("No mason.log yet", vim.log.levels.INFO)
  end
end, "Open mason.log")
n("<leader>pc", "<cmd>Neoconf<cr>", "project config")
n("<leader>ps", function()
  local ok, p = pcall(require, "persistence")
  if ok then p.load() end
end, "session load")
n("<leader>pS", function()
  local ok, p = pcall(require, "persistence")
  if ok then p.load { last = true } end
end, "last session")
n("<leader>p/", "<cmd>Telescope find_files<cr>", "find file")

-- Find (Telescope)
n("<leader>ff", "<cmd>Telescope find_files<cr>", "find files")
n("<leader>fg", "<cmd>Telescope live_grep<cr>", "live grep")
n("<leader>fh", "<cmd>Telescope help_tags<cr>", "help tags")
n("<leader>fo", "<cmd>Oil<cr>", "file explorer")
n("<leader>sg", "<cmd>Telescope grep_string<cr>", "grep word")

-- Git
n("<leader>gg", "<cmd>Neogit kind=tab<cr>", "git gui")
n("<leader>gs", "<cmd>Telescope git_status<cr>", "git status")
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
n("<leader>qq", "<cmd>copen<cr>", "open quickfix")
n("<leader>qc", "<cmd>cclose<cr>", "close quickfix")
n("<leader>qn", "<cmd>cnext<cr>", "next qf")
n("<leader>qp", "<cmd>cprev<cr>", "prev qf")

-- Tabs
n("<leader>tn", "<cmd>tabNext<cr>", "next tab")
n("<leader>tp", "<cmd>tabprev<cr>", "prev tab")

-- Terminal
n("<leader>Tt", "<cmd>ToggleTerm direction=float<cr>", "float term")

-- Groups for which-key (register all at end if available)
pcall(function()
  local wk = require "which-key"
  wk.add {
    { "<leader>a", group = "Action" },
    { "<leader>c", desc = "comment toggle" },
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "Debugger" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Help" },
    { "<leader>i", group = "Insert" },
    { "<leader>l", group = "LSP" },
    { "<leader>o", group = "Ollama" },
    { "<leader>p", group = "Project" },
    { "<leader>q", group = "Quickfix" },
    { "<leader>r", group = "Rust" },
    { "<leader>s", group = "Search" },
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
