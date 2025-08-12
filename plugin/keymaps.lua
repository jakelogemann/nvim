-- Centralized keymaps for plugin management & config/source exploration
-- Loaded automatically (in plugin/ directory)
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Plugin management (Lazy / Mason)
map("n", "<leader>pl", "<cmd>Lazy<cr>", "Lazy: UI")
map("n", "<leader>ps", "<cmd>Lazy sync<cr>", "Lazy: sync (install/update)")
map("n", "<leader>pu", "<cmd>Lazy update<cr>", "Lazy: update only")
map("n", "<leader>pp", "<cmd>Lazy profile<cr>", "Lazy: profile load times")
map("n", "<leader>pm", "<cmd>Mason<cr>", "Mason: LSP/DAP/tools UI")

-- Config navigation helpers
local config_root = vim.fn.stdpath("config")

map("n", "<leader>pi", function()
  vim.cmd.edit(config_root .. "/init.lua")
end, "Edit init.lua")

map("n", "<leader>pf", function()
  require("telescope.builtin").find_files({ cwd = config_root, prompt_title = "Config files" })
end, "Find config files")

map("n", "<leader>pP", function()
  require("telescope.builtin").find_files({ cwd = config_root .. "/lua/custom/plugins", prompt_title = "Plugin specs" })
end, "Find plugin specs")

-- Runtime & Lua source exploration
map("n", "<leader>pR", function()
  require("telescope.builtin").find_files({
    prompt_title = "Runtime files",
    search_dirs = vim.api.nvim_list_runtime_paths(),
  })
end, "Find runtime files")

map("n", "<leader>pL", function()
  require("telescope.builtin").live_grep({
    prompt_title = "Lua (config) grep",
    search_dirs = { config_root .. "/lua" },
    additional_args = function() return { "--glob", "*.lua" } end,
  })
end, "Grep Lua in config")

map("n", "<leader>pS", function()
  -- Broader Lua search across runtime (can be large)
  require("telescope.builtin").live_grep({
    prompt_title = "Lua (runtime) grep",
    search_dirs = vim.tbl_map(function(p) return p .. "/lua" end, vim.api.nvim_list_runtime_paths()),
    additional_args = function() return { "--glob", "*.lua" } end,
  })
end, "Grep Lua in runtime")

-- Optional: quick open Mason log (if exists)
map("n", "<leader>pM", function()
  local log = vim.fn.stdpath("cache") .. "/mason.log"
  if vim.loop.fs_stat(log) then
    vim.cmd.edit(log)
  else
    vim.notify("No mason.log yet", vim.log.levels.INFO)
  end
end, "Open mason.log")

-- Register group with which-key if present (non-eager)
pcall(function()
  require("which-key").add({ { "<leader>p", group = "Plugins" } })
end)
