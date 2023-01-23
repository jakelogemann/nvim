local find = vim.empty_dict()

find.qf = function() require("telescope.builtin").quickfix {} end

find.loclist = function() require("telescope.builtin").loclist {} end

find.help = function() require("telescope.builtin").help_tags {} end

find.manpage = function() require("telescope.builtin").man_pages {} end

find.symbol = function() require("telescope.builtin").symbols {} end

find.file = function() require("telescope.builtin").find_files {} end

find.command = function() require("telescope.builtin").commands {} end

find.buffer = function()
  require("telescope.builtin").buffers {
    ignore_current_buffer = true,
    sort_lastused = true,
  }
end

vim.api.nvim_create_user_command("Find", function(args)
  local cmd = vim.trim(args.args or "")
  if cmd == "" then
    return
  elseif find[cmd] then
    find[cmd]()
  else
    -- should handle errors
    return
  end
end, {
  nargs = 1, --"?",
  desc = "Find anything!",
  complete = function(_, line)
    if line:match "^%s*Find %w+ " then return {} end
    return vim.tbl_filter(function(key) return key:find(line:match "^%s*Find (%w*)" or "") == 1 end, vim.tbl_keys(find))
  end,
})

return find
