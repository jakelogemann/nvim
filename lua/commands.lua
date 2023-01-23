local new_command = function(name, desc, func) vim.api.nvim_create_user_command(name, func, { desc = desc }) end

new_command("FindFiles", "Interactively search for files", function() require("telescope.builtin").find_files {} end)
new_command("GrepByWord", "Interactively grep by word", function() require("telescope.builtin").grep_string {} end)
new_command("Symbols", "Interactively find symbols", function() require("telescope.builtin").symbols {} end)
new_command("FindCommands", "Interactively find commands", function() require("telescope.builtin").commands {} end)
new_command("ManPages", "Interactively find man pages", function() require("telescope.builtin").man_pages {} end)
new_command("QF", "Interactively find quickfix", function() require("telescope.builtin").quickfix {} end)
new_command("LOC", "Interactively find loclist", function() require("telescope.builtin").loclist {} end)
new_command("ToggleLineNumbers", "toggle line numbers in current buffer", function()
  local ln = vim.opt.number:get()
  vim.wo.number = not ln
  vim.wo.relativenumber = ln
end)

new_command("FindHelp", "Interactively find help tags", function() require("telescope.builtin").help_tags {} end)

new_command(
  "Buffers",
  "Find an open buffer",
  function()
    require("telescope.builtin").buffers {
      ignore_current_buffer = true,
      sort_lastused = true,
    }
  end
)

local toggle_subcommands = {
  number = function()
    vim.wo.number = not vim.wo.number
    vim.wo.relativenumber = false
  end,
  relativenumber = function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.wo.number = true
  end,
  wrap = function() vim.wo.wrap = not vim.wo.wrap end,
  spell = function() vim.wo.spell = not vim.wo.spell end,
  cursorline = function() vim.opt.cursorline = not vim.opt.cursorline end,
  list = function() vim.wo.list = not vim.wo.list end,
}

vim.api.nvim_create_user_command("Toggle", function(args)
  local cmd = vim.trim(args.args or "")
  if cmd == "" then
    return
  elseif toggle_subcommands[cmd] then
    toggle_subcommands[cmd]()
  else
    -- should handle errors
    return
  end
end, {
  nargs = 1, --"?",
  desc = "Toggle anything!",
  complete = function(_, line)
    if line:match "^%s*Toggle %w+ " then return {} end
    return vim.tbl_filter(
      function(key) return key:find(line:match "^%s*Toggle (%w*)" or "") == 1 end,
      vim.tbl_keys(toggle_subcommands)
    )
  end,
})
