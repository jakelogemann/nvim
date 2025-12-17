--- Lightweight umbrella :Find {subcommand} dispatcher built on Snacks pickers.
-- Falls back to vim built-ins if Snacks is unavailable.
local subcommands = {}

local function snacks()
  return _G.Snacks and Snacks.picker or nil
end

subcommands.qf = function()
  local p = snacks()
  if p and p.qflist then p.qflist() else vim.cmd.copen() end
end
subcommands.help = function()
  local p = snacks()
  if p and p.help then p.help() else vim.cmd.help() end
end
subcommands.man = function()
  local p = snacks()
  if p and p.man then p.man() else vim.cmd.Man() end
end
subcommands.symbol = function()
  local p = snacks()
  if p and p.lsp_symbols then p.lsp_symbols() else vim.lsp.buf.document_symbol() end
end
subcommands.file = function()
  local p = snacks()
  if p and p.files then p.files() else vim.cmd("find ") end
end
subcommands.command = function()
  local p = snacks()
  if p and p.commands then p.commands() else vim.cmd("command") end
end
subcommands.buffer = function()
  local p = snacks()
  if p and p.buffers then p.buffers() else vim.cmd.buffers() end
end

local finder_names = vim.tbl_keys(subcommands)
table.sort(finder_names) -- ensure the table is alphabetically sorted.

vim.api.nvim_create_user_command("Find", function(ctx)
  local cmd = vim.trim(ctx.args or "")
  if subcommands[cmd] then
    subcommands[cmd]()
  else
    return
  end
end, {
  nargs = 1, --"?",
  desc = "Find anything!",
  complete = function(_, line)
    return vim.tbl_filter(function(key) return key:find(line:match "^%s*%w+ (%w*)" or "") == 1 end, finder_names)
  end,
})
