-- start with all builtin telescope finders.
local finder = require "telescope.builtin"

-- add a few handy aliases for easier use.
finder.qf = finder.quickfix
finder.help = finder.help_tags
finder.man = finder.man_pages
finder.symbol = finder.symbols
finder.file = finder.find_files
finder.command = finder.commands
finder.buffer = finder.buffers

finder.buffer = function()
  require("telescope.builtin").buffers {
    ignore_current_buffer = true,
    sort_lastused = true,
  }
end

local finder_names = vim.tbl_keys(finder)
table.sort(finder_names) -- ensure the table is alphabetically sorted.

vim.api.nvim_create_user_command("Find", function(ctx)
  local cmd = vim.trim(ctx.args or "")
  if finder[cmd] then
    finder[cmd]()
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

return finder
