-- if vim.fn.has "nvim-0.8" ~= 1 or vim.version().prerelease then
--   vim.api.nvim_echo(table.concat({
--     "Unsupported Neovim Version!",
--     "Please ensure you have read the requirements carefully!",
--   }, " "))
-- end

-- install profiling, if available.
local ok, profiler = pcall(require, "impatient")
if ok then profiler.enable_profile() end

-- options MUST be loaded 1st (first)
-- plugins MUST be loaded 2nd (second)
require "options"
require "plugins"
-- other requirements are unordered:
require "autocmds"
require "toggle"
require "commands"
require "mappings"
