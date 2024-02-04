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
