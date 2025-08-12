--- Lightweight umbrella :Find {subcommand} dispatcher over telescope builtins.
-- Extend the `subcommands` table to add new aliases. Provides custom completion.
local subcommands = {}
local builtins = require "telescope.builtin"

subcommands.qf = builtins.quickfix
subcommands.help = builtins.help_tags
subcommands.man = builtins.man_pages
subcommands.symbol = builtins.symbols
subcommands.file = builtins.find_files
subcommands.command = builtins.commands
subcommands.buffer = builtins.buffers

subcommands.buffer = function()
  require("telescope.builtin").buffers {
    ignore_current_buffer = true,
    sort_lastused = true,
  }
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
