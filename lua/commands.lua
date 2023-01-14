local cmd = function(name, desc, func) vim.api.nvim_create_user_command(name, func, { desc = desc }) end

cmd("FindFiles", "Interactively search for files", function() require("telescope.builtin").find_files {} end)
cmd("GrepByWord", "Interactively grep by word", function() require("telescope.builtin").grep_string {} end)
cmd("FindHelp", "Interactively find help tags", function() require("telescope.builtin").help_tags {} end)
cmd("Symbols", "Interactively find symbols", function() require("telescope.builtin").symbols {} end)
cmd("FindCommands", "Interactively find commands", function() require("telescope.builtin").commands {} end)
cmd("Buffers", "Interactively find open buffers", function() require("telescope.builtin").buffers {} end)
cmd("ManPages", "Interactively find man pages", function() require("telescope.builtin").man_pages {} end)
cmd("QF", "Interactively find quickfix", function() require("telescope.builtin").quickfix {} end)
cmd("LOC", "Interactively find loclist", function() require("telescope.builtin").loclist {} end)
