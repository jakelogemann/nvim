--- Lightweight umbrella :Find {subcommand} dispatcher built on custom.pick.
local pick = require "custom.pick"
local subcommands = {}

subcommands.qf = function() vim.cmd.copen() end
subcommands.help = function() vim.cmd.help() end
subcommands.man = function() vim.cmd.Man() end
subcommands.symbol = function() pick.lsp_symbols() end
subcommands.file = function() pick.files() end
subcommands.buffer = function() pick.buffers() end
subcommands.grep = function() pick.grep() end
subcommands.smart = function() pick.smart() end
subcommands.recent = function() pick.recent() end
subcommands.projects = function() pick.projects() end
subcommands.undo = function() pick.undo() end
subcommands.notifications = function() pick.notifications() end
subcommands.commands = function()
  local p = pick.ensure()
  if p and p.commands then return p.commands() end
  vim.cmd "command"
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
  nargs = 1,
  desc = "Find anything!",
  complete = function(_, line)
    return vim.tbl_filter(function(key) return key:find(line:match "^%s*%w+ (%w*)" or "") == 1 end, finder_names)
  end,
})

-- Convenience aliases using unified custom.pick wrappers
vim.api.nvim_create_user_command("Files", function() pick.files() end, { desc = "Find files (project root)" })
vim.api.nvim_create_user_command("Rg", function() pick.grep() end, { desc = "Grep (project root)" })
vim.api.nvim_create_user_command("Buffers", function() pick.buffers() end, { desc = "Open buffers" })

-- Set cwd to detected project root
vim.api.nvim_create_user_command("RootHere", function()
  local root = pick.root()
  if not root or root == "" then return end
  vim.cmd.cd(root)
  vim.notify("cd " .. root)
end, { desc = "Set cwd to project root" })
